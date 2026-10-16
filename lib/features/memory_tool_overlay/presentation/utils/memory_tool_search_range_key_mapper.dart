import 'package:JsxposedX/features/memory_tool_overlay/presentation/enums/memory_search_range_section_enum.dart';

String mapMemorySearchRangeSectionKey(MemorySearchRangeSectionEnum section) {
  return switch (section) {
    MemorySearchRangeSectionEnum.anonymous => 'anonymous',
    MemorySearchRangeSectionEnum.java => 'java',
    MemorySearchRangeSectionEnum.javaHeap => 'javaHeap',
    MemorySearchRangeSectionEnum.cAlloc => 'cAlloc',
    MemorySearchRangeSectionEnum.cHeap => 'cHeap',
    MemorySearchRangeSectionEnum.cData => 'cData',
    MemorySearchRangeSectionEnum.cBss => 'cBss',
    MemorySearchRangeSectionEnum.codeApp => 'codeApp',
    MemorySearchRangeSectionEnum.codeSys => 'codeSys',
    MemorySearchRangeSectionEnum.stack => 'stack',
    MemorySearchRangeSectionEnum.ashmem => 'ashmem',
    MemorySearchRangeSectionEnum.other => 'other',
    MemorySearchRangeSectionEnum.bad => 'bad',
  };
}
