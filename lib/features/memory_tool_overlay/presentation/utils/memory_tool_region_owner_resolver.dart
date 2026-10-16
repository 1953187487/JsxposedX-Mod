import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_query_repository.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

const int _memoryToolRegionOwnerPageSize = 1024;
const int _memoryToolRegionOwnerMaxGap = 0x400000;

Future<String> resolveMemoryToolRegionOwnerSoName({
  required MemoryQueryRepository repository,
  required int pid,
  required int regionStart,
}) async {
  final regions = await _loadAllMemoryRegions(
    repository: repository,
    pid: pid,
  );
  if (regions.isEmpty) {
    return '';
  }

  final targetIndex = regions.indexWhere((region) => region.startAddress == regionStart);
  if (targetIndex < 0) {
    return '';
  }

  final directSoName = extractMemoryToolSharedObjectName(
    regions[targetIndex].path,
  );
  if (directSoName.isNotEmpty) {
    return directSoName;
  }

  return _resolveNearbyOwnerSoName(
    regions: regions,
    targetIndex: targetIndex,
  );
}

String extractMemoryToolSharedObjectName(String? path) {
  if (path == null || path.isEmpty) {
    return '';
  }

  final normalizedPath = path.replaceAll('\\', '/');
  RegExpMatch? matchedSo;
  for (final match
      in RegExp(r'([^/]+\.so)\b', caseSensitive: false).allMatches(normalizedPath)) {
    matchedSo = match;
  }
  if (matchedSo == null) {
    return '';
  }
  return matchedSo.group(1) ?? '';
}

Future<List<MemoryRegion>> _loadAllMemoryRegions({
  required MemoryQueryRepository repository,
  required int pid,
}) async {
  final regions = <MemoryRegion>[];
  var offset = 0;

  while (true) {
    final page = await repository.getMemoryRegions(
      pid: pid,
      offset: offset,
      limit: _memoryToolRegionOwnerPageSize,
      readableOnly: false,
      includeAnonymous: true,
      includeFileBacked: true,
    );
    if (page.isEmpty) {
      break;
    }
    regions.addAll(page);
    if (page.length < _memoryToolRegionOwnerPageSize) {
      break;
    }
    offset += page.length;
  }

  return regions;
}

String _resolveNearbyOwnerSoName({
  required List<MemoryRegion> regions,
  required int targetIndex,
}) {
  final targetRegion = regions[targetIndex];
  final candidateMatches = <({int gap, String soName})>[];

  for (var step = 1; step < regions.length; step += 1) {
    final previousIndex = targetIndex - step;
    if (previousIndex >= 0) {
      final previousRegion = regions[previousIndex];
      final previousSoName = extractMemoryToolSharedObjectName(previousRegion.path);
      if (previousSoName.isNotEmpty) {
        final gap = targetRegion.startAddress - previousRegion.endAddress;
        if (gap >= 0 && gap <= _memoryToolRegionOwnerMaxGap) {
          candidateMatches.add((gap: gap, soName: previousSoName));
        }
      }
    }

    final nextIndex = targetIndex + step;
    if (nextIndex < regions.length) {
      final nextRegion = regions[nextIndex];
      final nextSoName = extractMemoryToolSharedObjectName(nextRegion.path);
      if (nextSoName.isNotEmpty) {
        final gap = nextRegion.startAddress - targetRegion.endAddress;
        if (gap >= 0 && gap <= _memoryToolRegionOwnerMaxGap) {
          candidateMatches.add((gap: gap, soName: nextSoName));
        }
      }
    }

    if (candidateMatches.isNotEmpty) {
      candidateMatches.sort((left, right) => left.gap.compareTo(right.gap));
      return candidateMatches.first.soName;
    }
  }

  return '';
}
