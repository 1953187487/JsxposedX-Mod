import 'dart:typed_data';

import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryToolSavedItem {
  const MemoryToolSavedItem({
    required this.pid,
    required this.address,
    required this.regionStart,
    required this.regionTypeKey,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
    required this.isFrozen,
    required this.entryKind,
    this.instructionText,
  }) : assert(
         entryKind != MemoryToolEntryKind.instruction ||
             instructionText != null,
         'instruction entries require instructionText',
       );

  final int pid;
  final int address;
  final int regionStart;
  final String regionTypeKey;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;
  final bool isFrozen;
  final MemoryToolEntryKind entryKind;
  final String? instructionText;

  bool get isInstruction => entryKind == MemoryToolEntryKind.instruction;

  String get effectiveInstructionText {
    final value = instructionText?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return displayValue;
  }

  factory MemoryToolSavedItem.fromSearchResult({
    required int pid,
    required SearchResult result,
    MemoryValuePreview? preview,
    required bool isFrozen,
    required MemoryToolEntryKind entryKind,
    String? instructionText,
  }) {
    return MemoryToolSavedItem(
      pid: pid,
      address: result.address,
      regionStart: result.regionStart,
      regionTypeKey: result.regionTypeKey,
      type: preview?.type ?? result.type,
      rawBytes: preview?.rawBytes ?? result.rawBytes,
      displayValue:
          instructionText ??
          preview?.displayValue ??
          result.displayValue,
      isFrozen: isFrozen,
      entryKind: entryKind,
      instructionText: instructionText,
    );
  }

  MemoryToolSavedItem copyWith({
    int? pid,
    int? address,
    int? regionStart,
    String? regionTypeKey,
    SearchValueType? type,
    Uint8List? rawBytes,
    String? displayValue,
    bool? isFrozen,
    MemoryToolEntryKind? entryKind,
    String? instructionText,
  }) {
    return MemoryToolSavedItem(
      pid: pid ?? this.pid,
      address: address ?? this.address,
      regionStart: regionStart ?? this.regionStart,
      regionTypeKey: regionTypeKey ?? this.regionTypeKey,
      type: type ?? this.type,
      rawBytes: rawBytes ?? this.rawBytes,
      displayValue: displayValue ?? this.displayValue,
      isFrozen: isFrozen ?? this.isFrozen,
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
      displayValue: isInstruction ? effectiveInstructionText : displayValue,
    );
  }
}
