import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolResultStatsBar extends StatelessWidget {
  const MemoryToolResultStatsBar({
    super.key,
    required this.resultCount,
    required this.selectedCount,
    required this.renderedCount,
    required this.pageCount,
  });

  final int resultCount;
  final int selectedCount;
  final int renderedCount;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, int value})>[
      if (resultCount > 0)
        (label: context.l10n.memoryToolSessionResultCount, value: resultCount),
      if (selectedCount > 0)
        (
          label: context.l10n.memoryToolSessionSelectedCount,
          value: selectedCount,
        ),
      if (pageCount > 0)
        (label: context.l10n.memoryToolSessionPageCount, value: pageCount),
      if (renderedCount > 0)
        (
          label: context.l10n.memoryToolSessionRenderedCount,
          value: renderedCount,
        ),
    ];
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(right: 6.r),
                  child: MemoryToolResultStatChip(
                    label: item.label,
                    value: item.value,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class MemoryToolResultStatChip extends StatelessWidget {
  const MemoryToolResultStatChip({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.52,
        ),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.34),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
        child: RichText(
          maxLines: 1,
          text: TextSpan(
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.64),
              fontWeight: FontWeight.w600,
            ),
            children: <InlineSpan>[
              TextSpan(text: '$label '),
              TextSpan(
                text: value.toString(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
