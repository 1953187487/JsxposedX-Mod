import 'dart:typed_data';

const int memoryToolGroupSearchMaxWindow = 4096;

enum MemoryToolGroupSearchParseError {
  empty,
  missingWindow,
  invalidWindow,
  windowTooLarge,
  tooFewConditions,
  invalidCondition,
  unsupportedType,
  invalidValue,
  invalidOffset,
}

class MemoryToolGroupSearchParseException implements Exception {
  const MemoryToolGroupSearchParseException(this.error);

  final MemoryToolGroupSearchParseError error;

  @override
  String toString() => 'MemoryToolGroupSearchParseException($error)';
}

String normalizeMemoryToolGroupSearchDsl(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.empty,
    );
  }

  final windowSeparatorIndex = trimmed.indexOf('::');
  if (windowSeparatorIndex < 0 ||
      windowSeparatorIndex != trimmed.lastIndexOf('::')) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.missingWindow,
    );
  }

  final conditionPart = trimmed.substring(0, windowSeparatorIndex).trim();
  final windowPart = trimmed.substring(windowSeparatorIndex + 2).trim();
  final window = _parseNonNegativeInt(windowPart);
  if (window == null || window <= 0) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidWindow,
    );
  }
  if (window > memoryToolGroupSearchMaxWindow) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.windowTooLarge,
    );
  }

  final conditionParts = conditionPart
      .split(';')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (conditionParts.length < 2) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.tooFewConditions,
    );
  }

  final normalizedConditions = <String>[];
  for (var index = 0; index < conditionParts.length; ++index) {
    normalizedConditions.add(
      _normalizeCondition(
        conditionParts[index],
        window,
        isAnchorCondition: index == 0,
      ),
    );
  }

  return '${normalizedConditions.join(';')}::$window';
}

String _normalizeCondition(
  String condition,
  int window, {
  required bool isAnchorCondition,
}) {
  final colonIndex = condition.indexOf(':');
  if (colonIndex <= 0 || colonIndex == condition.length - 1) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidCondition,
    );
  }

  final type = condition.substring(0, colonIndex).trim().toLowerCase();
  final valueAndOffset = condition.substring(colonIndex + 1).trim();
  if (!_supportedTypes.contains(type)) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.unsupportedType,
    );
  }

  String value = valueAndOffset;
  int? offset;
  final atIndex = valueAndOffset.lastIndexOf('@');
  if (atIndex >= 0) {
    value = valueAndOffset.substring(0, atIndex).trim();
    final offsetPart = valueAndOffset.substring(atIndex + 1).trim();
    offset = _parseNonNegativeInt(offsetPart);
    if (offset == null ||
        offset > window ||
        (isAnchorCondition && offset != 0)) {
      throw const MemoryToolGroupSearchParseException(
        MemoryToolGroupSearchParseError.invalidOffset,
      );
    }
  }

  final normalizedValue = switch (type) {
    'i8' => _normalizeInteger(value, BigInt.from(-128), BigInt.from(127)),
    'i16' => _normalizeInteger(value, BigInt.from(-32768), BigInt.from(32767)),
    'i32' => _normalizeInteger(
      value,
      BigInt.from(-2147483648),
      BigInt.from(2147483647),
    ),
    'i64' => _normalizeInteger(
      value,
      BigInt.parse('-9223372036854775808'),
      BigInt.parse('9223372036854775807'),
    ),
    'f32' || 'f64' => _normalizeFloat(value),
    'bytes' => _normalizeBytes(value),
    'utf8' || 'utf16' => _normalizeText(value),
    _ => throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.unsupportedType,
    ),
  };

  return offset == null
      ? '$type:$normalizedValue'
      : '$type:$normalizedValue@$offset';
}

String _normalizeInteger(String raw, BigInt min, BigInt max) {
  final parsed = _parseInteger(raw.trim());
  if (parsed == null || parsed < min || parsed > max) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidValue,
    );
  }
  return raw.trim();
}

String _normalizeFloat(String raw) {
  final trimmed = raw.trim();
  final parsed = double.tryParse(trimmed);
  if (parsed == null ||
      !parsed.isFinite ||
      trimmed.contains(RegExp(r'0x', caseSensitive: false))) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidValue,
    );
  }
  return trimmed;
}

String _normalizeBytes(String raw) {
  final bytes = parseMemoryToolGroupSearchBytes(raw);
  final pairs = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
      .toList(growable: false);
  return pairs.join(' ');
}

String _normalizeText(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty ||
      trimmed.contains(';') ||
      trimmed.contains('::') ||
      trimmed.contains('@')) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidValue,
    );
  }
  return trimmed;
}

Uint8List parseMemoryToolGroupSearchBytes(String raw) {
  final sanitized = raw
      .trim()
      .replaceAll(RegExp(r'0x', caseSensitive: false), '')
      .replaceAll(RegExp(r'[\s,]+'), '');
  if (sanitized.isEmpty ||
      sanitized.length.isOdd ||
      sanitized.contains(RegExp(r'[^0-9a-fA-F]'))) {
    throw const MemoryToolGroupSearchParseException(
      MemoryToolGroupSearchParseError.invalidValue,
    );
  }

  final bytes = <int>[];
  for (var index = 0; index < sanitized.length; index += 2) {
    final value = int.tryParse(
      sanitized.substring(index, index + 2),
      radix: 16,
    );
    if (value == null) {
      throw const MemoryToolGroupSearchParseException(
        MemoryToolGroupSearchParseError.invalidValue,
      );
    }
    bytes.add(value);
  }
  return Uint8List.fromList(bytes);
}

BigInt? _parseInteger(String raw) {
  if (raw.isEmpty) {
    return null;
  }
  final negative = raw.startsWith('-');
  final unsigned = negative || raw.startsWith('+') ? raw.substring(1) : raw;
  if (unsigned.startsWith(RegExp(r'0x', caseSensitive: false))) {
    final parsed = BigInt.tryParse(unsigned.substring(2), radix: 16);
    if (parsed == null) {
      return null;
    }
    return negative ? -parsed : parsed;
  }
  return BigInt.tryParse(raw);
}

int? _parseNonNegativeInt(String raw) {
  final parsed = _parseInteger(raw.trim());
  if (parsed == null || parsed < BigInt.zero) {
    return null;
  }
  return parsed.isValidInt ? parsed.toInt() : null;
}

const Set<String> _supportedTypes = <String>{
  'i8',
  'i16',
  'i32',
  'i64',
  'f32',
  'f64',
  'bytes',
  'utf8',
  'utf16',
};
