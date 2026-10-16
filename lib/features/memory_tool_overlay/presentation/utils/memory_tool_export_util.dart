import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;

class MemoryToolExportItem {
  const MemoryToolExportItem({
    required this.address,
    this.pid,
    this.regionStart,
    this.regionTypeKey,
    this.valueType,
    this.displayValue,
    this.rawBytes,
    this.isFrozen = false,
    this.entryKind = MemoryToolEntryKind.value,
    this.instructionText,
    this.extra = const <String, Object?>{},
  });

  final int address;
  final int? pid;
  final int? regionStart;
  final String? regionTypeKey;
  final SearchValueType? valueType;
  final String? displayValue;
  final Uint8List? rawBytes;
  final bool isFrozen;
  final MemoryToolEntryKind entryKind;
  final String? instructionText;
  final Map<String, Object?> extra;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'address': formatMemoryToolSearchResultAddress(address),
      'address_decimal': address,
      'is_frozen': isFrozen,
      'entry_kind': entryKind.name,
    };
    if (pid != null) {
      data['pid'] = pid;
    }
    if (regionStart != null) {
      data['region_start'] = formatMemoryToolSearchResultAddress(regionStart!);
      data['region_start_decimal'] = regionStart;
    }
    if (regionTypeKey != null && regionTypeKey!.isNotEmpty) {
      data['region_type'] = regionTypeKey;
    }
    if (valueType != null) {
      data['value_type'] = valueType.toString().split('.').last;
    }
    if (displayValue != null) {
      data['display_value'] = displayValue;
    }
    if (rawBytes != null) {
      data['raw_hex'] = formatMemoryToolSearchResultHex(rawBytes!);
    }
    if (instructionText != null && instructionText!.trim().isNotEmpty) {
      data['instruction_text'] = instructionText;
    }
    if (extra.isNotEmpty) {
      data['extra'] = extra;
    }
    return data;
  }
}

Future<File?> exportMemoryToolItemsToLocal({
  required BuildContext context,
  required WidgetRef ref,
  required String sourceKey,
  required List<MemoryToolExportItem> items,
  int? pid,
  Map<String, Object?> meta = const <String, Object?>{},
}) async {
  if (items.isEmpty) {
    return null;
  }

  final exportedAt = DateTime.now();
  final normalizedSourceKey = _normalizeSourceKey(sourceKey);
  final payload = <String, dynamic>{
    'exported_at': exportedAt.toIso8601String(),
    'source': normalizedSourceKey,
    'count': items.length,
    'items': items.map((item) => item.toJson()).toList(growable: false),
  };
  if (pid != null) {
    payload['pid'] = pid;
  }
  if (meta.isNotEmpty) {
    payload['meta'] = meta;
  }

  try {
    final fileName =
        'memory_${normalizedSourceKey}_export_${pid ?? 'unknown'}_${exportedAt.millisecondsSinceEpoch}.json';
    final candidateDirectories = <Directory>[
      if (Platform.isAndroid)
        Directory(
          '/storage/emulated/0/Download/JsxposedX/exports/memory_tool_$normalizedSourceKey',
        ),
      Directory(
        p.join(
          Directory.systemTemp.path,
          'JsxposedX',
          'exports',
          'memory_tool_$normalizedSourceKey',
        ),
      ),
    ];

    File? exportFile;
    Object? lastError;
    for (final directory in candidateDirectories) {
      try {
        await directory.create(recursive: true);
        final candidateFile = File(p.join(directory.path, fileName));
        await candidateFile.writeAsString(
          const JsonEncoder.withIndent('  ').convert(payload),
          flush: true,
        );
        exportFile = candidateFile;
        break;
      } catch (error) {
        lastError = error;
      }
    }

    if (exportFile == null) {
      throw lastError ??
          (context.isZh ? '没有可用的导出目录' : 'No writable export directory');
    }

    ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(
      context.isZh
          ? '已导出到: ${_formatDisplayPath(context, exportFile.path)}'
          : 'Exported to: ${_formatDisplayPath(context, exportFile.path)}',
      durationMs: 2600,
    );
    return exportFile;
  } catch (_) {
    ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(
      context.isZh ? '导出失败' : 'Export failed',
      durationMs: 1800,
    );
    return null;
  }
}

String _normalizeSourceKey(String sourceKey) {
  final normalized = sourceKey
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return normalized.isEmpty ? 'memory_tool' : normalized;
}

String _formatDisplayPath(BuildContext context, String path) {
  if (path.startsWith('/storage/emulated/0')) {
    return path.replaceFirst(
      '/storage/emulated/0',
      context.isZh ? '手机存储' : 'Internal storage',
    );
  }
  return path;
}
