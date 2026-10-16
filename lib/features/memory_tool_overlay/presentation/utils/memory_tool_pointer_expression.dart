import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_query_repository.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_pointer_utils.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_region_owner_resolver.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

const int _memoryToolExpressionRegionPageSize = 1024;

class MemoryToolPointerExpression {
  const MemoryToolPointerExpression({
    required this.address,
    required this.offsets,
    this.soName,
    this.memoryCode,
  });

  final String? soName;
  final String? memoryCode;
  final int address;
  final List<int> offsets;
}

MemoryToolPointerExpression? tryParseMemoryToolPointerExpression(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final addrMatch = RegExp(
    r'\baddr\s*:\s*([^,\}\s]+)',
    caseSensitive: false,
  ).firstMatch(trimmed);
  final offsetsMatch = RegExp(
    r'\boffsets\s*:\s*\[([^\]]*)\]',
    caseSensitive: false,
    dotAll: true,
  ).firstMatch(trimmed);
  if (addrMatch == null || offsetsMatch == null) {
    return null;
  }

  final address = _tryParseExpressionNumber(addrMatch.group(1));
  if (address == null || address < 0) {
    return null;
  }

  final offsetsLiteral = offsetsMatch.group(1)?.trim() ?? '';
  final offsets = <int>[];
  if (offsetsLiteral.isNotEmpty) {
    for (final segment in offsetsLiteral.split(',')) {
      final parsedOffset = _tryParseExpressionNumber(segment);
      if (parsedOffset == null) {
        return null;
      }
      offsets.add(parsedOffset);
    }
  }

  final soName = RegExp(
    r'\bso\s*:\s*"([^"]*)"',
    caseSensitive: false,
  ).firstMatch(trimmed)?.group(1);
  final memoryCode = RegExp(
    r'\bmemory\s*:\s*"([^"]*)"',
    caseSensitive: false,
  ).firstMatch(trimmed)?.group(1);

  return MemoryToolPointerExpression(
    soName: soName == null || soName.isEmpty ? null : soName,
    memoryCode: memoryCode == null || memoryCode.isEmpty ? null : memoryCode,
    address: address,
    offsets: offsets,
  );
}

Future<int> resolveMemoryToolPointerExpressionTargetAddress({
  required MemoryQueryRepository repository,
  required int pid,
  required MemoryToolPointerExpression expression,
  List<MemoryRegion>? readableRegions,
}) async {
  var regions = readableRegions;
  if ((expression.soName?.isNotEmpty ?? false) &&
      (regions == null || regions.isEmpty)) {
    regions = await _loadReadableMemoryRegions(repository: repository, pid: pid);
  }
  final initialAddress = _resolveExpressionStartAddress(
    expression: expression,
    regions: regions ?? const <MemoryRegion>[],
  );
  if (initialAddress < 0) {
    throw FormatException('Invalid address');
  }
  if (expression.offsets.isEmpty) {
    return initialAddress;
  }

  regions ??= await _loadReadableMemoryRegions(repository: repository, pid: pid);
  int? preferredPointerWidth;
  var currentAddress = initialAddress;
  for (final offset in expression.offsets) {
    if (!_isReadablePointerAddress(regions: regions, address: currentAddress)) {
      throw StateError('Unreadable pointer');
    }
    final pointerRead = await _readPointerWithBestWidth(
      repository: repository,
      pid: pid,
      address: currentAddress,
      regions: regions,
      preferredPointerWidth: preferredPointerWidth,
    );
    if (pointerRead == null) {
      throw StateError('Unreadable pointer');
    }
    preferredPointerWidth = pointerRead.pointerWidth;
    currentAddress = pointerRead.value + offset;
    if (currentAddress < 0) {
      throw FormatException('Invalid address');
    }
  }
  return currentAddress;
}

Future<List<MemoryRegion>> _loadReadableMemoryRegions({
  required MemoryQueryRepository repository,
  required int pid,
}) async {
  final regions = <MemoryRegion>[];
  var offset = 0;

  while (true) {
    final page = await repository.getMemoryRegions(
      pid: pid,
      offset: offset,
      limit: _memoryToolExpressionRegionPageSize,
      readableOnly: true,
      includeAnonymous: true,
      includeFileBacked: true,
    );
    if (page.isEmpty) {
      break;
    }
    regions.addAll(page);
    if (page.length < _memoryToolExpressionRegionPageSize) {
      break;
    }
    offset += page.length;
  }

  regions.sort((left, right) => left.startAddress.compareTo(right.startAddress));
  return regions;
}

int _resolveExpressionStartAddress({
  required MemoryToolPointerExpression expression,
  required List<MemoryRegion> regions,
}) {
  if (_findRegionContainingAddress(regions, expression.address) != null) {
    return expression.address;
  }

  final soName = expression.soName;
  if (soName == null || soName.isEmpty) {
    return expression.address;
  }

  final regionTypeKey = _mapExpressionMemoryCodeToRegionTypeKey(
    expression.memoryCode,
  );
  for (final region in regions) {
    if (extractMemoryToolSharedObjectName(region.path) != soName) {
      continue;
    }
    if (regionTypeKey != null &&
        _mapMemoryRegionTypeKey(region) != regionTypeKey) {
      continue;
    }
    if (expression.address >= 0 && expression.address < region.size) {
      return region.startAddress + expression.address;
    }
  }

  return expression.address;
}

Future<({int value, int pointerWidth})?> _readPointerWithBestWidth({
  required MemoryQueryRepository repository,
  required int pid,
  required int address,
  required List<MemoryRegion> regions,
  required int? preferredPointerWidth,
}) async {
  final widths = preferredPointerWidth == null
      ? const <int>[8, 4]
      : <int>[preferredPointerWidth, preferredPointerWidth == 8 ? 4 : 8];
  ({int value, int pointerWidth, int score})? bestCandidate;

  for (final width in widths) {
    final previews = await repository.readMemoryValues(
      requests: <MemoryReadRequest>[
        MemoryReadRequest(
          pid: pid,
          address: address,
          type: width == 8 ? SearchValueType.i64 : SearchValueType.i32,
          length: width,
        ),
      ],
    );
    if (previews.isEmpty) {
      continue;
    }

    final decodedAddress = decodeMemoryToolPointerAddress(previews.first.rawBytes);
    if (decodedAddress == null || decodedAddress < 0) {
      continue;
    }

    final candidate = (
      value: decodedAddress,
      pointerWidth: width,
      score: _scoreDecodedPointerAddress(
        decodedAddress: decodedAddress,
        regions: regions,
      ),
    );
    if (bestCandidate == null ||
        candidate.score > bestCandidate.score ||
        (candidate.score == bestCandidate.score &&
            preferredPointerWidth != null &&
            candidate.pointerWidth == preferredPointerWidth)) {
      bestCandidate = candidate;
    }
  }

  if (bestCandidate == null) {
    return null;
  }
  return (
    value: bestCandidate.value,
    pointerWidth: bestCandidate.pointerWidth,
  );
}

int _scoreDecodedPointerAddress({
  required int decodedAddress,
  required List<MemoryRegion> regions,
}) {
  if (_findRegionContainingAddress(regions, decodedAddress) != null) {
    return 3;
  }
  if (regions.isEmpty) {
    return 0;
  }
  if (decodedAddress >= 0 && decodedAddress <= regions.last.endAddress) {
    return 1;
  }
  return 0;
}

bool _isReadablePointerAddress({
  required List<MemoryRegion> regions,
  required int address,
}) {
  if (address < 0) {
    return false;
  }

  for (final region in regions) {
    if (address < region.startAddress) {
      return false;
    }
    if (address >= region.startAddress && address + 4 <= region.endAddress) {
      return true;
    }
    if (address < region.endAddress) {
      return false;
    }
  }
  return false;
}

MemoryRegion? _findRegionContainingAddress(
  List<MemoryRegion> regions,
  int address,
) {
  for (final region in regions) {
    if (address < region.startAddress) {
      return null;
    }
    if (address >= region.startAddress && address < region.endAddress) {
      return region;
    }
  }
  return null;
}

int? _tryParseExpressionNumber(String? input) {
  if (input == null) {
    return null;
  }
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final normalized = trimmed.replaceAll(' ', '');
  final isNegative = normalized.startsWith('-');
  final unsigned = normalized.startsWith('+') || isNegative
      ? normalized.substring(1)
      : normalized;
  if (unsigned.isEmpty) {
    return null;
  }

  if (unsigned.toLowerCase().startsWith('0x')) {
    final hex = unsigned.substring(2);
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) {
      return null;
    }
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) {
      return null;
    }
    return isNegative ? -parsed : parsed;
  }

  if (!RegExp(r'^\d+$').hasMatch(unsigned)) {
    return null;
  }
  final parsed = int.tryParse(unsigned);
  if (parsed == null) {
    return null;
  }
  return isNegative ? -parsed : parsed;
}

String? _mapExpressionMemoryCodeToRegionTypeKey(String? memoryCode) {
  return switch (memoryCode) {
    'Cb' => 'cBss',
    'Cd' => 'cData',
    'Ca' => 'cAlloc',
    'Ch' => 'cHeap',
    'Xa' => 'codeApp',
    'Xs' => 'codeSys',
    'J' => 'java',
    'Jh' => 'javaHeap',
    'S' => 'stack',
    'As' => 'ashmem',
    'B' => 'bad',
    'O' => 'other',
    'A' => null,
    _ => null,
  };
}

String _mapMemoryRegionTypeKey(MemoryRegion region) {
  final lowerPath = (region.path ?? '').toLowerCase();
  final executable = region.perms.length > 2 && region.perms[2] == 'x';
  final isAppPath =
      lowerPath.startsWith('/data/app/') ||
      lowerPath.startsWith('/data/data/') ||
      lowerPath.startsWith('/mnt/expand/');
  final isSystemPath =
      lowerPath.startsWith('/system/') ||
      lowerPath.startsWith('/apex/') ||
      lowerPath.startsWith('/vendor/') ||
      lowerPath.startsWith('/product/');

  if (region.perms.isEmpty || region.perms[0] != 'r') {
    return 'bad';
  }
  if (lowerPath.contains('[stack')) {
    return 'stack';
  }
  if (lowerPath.contains('ashmem')) {
    if (lowerPath.contains('dalvik')) {
      return 'javaHeap';
    }
    return 'ashmem';
  }
  if (lowerPath.contains('dalvik-main space') ||
      lowerPath.contains('dalvik-allocspace') ||
      lowerPath.contains('dalvik-large object space') ||
      lowerPath.contains('dalvik-free list large object space') ||
      lowerPath.contains('dalvik-non moving space') ||
      lowerPath.contains('dalvik-zygote space')) {
    return 'javaHeap';
  }
  if (lowerPath.contains('dalvik') ||
      lowerPath.contains('.art') ||
      lowerPath.contains('.oat') ||
      lowerPath.contains('.odex')) {
    return 'java';
  }
  if (lowerPath.contains('[heap]')) {
    return 'cHeap';
  }
  if (lowerPath.contains('malloc') ||
      lowerPath.contains('scudo:') ||
      lowerPath.contains('jemalloc') ||
      lowerPath.contains('[anon:libc_malloc]')) {
    return 'cAlloc';
  }
  if (lowerPath.contains('.bss') || lowerPath.contains('[anon:.bss')) {
    return 'cBss';
  }
  if (executable) {
    if (isAppPath) {
      return 'codeApp';
    }
    if (isSystemPath || !region.isAnonymous) {
      return 'codeSys';
    }
  }
  if (!region.isAnonymous) {
    if (lowerPath.contains('.data') ||
        lowerPath.contains('/data/app/') ||
        lowerPath.contains('/data/data/')) {
      return 'cData';
    }
    return 'other';
  }
  return 'other';
}
