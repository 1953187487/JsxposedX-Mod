import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchSessionCard extends StatelessWidget {
  const MemoryToolSearchSessionCard({
    super.key,
    required this.sessionStateAsync,
    required this.selectedPid,
  });

  final AsyncValue<SearchSessionState> sessionStateAsync;
  final int? selectedPid;

  @override
  Widget build(BuildContext context) {
    return sessionStateAsync.when(
      data: (state) {
        final isBoundToCurrent =
            selectedPid != null &&
            state.hasActiveSession &&
            state.pid == selectedPid;
        if (!isBoundToCurrent) {
          return const SizedBox.shrink();
        }

        return Wrap(
          spacing: 8.r,
          runSpacing: 8.r,
          children: <Widget>[
            _MemoryToolSessionPill(
              label: context.l10n.memoryToolSessionPid,
              value: state.pid.toString(),
            ),
            _MemoryToolSessionPill(
              label: context.l10n.memoryToolSessionRegionCount,
              value: state.regionCount.toString(),
            ),
            _MemoryToolSessionPill(
              label: context.l10n.memoryToolSessionResultCount,
              value: state.resultCount.toString(),
            ),
          ],
        );
      },
      error: (error, _) => Text(
        error.toString(),
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.error,
          fontWeight: FontWeight.w700,
        ),
      ),
      loading: () => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.r),
        child: SizedBox(height: 24.r, width: 24.r, child: const Loading()),
      ),
    );
  }
}

class _MemoryToolSessionPill extends StatelessWidget {
  const _MemoryToolSessionPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.62,
        ),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$label ',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
            Text(
              value,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
