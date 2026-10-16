import 'dart:math' as math;

import 'package:JsxposedX/generated/memory_tool.g.dart';

double? resolveMemoryToolSearchTaskProgress(SearchTaskState state) {
  if (state.totalBytes > 0) {
    return math.min(1.0, state.processedBytes / state.totalBytes);
  }
  if (state.totalEntries > 0) {
    return math.min(1.0, state.processedEntries / state.totalEntries);
  }
  if (state.totalRegions > 0) {
    return math.min(1.0, state.processedRegions / state.totalRegions);
  }
  return null;
}
