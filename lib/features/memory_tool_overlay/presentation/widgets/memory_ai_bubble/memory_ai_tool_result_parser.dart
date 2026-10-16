enum MemoryAiToolRowType {
  raw,
  searchResult,
  valuePreview,
  instructionPreview,
  breakpoint,
  breakpointHit,
  pointerResult,
  pointerChaseHint,
  autoChaseLayer,
}

class MemoryAiToolResultData {
  const MemoryAiToolResultData({
    required this.isSuccess,
    required this.isPending,
    required this.toolName,
    required this.summary,
    required this.rawText,
    required this.sections,
    required this.tokens,
  });

  final bool isSuccess;
  final bool isPending;
  final String? toolName;
  final String summary;
  final String rawText;
  final List<MemoryAiToolSectionData> sections;
  final List<String> tokens;
}

class MemoryAiToolSectionData {
  const MemoryAiToolSectionData({
    required this.title,
    required this.overviewFields,
    required this.rows,
  });

  final String? title;
  final Map<String, String> overviewFields;
  final List<MemoryAiToolRowData> rows;

  bool get hasContent => overviewFields.isNotEmpty || rows.isNotEmpty;
}

class MemoryAiToolRowData {
  const MemoryAiToolRowData({
    required this.type,
    required this.raw,
    required this.fields,
  });

  final MemoryAiToolRowType type;
  final String raw;
  final Map<String, String> fields;
}

class MemoryAiToolResultParser {
  static final RegExp _statusMarkerPattern = RegExp(r'^[✅❌⏳]\s*');
  static final RegExp _addressPattern = RegExp(r'^0x[0-9a-fA-F]+$');
  static final RegExp _tokenPattern = RegExp(
    r'(0x[0-9a-fA-F]+|(?:[A-Za-z0-9_\-./]+\.so)|(?:[A-Za-z]:\\[^\s]+)|(?:\/[^\s]+))',
  );

  const MemoryAiToolResultParser._();

  static MemoryAiToolResultData parse(String rawText) {
    final normalized = rawText.trim();
    final isSuccess = normalized.startsWith('✅');
    final isPending = normalized.startsWith('⏳');
    final withoutMarker = normalized
        .replaceFirst(_statusMarkerPattern, '')
        .trim();
    final toolName = _extractToolName(withoutMarker);
    final normalizedLines = withoutMarker
        .split('\n')
        .map(_normalizeDisplayLine)
        .where((line) => line.trim().isNotEmpty)
        .toList(growable: false);
    final lines = normalizedLines
        .where((line) => !_isSuggestionNoise(line.trim()))
        .where((line) => !_isStackTraceNoise(line.trim()))
        .toList(growable: false);
    final summary = lines.isEmpty
        ? withoutMarker
        : _normalizeSummary(lines.first);
    final detailLines = lines.length > 1
        ? lines.skip(1).map((line) => line.trim()).toList(growable: false)
        : const <String>[];

    return MemoryAiToolResultData(
      isSuccess: isSuccess,
      isPending: isPending,
      toolName: toolName,
      summary: summary,
      rawText: rawText.trim(),
      sections: _parseSections(detailLines),
      tokens: _extractTokens(rawText),
    );
  }

  static Map<String, String> parseInlineFields(String line) {
    var normalized = line.trim();
    if (normalized.startsWith('- ')) {
      normalized = normalized.substring(2).trim();
    }

    final fields = <String, String>{};
    final segments = normalized.split('|');
    for (var index = 0; index < segments.length; index += 1) {
      final segment = segments[index].trim();
      if (segment.isEmpty) {
        continue;
      }

      final separatorIndex = segment.indexOf('=');
      if (separatorIndex > 0) {
        final key = segment.substring(0, separatorIndex).trim();
        final value = segment.substring(separatorIndex + 1).trim();
        if (key.isNotEmpty) {
          fields[key] = value;
        }
        continue;
      }

      if (index == 0 && _addressPattern.hasMatch(segment)) {
        fields['address'] = segment;
      } else {
        fields['text_${fields.length}'] = segment;
      }
    }

    return fields;
  }

  static List<MemoryAiToolSectionData> _parseSections(List<String> lines) {
    if (lines.isEmpty) {
      return const <MemoryAiToolSectionData>[];
    }

    final sections = <MemoryAiToolSectionData>[];
    String? currentTitle;
    final currentLines = <String>[];

    void flush() {
      if (currentTitle == null && currentLines.isEmpty) {
        return;
      }
      final section = _buildSection(
        title: currentTitle,
        lines: List<String>.from(currentLines),
      );
      if (section.hasContent) {
        sections.add(section);
      }
      currentTitle = null;
      currentLines.clear();
    }

    for (final line in lines) {
      final normalized = line.trim();
      if (normalized.isEmpty) {
        flush();
        continue;
      }
      if (_isSectionHeaderLine(normalized)) {
        flush();
        currentTitle = _stripTrailingColon(normalized);
        continue;
      }
      currentLines.add(normalized);
    }

    flush();
    return sections;
  }

  static MemoryAiToolSectionData _buildSection({
    required String? title,
    required List<String> lines,
  }) {
    final overviewFields = <String, String>{};
    final rows = <MemoryAiToolRowData>[];

    for (final line in lines) {
      final overviewEntry = _parseOverviewField(line);
      if (overviewEntry != null) {
        overviewFields[overviewEntry.key] = overviewEntry.value;
        continue;
      }
      rows.add(
        MemoryAiToolRowData(
          type: _resolveRowType(title, line),
          raw: line,
          fields: parseInlineFields(line),
        ),
      );
    }

    return MemoryAiToolSectionData(
      title: title,
      overviewFields: overviewFields,
      rows: rows,
    );
  }

  static MapEntry<String, String>? _parseOverviewField(String line) {
    final normalized = line.trim();
    if (!normalized.startsWith('- ')) {
      return null;
    }

    final payload = normalized.substring(2).trim();
    final colonIndex = payload.indexOf(':');
    if (colonIndex <= 0) {
      return null;
    }

    final key = payload.substring(0, colonIndex).trim();
    final value = payload.substring(colonIndex + 1).trim();
    if (key.isEmpty) {
      return null;
    }
    return MapEntry<String, String>(key, value);
  }

  static bool _isSectionHeaderLine(String line) {
    if (line.startsWith('- ')) {
      return false;
    }
    if (!(line.endsWith('：') || line.endsWith(':'))) {
      return false;
    }
    return !line.contains('=');
  }

  static MemoryAiToolRowType _resolveRowType(String? title, String line) {
    final fields = parseInlineFields(line);
    final titleText = title ?? '';

    if (fields.containsKey('breakpointId')) {
      return MemoryAiToolRowType.breakpointHit;
    }
    if (fields.containsKey('id') && fields.containsKey('address')) {
      return MemoryAiToolRowType.breakpoint;
    }
    if (fields.containsKey('pointer') && fields.containsKey('target')) {
      return MemoryAiToolRowType.pointerResult;
    }
    if (fields.containsKey('isTerminalStaticCandidate') ||
        fields.containsKey('stopReasonKey')) {
      return MemoryAiToolRowType.pointerChaseHint;
    }
    if (fields.containsKey('layer') && fields.containsKey('target')) {
      return MemoryAiToolRowType.autoChaseLayer;
    }
    if (fields.containsKey('arch') || fields.containsKey('asm')) {
      return MemoryAiToolRowType.instructionPreview;
    }
    if (fields.containsKey('address') &&
        fields.containsKey('type') &&
        fields.containsKey('value')) {
      if (fields.containsKey('regionStart') ||
          titleText.contains('搜索结果') ||
          titleText.contains('search')) {
        return MemoryAiToolRowType.searchResult;
      }
      return MemoryAiToolRowType.valuePreview;
    }
    if (fields.containsKey('regionStart') && fields.containsKey('value')) {
      return MemoryAiToolRowType.searchResult;
    }
    return MemoryAiToolRowType.raw;
  }

  static String _normalizeSummary(String summary) {
    final stripped = _stripSuggestionTail(summary.trim());
    final cleaned = _stripTrailingColon(stripped);
    return cleaned.isEmpty ? summary.trim() : cleaned;
  }

  static String _stripTrailingColon(String value) {
    if (value.endsWith('：') || value.endsWith(':')) {
      return value.substring(0, value.length - 1).trimRight();
    }
    return value;
  }

  static String? _extractToolName(String text) {
    final firstLine = text
        .split('\n')
        .map((line) => line.trim())
        .firstWhere((line) => line.isNotEmpty, orElse: () => '');
    if (firstLine.isEmpty) {
      return null;
    }
    final match = RegExp(r'`([^`]+)`').firstMatch(firstLine);
    return match?.group(1)?.trim();
  }

  static List<String> _extractTokens(String text) {
    final results = <String>[];
    for (final match in _tokenPattern.allMatches(text)) {
      final token = match.group(0);
      if (token == null || results.contains(token)) {
        continue;
      }
      results.add(token);
      if (results.length >= 6) {
        break;
      }
    }
    return results;
  }

  static bool _isSuggestionNoise(String line) {
    final normalized = line.trim();
    if (normalized.isEmpty) {
      return false;
    }
    if (normalized.contains('=') || normalized.startsWith('- ')) {
      return false;
    }
    return normalized.startsWith('建议') ||
        normalized.startsWith('可继续') ||
        normalized.startsWith('可以继续') ||
        normalized.startsWith('下一步') ||
        normalized.toLowerCase().startsWith('you can ') ||
        normalized.toLowerCase().startsWith('next step');
  }

  static bool _isStackTraceNoise(String line) {
    final normalized = line.trimLeft();
    return normalized.startsWith('at ') ||
        normalized.startsWith('#0') ||
        normalized.startsWith('#1') ||
        normalized.startsWith('#2') ||
        normalized.startsWith('dart:') ||
        normalized.startsWith('package:');
  }

  static String _normalizeDisplayLine(String line) {
    var normalized = line.trimRight();
    if (normalized.isEmpty) {
      return normalized;
    }

    final platformExceptionMatch = RegExp(
      r'PlatformException\([^,]+,\s*([^,]+)',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (platformExceptionMatch != null) {
      normalized = platformExceptionMatch.group(1)?.trim() ?? normalized;
    }

    normalized = normalized
        .replaceFirst(RegExp(r'^Bad state:\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Exception:\s*', caseSensitive: false), '')
        .replaceFirst(
          RegExp(r'^Invalid argument\(s\):\s*', caseSensitive: false),
          '',
        )
        .trim();

    final illegalStateIndex = normalized.indexOf(
      'java.lang.IllegalStateException:',
    );
    if (illegalStateIndex >= 0) {
      normalized = normalized
          .substring(
            illegalStateIndex + 'java.lang.IllegalStateException:'.length,
          )
          .trim();
    }

    final noActiveSearchIndex = normalized.toLowerCase().indexOf(
      'no active search session',
    );
    if (noActiveSearchIndex >= 0) {
      return '当前没有活动搜索会话。';
    }

    final noActivePointerIndex = normalized.toLowerCase().indexOf(
      'no active pointer scan session',
    );
    if (noActivePointerIndex >= 0) {
      return '当前没有活动指针扫描会话。';
    }

    final noActiveAutoChaseIndex = normalized.toLowerCase().indexOf(
      'no active pointer auto chase',
    );
    if (noActiveAutoChaseIndex >= 0) {
      return '当前没有活动自动追链任务。';
    }

    final causeIndex = normalized.indexOf('Cause:');
    if (causeIndex >= 0) {
      return normalized.substring(causeIndex + 'Cause:'.length).trim();
    }

    final stacktraceIndex = normalized.indexOf('stacktrace:');
    if (stacktraceIndex > 0) {
      normalized = normalized.substring(0, stacktraceIndex).trimRight();
    }
    return normalized;
  }

  static String _stripSuggestionTail(String summary) {
    final candidates = <String>[
      '建议',
      '可继续',
      '可以继续',
      '下一步',
      'You can ',
      'Next step',
    ];
    var result = summary;
    for (final candidate in candidates) {
      final index = result.indexOf(candidate);
      if (index > 0) {
        result = result.substring(0, index).trimRight();
      }
    }

    while (result.endsWith('。') ||
        result.endsWith('.') ||
        result.endsWith('!') ||
        result.endsWith('！')) {
      result = result.substring(0, result.length - 1).trimRight();
    }
    return result;
  }
}
