import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolSearchResultActionDialog extends StatelessWidget {
  const MemoryToolSearchResultActionDialog({
    super.key,
    required this.actions,
    required this.onClose,
  });

  final List<MemoryToolSearchResultActionItemData> actions;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 372.r,
      maxWidthLandscape: 420.r,
      maxHeightPortrait: 280.r,
      maxHeightLandscape: 240.r,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(10.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int index = 0; index < actions.length; index++) ...<Widget>[
                if (index > 0) SizedBox(height: 8.r),
                _MemoryToolSearchResultActionItem(data: actions[index]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class MemoryToolSearchResultActionItemData {
  const MemoryToolSearchResultActionItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Future<void> Function() onTap;
}

class _MemoryToolSearchResultActionItem extends StatelessWidget {
  const _MemoryToolSearchResultActionItem({required this.data});

  final MemoryToolSearchResultActionItemData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () async {
          await data.onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.42,
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    data.icon,
                    size: 18.r,
                    color: context.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 10.r),
                Expanded(
                  child: SizedBox(
                    height: 34.r,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, 1.r),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.title,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.r),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurface.withValues(alpha: 0.42),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
