import 'dart:typed_data';

import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryToolDisplayItem {
  const MemoryToolDisplayItem({
    required this.address,
    required this.regionStart,
    required this.regionTypeKey,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
    this.entryKind = MemoryToolEntryKind.value,
    this.instructionText,
  }) : assert(
         entryKind != MemoryToolEntryKind.instruction ||
             instructionText != null,
         'instruction entries require instructionText',
       );

  final int address;
  final int regionStart;
  final String regionTypeKey;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;
  final MemoryToolEntryKind entryKind;
  final String? instructionText;

  bool get isInstruction => entryKind == MemoryToolEntryKind.instruction;

  String get effectiveDisplayValue {
    final resolvedInstruction = instructionText?.trim();
    if (isInstruction && resolvedInstruction != null && resolvedInstruction.isNotEmpty) {
      return resolvedInstruction;
    }
    return displayValue;
  }

  factory MemoryToolDisplayItem.fromSearchResult({
    required SearchResult result,
    MemoryToolEntryKind entryKind = MemoryToolEntryKind.value,
    String? instructionText,
  }) {
    return MemoryToolDisplayItem(
      address: result.address,
      regionStart: result.regionStart,
      regionTypeKey: result.regionTypeKey,
      type: result.type,
      rawBytes: result.rawBytes,
      displayValue: instructionText ?? result.displayValue,
      entryKind: entryKind,
      instructionText: instructionText,
    );
  }

  MemoryToolDisplayItem copyWith({
    int? address,
    int? regionStart,
    String? regionTypeKey,
    SearchValueType? type,
    Uint8List? rawBytes,
    String? displayValue,
    MemoryToolEntryKind? entryKind,
    String? instructionText,
  }) {
    return MemoryToolDisplayItem(
      address: address ?? this.address,
      regionStart: regionStart ?? this.regionStart,
      regionTypeKey: regionTypeKey ?? this.regionTypeKey,
      type: type ?? this.type,
      rawBytes: rawBytes ?? this.rawBytes,
      displayValue: displayValue ?? this.displayValue,
      entryKind: entryKind ?? this.entryKind,
      instructionText: instructionText ?? this.instructionText,
    );
  }

  SearchResult toSearchResult() {
    return SearchResult(
      address: address,
      regionStart: regionStart,
      regionTypeKey: regionTypeKey,
      type: type,
      rawBytes: rawBytes,
      displayValue: effectiveDisplayValue,
    );
  }
}
