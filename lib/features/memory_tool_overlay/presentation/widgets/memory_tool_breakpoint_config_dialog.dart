import 'dart:typed_data';

import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolBreakpointConfigDialog extends HookWidget {
  const MemoryToolBreakpointConfigDialog({
    super.key,
    required this.pid,
    required this.result,
    required this.preview,
    required this.onConfirm,
    required this.onClose,
  });

  final int pid;
  final SearchResult result;
  final MemoryValuePreview? preview;
  final Future<void> Function(AddMemoryBreakpointRequest request) onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final selectedLength = useState<int>(
      _resolveInitialLength(result, preview),
    );
    final accessType = useState<MemoryBreakpointAccessType>(
      MemoryBreakpointAccessType.write,
    );
    final pauseOnHit = useState<bool>(false);
    final isSubmitting = useState<bool>(false);
    final candidateLengths = _resolveSupportedLengths(
      preview?.rawBytes ?? result.rawBytes,
    );

    return OverlayPanelDialog.card(
      onClose: isSubmitting.value ? null : onClose,
      maxWidthPortrait: 320.r,
      maxWidthLandscape: 400.r,
      maxHeightPortrait: 400.r,
      maxHeightLandscape: 340.r,
      cardBorderRadius: 18.r,
      fillCardHeight: true,
      childBuilder: (context, viewport, layout) {
        return Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      context.isZh ? '创建断点' : 'Create Breakpoint',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (isSubmitting.value)
                    SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: CircularProgressIndicator(strokeWidth: 2.r),
                    ),
                ],
              ),
              SizedBox(height: 12.r),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Label(text: context.isZh ? '类型' : 'Access'),
                      SizedBox(height: 8.r),
                      Wrap(
                        spacing: 8.r,
                        runSpacing: 8.r,
                        children: MemoryBreakpointAccessType.values
                            .map(
                              (type) => ChoiceChip(
                                label: Text(_mapAccessTypeLabel(context, type)),
                                selected: accessType.value == type,
                                onSelected: isSubmitting.value
                                    ? null
                                    : (_) {
                                        accessType.value = type;
                                      },
                              ),
                            )
                            .toList(growable: false),
                      ),
                      SizedBox(height: 12.r),
                      _Label(text: context.isZh ? '长度' : 'Length'),
                      SizedBox(height: 8.r),
                      Wrap(
                        spacing: 8.r,
                        runSpacing: 8.r,
                        children: <Widget>[
                          for (final length in candidateLengths)
                            ChoiceChip(
                              label: Text('$length B'),
                              selected: selectedLength.value == length,
                              onSelected: isSubmitting.value
                                  ? null
                                  : (_) {
                                      selectedLength.value = length;
                                    },
                            ),
                        ],
                      ),
                      SizedBox(height: 12.r),
                      SwitchListTile.adaptive(
                        value: pauseOnHit.value,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          context.isZh ? '命中后暂停程序' : 'Pause on hit',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onChanged: isSubmitting.value
                            ? null
                            : (value) {
                                pauseOnHit.value = value;
                              },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.r),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSubmitting.value ? null : onClose,
                      child: Text(context.isZh ? '取消' : 'Cancel'),
                    ),
                  ),
                  SizedBox(width: 10.r),
                  Expanded(
                    child: FilledButton(
                      onPressed: isSubmitting.value
                          ? null
                          : () async {
                              isSubmitting.value = true;
                              try {
                                await onConfirm(
                                  AddMemoryBreakpointRequest(
                                    pid: pid,
                                    address: result.address,
                                    type: result.type,
                                    length: selectedLength.value,
                                    accessType: accessType.value,
                                    enabled: true,
                                    pauseProcessOnHit: pauseOnHit.value,
                                  ),
                                );
                              } finally {
                                isSubmitting.value = false;
                              }
                            },
                      child: Text(context.isZh ? '创建' : 'Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<int> _resolveSupportedLengths(Uint8List bytes) {
    final availableLength = bytes.isEmpty ? 1 : bytes.length;
    const supported = <int>[1, 2, 4, 8];
    final valid = supported
        .where((length) => length <= availableLength)
        .toList(growable: true);
    if (valid.length < supported.length) {
      final fallback = supported.firstWhere(
        (length) => length >= availableLength,
        orElse: () => 8,
      );
      if (!valid.contains(fallback)) {
        valid.add(fallback);
      }
    }
    if (valid.isEmpty) {
      valid.add(1);
    }
    valid.sort();
    return valid;
  }

  int _resolveInitialLength(SearchResult result, MemoryValuePreview? preview) {
    final rawLength = resolveMemoryToolReadLengthForType(
      type: result.type,
      bytesLength: preview?.rawBytes.length ?? result.rawBytes.length,
    );
    for (final supported in const <int>[1, 2, 4, 8]) {
      if (rawLength <= supported) {
        return supported;
      }
    }
    return 8;
  }

  String _mapAccessTypeLabel(
    BuildContext context,
    MemoryBreakpointAccessType type,
  ) {
    return switch (type) {
      MemoryBreakpointAccessType.read => context.isZh ? '读' : 'Read',
      MemoryBreakpointAccessType.write => context.isZh ? '写' : 'Write',
      MemoryBreakpointAccessType.readWrite =>
        context.isZh ? '读写' : 'Read/Write',
    };
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
