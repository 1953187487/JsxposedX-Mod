import 'dart:convert';
import 'dart:typed_data';

import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';

class MemoryToolDebugBreakpointValueInfo {
  const MemoryToolDebugBreakpointValueInfo({
    required this.rawBytes,
    required this.displayValue,
    required this.preview,
    required this.result,
  });

  final Uint8List rawBytes;
  final String displayValue;
  final MemoryValuePreview preview;
  final SearchResult result;
}

class MemoryToolDebugWriterGroup {
  const MemoryToolDebugWriterGroup({
    required this.key,
    required this.pc,
    required this.moduleName,
    required this.moduleOffset,
    required this.instructionText,
    required this.hitCount,
    required this.threadCount,
    required this.latestTimestamp,
    required this.hits,
    required this.topTransition,
  });

  final String key;
  final int pc;
  final String moduleName;
  final int moduleOffset;
  final String instructionText;
  final int hitCount;
  final int threadCount;
  final int latestTimestamp;
  final List<MemoryBreakpointHit> hits;
  final MemoryToolDebugWriterTransition? topTransition;
}

class MemoryToolDebugWriterTransition {
  const MemoryToolDebugWriterTransition({
    required this.summary,
    required this.count,
    required this.latestTimestamp,
  });

  final String summary;
  final int count;
  final int latestTimestamp;
}

class MemoryToolDebugHitChangeLine {
  const MemoryToolDebugHitChangeLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class MemoryToolDebugHitChangeInfo {
  const MemoryToolDebugHitChangeInfo({
    required this.lines,
    required this.primarySummary,
  });

  final List<MemoryToolDebugHitChangeLine> lines;
  final String primarySummary;

  String get displayText =>
      lines.map((line) => '${line.label}: ${line.value}').join('\n');
}

MemoryBreakpoint? resolveMemoryToolDebugSelectedBreakpoint({
  required List<MemoryBreakpoint> breakpoints,
  required String? selectedBreakpointId,
}) {
  for (final breakpoint in breakpoints) {
    if (breakpoint.id == selectedBreakpointId) {
      return breakpoint;
    }
  }
  if (breakpoints.isEmpty) {
    return null;
  }
  return breakpoints.first;
}

MemoryToolDebugWriterGroup? resolveMemoryToolDebugSelectedWriterGroup({
  required List<MemoryToolDebugWriterGroup> groups,
  required String? selectedWriterKey,
}) {
  for (final group in groups) {
    if (group.key == selectedWriterKey) {
      return group;
    }
  }
  if (groups.isEmpty) {
    return null;
  }
  return groups.first;
}

MemoryBreakpointHit? resolveMemoryToolDebugSelectedHit({
  required List<MemoryBreakpointHit> hits,
  required String? selectedHitKey,
}) {
  for (final hit in hits) {
    if (buildMemoryToolDebugHitKey(hit) == selectedHitKey) {
      return hit;
    }
  }
  if (hits.isEmpty) {
    return null;
  }
  return hits.first;
}

List<MemoryToolDebugWriterGroup> buildMemoryToolDebugWriterGroups(
  List<MemoryBreakpointHit> hits,
) {
  final grouped = <String, List<MemoryBreakpointHit>>{};
  for (final hit in hits) {
    grouped.putIfAbsent(buildMemoryToolDebugWriterKey(hit), () => <MemoryBreakpointHit>[]).add(hit);
  }
  final groups = grouped.entries.map((entry) {
    final sortedHits = entry.value.toList(growable: false)
      ..sort((left, right) => right.timestampMillis.compareTo(left.timestampMillis));
    final transitions = buildMemoryToolDebugTransitions(sortedHits);
    return MemoryToolDebugWriterGroup(
      key: entry.key,
      pc: sortedHits.first.pc,
      moduleName: sortedHits.first.moduleName,
      moduleOffset: sortedHits.first.moduleOffset,
      instructionText: sortedHits.first.instructionText,
      hitCount: sortedHits.length,
      threadCount: sortedHits.map((hit) => hit.threadId).toSet().length,
      latestTimestamp: sortedHits.first.timestampMillis,
      hits: sortedHits,
      topTransition: transitions.isEmpty ? null : transitions.first,
    );
  }).toList(growable: false)
    ..sort((left, right) {
      final countCompare = right.hitCount.compareTo(left.hitCount);
      if (countCompare != 0) {
        return countCompare;
      }
      return right.latestTimestamp.compareTo(left.latestTimestamp);
    });
  return groups;
}

List<MemoryToolDebugWriterTransition> buildMemoryToolDebugTransitions(
  List<MemoryBreakpointHit> hits,
) {
  final grouped = <String, List<MemoryBreakpointHit>>{};
  for (final hit in hits) {
    grouped.putIfAbsent(
      formatMemoryToolDebugTransition(hit.oldValue, hit.newValue),
      () => <MemoryBreakpointHit>[],
    ).add(hit);
  }
  final transitions = grouped.entries.map((entry) {
    final sortedHits = entry.value.toList(growable: false)
      ..sort((left, right) => right.timestampMillis.compareTo(left.timestampMillis));
    return MemoryToolDebugWriterTransition(
      summary: entry.key,
      count: sortedHits.length,
      latestTimestamp: sortedHits.first.timestampMillis,
    );
  }).toList(growable: false)
    ..sort((left, right) {
      final countCompare = right.count.compareTo(left.count);
      if (countCompare != 0) {
        return countCompare;
      }
      return right.latestTimestamp.compareTo(left.latestTimestamp);
    });
  return transitions;
}

String buildMemoryToolDebugHitKey(MemoryBreakpointHit? hit) {
  if (hit == null) {
    return '';
  }
  return '${hit.timestampMillis}_${hit.threadId}_${hit.pc}_${formatMemoryToolDebugTransition(hit.oldValue, hit.newValue)}';
}

String buildMemoryToolDebugWriterKey(MemoryBreakpointHit hit) {
  return '${hit.pc}_${hit.moduleName}_${hit.moduleOffset}_${hit.instructionText}';
}

String formatMemoryToolDebugInstruction(String instruction) {
  return instruction.trim().replaceAll(RegExp(r'\s+'), ' ');
}

String formatMemoryToolDebugTransition(Uint8List oldValue, Uint8List newValue) {
  return '${formatMemoryToolDebugBytes(oldValue)} -> ${formatMemoryToolDebugBytes(newValue)}';
}

String formatMemoryToolDebugBytes(Uint8List bytes) {
  if (bytes.isEmpty) {
    return '--';
  }
  return bytes
      .map((value) => value.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
}

String formatMemoryToolDebugTimestamp(int millis) {
  final time = DateTime.fromMillisecondsSinceEpoch(millis);
  final year = time.year.toString().padLeft(4, '0');
  final month = time.month.toString().padLeft(2, '0');
  final day = time.day.toString().padLeft(2, '0');
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute:$second';
}

String formatMemoryToolDebugModuleOffset(
  MemoryToolDebugWriterGroup group, {
  required String anonymousModuleLabel,
}) {
  final moduleName =
      group.moduleName.isEmpty ? anonymousModuleLabel : group.moduleName;
  return '$moduleName+0x${group.moduleOffset.toRadixString(16).toUpperCase()}';
}

String formatMemoryToolDebugAccessType(
  AppLocalizations l10n,
  MemoryBreakpointAccessType type,
) {
  return switch (type) {
    MemoryBreakpointAccessType.read => l10n.memoryToolDebugAccessRead,
    MemoryBreakpointAccessType.write => l10n.memoryToolDebugAccessWrite,
    MemoryBreakpointAccessType.readWrite => l10n.memoryToolDebugAccessReadWrite,
  };
}

MemoryToolDebugHitChangeInfo? buildMemoryToolDebugHitChangeInfo({
  required MemoryBreakpoint? breakpoint,
  required MemoryBreakpointHit? hit,
}) {
  if (hit == null) {
    return null;
  }

  final oldValue = hit.oldValue;
  final newValue = hit.newValue;
  final lines = <MemoryToolDebugHitChangeLine>[];
  final addedLabels = <String>{};

  void addLine(String label, String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty || !addedLabels.add(label)) {
      return;
    }
    lines.add(MemoryToolDebugHitChangeLine(label: label, value: trimmedValue));
  }

  final primaryType = breakpoint?.type;
  if (primaryType != null &&
      _supportsDebugHitChangeType(
        type: primaryType,
        oldValue: oldValue,
        newValue: newValue,
      )) {
    addLine(
      _mapDebugHitChangeTypeLabel(primaryType),
      _formatDebugHitChangeForType(
        type: primaryType,
        oldValue: oldValue,
        newValue: newValue,
      ),
    );
  }

  addLine(
    'HEX',
    '${formatMemoryToolDebugBytes(oldValue)} -> ${formatMemoryToolDebugBytes(newValue)}',
  );

  final textTransition = _tryFormatDebugHitTextTransition(oldValue, newValue);
  if (textTransition != null) {
    addLine(textTransition.$1, textTransition.$2);
  }

  for (final type in const <SearchValueType>[
    SearchValueType.i8,
    SearchValueType.i16,
    SearchValueType.i32,
    SearchValueType.i64,
    SearchValueType.f32,
    SearchValueType.f64,
  ]) {
    if (type == primaryType ||
        !_supportsDebugHitChangeType(
          type: type,
          oldValue: oldValue,
          newValue: newValue,
        )) {
      continue;
    }
    addLine(
      _mapDebugHitChangeTypeLabel(type),
      _formatDebugHitChangeForType(
        type: type,
        oldValue: oldValue,
        newValue: newValue,
      ),
    );
  }

  if (lines.isEmpty) {
    return null;
  }

  return MemoryToolDebugHitChangeInfo(
    lines: lines,
    primarySummary: lines.first.value,
  );
}

MemoryToolDebugBreakpointValueInfo? resolveMemoryToolDebugBreakpointValueInfo({
  required MemoryBreakpoint? breakpoint,
  required MemoryBreakpointHit? hit,
}) {
  if (breakpoint == null) {
    return null;
  }
  final hasHitValue = hit != null;
  final rawBytes = hasHitValue ? hit.newValue : Uint8List(0);
  final displayValue = hasHitValue
      ? resolveMemoryToolSearchResultValueByType(
          type: breakpoint.type,
          rawBytes: rawBytes,
          fallbackDisplayValue: formatMemoryToolDebugBytes(rawBytes),
        )
      : '--';
  final preview = MemoryValuePreview(
    address: breakpoint.address,
    type: breakpoint.type,
    rawBytes: rawBytes,
    displayValue: displayValue,
  );
  final result = SearchResult(
    address: breakpoint.address,
    regionStart: breakpoint.address,
    regionTypeKey: 'other',
    type: breakpoint.type,
    rawBytes: rawBytes,
    displayValue: displayValue,
  );
  return MemoryToolDebugBreakpointValueInfo(
    rawBytes: rawBytes,
    displayValue: displayValue,
    preview: preview,
    result: result,
  );
}

bool _supportsDebugHitChangeType({
  required SearchValueType type,
  required Uint8List oldValue,
  required Uint8List newValue,
}) {
  final requiredLength = switch (type) {
    SearchValueType.i8 => 1,
    SearchValueType.i16 => 2,
    SearchValueType.i32 || SearchValueType.f32 => 4,
    SearchValueType.i64 || SearchValueType.f64 => 8,
    SearchValueType.bytes => 1,
  };
  return oldValue.length >= requiredLength && newValue.length >= requiredLength;
}

String _mapDebugHitChangeTypeLabel(SearchValueType type) {
  return switch (type) {
    SearchValueType.i8 => 'I8',
    SearchValueType.i16 => 'I16',
    SearchValueType.i32 => 'I32',
    SearchValueType.i64 => 'I64',
    SearchValueType.f32 => 'F32',
    SearchValueType.f64 => 'F64',
    SearchValueType.bytes => 'HEX',
  };
}

String _formatDebugHitChangeForType({
  required SearchValueType type,
  required Uint8List oldValue,
  required Uint8List newValue,
}) {
  final oldDisplay = resolveMemoryToolSearchResultValueByType(
    type: type,
    rawBytes: oldValue,
    fallbackDisplayValue: formatMemoryToolDebugBytes(oldValue),
  );
  final newDisplay = resolveMemoryToolSearchResultValueByType(
    type: type,
    rawBytes: newValue,
    fallbackDisplayValue: formatMemoryToolDebugBytes(newValue),
  );
  return '$oldDisplay -> $newDisplay';
}

(String, String)? _tryFormatDebugHitTextTransition(
  Uint8List oldValue,
  Uint8List newValue,
) {
  final utf8Old = _tryDecodeDebugText(oldValue, utf16: false);
  final utf8New = _tryDecodeDebugText(newValue, utf16: false);
  if (utf8Old != null && utf8New != null) {
    return ('UTF-8', '"$utf8Old" -> "$utf8New"');
  }

  final utf16Old = _tryDecodeDebugText(oldValue, utf16: true);
  final utf16New = _tryDecodeDebugText(newValue, utf16: true);
  if (utf16Old != null && utf16New != null) {
    return ('UTF-16', '"$utf16Old" -> "$utf16New"');
  }
  return null;
}

String? _tryDecodeDebugText(Uint8List rawBytes, {required bool utf16}) {
  if (rawBytes.isEmpty) {
    return null;
  }

  try {
    final decoded = utf16
        ? _decodeUtf16LeDebugText(rawBytes)
        : utf8.decode(rawBytes, allowMalformed: false);
    return _isReadableDebugText(decoded) ? decoded : null;
  } catch (_) {
    return null;
  }
}

String _decodeUtf16LeDebugText(Uint8List rawBytes) {
  if (rawBytes.length < 2 || rawBytes.length.isOdd) {
    throw const FormatException('Invalid UTF-16 bytes.');
  }
  final codeUnits = <int>[];
  for (int index = 0; index < rawBytes.length; index += 2) {
    codeUnits.add(rawBytes[index] | (rawBytes[index + 1] << 8));
  }
  return String.fromCharCodes(codeUnits);
}

bool _isReadableDebugText(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return false;
  }
  for (final codePoint in trimmed.runes) {
    if (codePoint == 0) {
      return false;
    }
    final isControl =
        codePoint < 32 && codePoint != 9 && codePoint != 10 && codePoint != 13;
    if (isControl) {
      return false;
    }
  }
  return true;
}
