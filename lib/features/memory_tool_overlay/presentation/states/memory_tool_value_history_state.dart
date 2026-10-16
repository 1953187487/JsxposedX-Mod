import 'dart:typed_data';

import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryToolValueHistoryEntryState {
  const MemoryToolValueHistoryEntryState({
    required this.address,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
  });

  factory MemoryToolValueHistoryEntryState.fromPreview(
    MemoryValuePreview preview,
  ) {
    return MemoryToolValueHistoryEntryState(
      address: preview.address,
      type: preview.type,
      rawBytes: Uint8List.fromList(preview.rawBytes),
      displayValue: preview.displayValue,
    );
  }

  final int address;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;

  MemoryValuePreview toPreview() {
    return MemoryValuePreview(
      address: address,
      type: type,
      rawBytes: Uint8List.fromList(rawBytes),
      displayValue: displayValue,
    );
  }
}
