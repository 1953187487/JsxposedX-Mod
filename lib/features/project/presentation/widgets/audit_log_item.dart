import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/audit_log_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AuditLogItem extends HookConsumerWidget {
  final String packageName;
  final AuditLog log;
  final VoidCallback? onDeleted;

  const AuditLogItem({
    super.key,
    required this.packageName,
    required this.log,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final date = useMemoized(() => DateTime.fromMillisecondsSinceEpoch(log.timestamp), [log.timestamp]);
    final timeStr = useMemoized(() => DateFormat('MM-dd HH:mm:ss').format(date), [date]);
    final isEncrypt = log.operation == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetail(context, ref),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: (isEncrypt ? Colors.green : Colors.orange)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEncrypt ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                    color: isEncrypt ? Colors.green : Colors.orange,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              log.algorithm.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: theme.hintColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              log.fingerprint,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '${context.l10n.inputLabel}: ${log.input.length > 50 ? '${log.input.substring(0, 50)}...' : log.input}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.hintColor.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isEncrypt = log.operation == 1;

    AppBottomSheet.show(
      context: context,
      title: l10n.detailInfo,
      action: [
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          onPressed: () => _confirmDelete(context, ref, l10n),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuditLogDetailSection(title: l10n.algorithmLabel, content: log.algorithm),
                  AuditLogDetailSection(
                    title: l10n.info,
                    content: isEncrypt ? l10n.encrypt : l10n.decrypt,
                  ),
                  AuditLogDetailSection(title: l10n.fingerprintLabel, content: log.fingerprint),

                  // 密钥部分
                  const Divider(),
                  AuditLogDetailSection(title: '${l10n.keyLabel} (${l10n.plaintextLabel})', content: log.keyPlaintext),
                  AuditLogDetailSection(title: '${l10n.keyLabel} (${l10n.base64Label})', content: log.keyBase64),
                  AuditLogDetailSection(title: '${l10n.keyLabel} (${l10n.hexLabel})', content: log.key),

                  // 向量部分
                  if (log.iv != null && log.iv!.isNotEmpty) ...[
                    const Divider(),
                    AuditLogDetailSection(title: '${l10n.ivLabel} (${l10n.plaintextLabel})', content: log.ivPlaintext ?? ''),
                    AuditLogDetailSection(title: '${l10n.ivLabel} (${l10n.base64Label})', content: log.ivBase64 ?? ''),
                    AuditLogDetailSection(title: '${l10n.ivLabel} (${l10n.hexLabel})', content: log.iv!),
                  ],

                  // 输入
                  const Divider(),
                  AuditLogDetailSection(title: '${l10n.inputLabel} (${l10n.plaintextLabel})', content: log.input),
                  AuditLogDetailSection(title: '${l10n.inputLabel} (${l10n.base64Label})', content: log.inputBase64),
                  AuditLogDetailSection(title: '${l10n.inputLabel} (${l10n.hexLabel})', content: log.inputHex),

                  // 输出
                  const Divider(),
                  AuditLogDetailSection(title: '${l10n.outputLabel} (${l10n.plaintextLabel})', content: log.output),
                  AuditLogDetailSection(title: '${l10n.outputLabel} (${l10n.base64Label})', content: log.outputBase64),
                  AuditLogDetailSection(title: '${l10n.outputLabel} (${l10n.hexLabel})', content: log.outputHex),

                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      l10n.stackLabel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  _buildStackFlow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, dynamic l10n) {
    CustomDialog.show(
      title: Text(l10n.delete),
      child: Text(l10n.confirmDelete),
      actionButtons: [
        TextButton(
          onPressed: () => SmartDialog.dismiss(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () async {
            SmartDialog.dismiss();
            try {
              await ref.read(
                deleteAuditLogProvider(
                  packageName: packageName,
                  timestamp: log.timestamp,
                ).future,
              );
              if (context.mounted) {
                Navigator.pop(context); // 关闭详情底部弹窗
                onDeleted?.call();
                ToastMessage.show(l10n.success);
              }
            } catch (e) {
              if (context.mounted) {
                ToastMessage.show('${l10n.error}: $e');
              }
            }
          },
          child: Text(
            l10n.confirm,
            style: TextStyle(color: context.theme.colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildStackFlow(BuildContext context) {
    final reversedStack = log.stackTrace.reversed.toList();
    final colorScheme = context.theme.colorScheme;

    return Column(
      children: reversedStack.asMap().entries.map((entry) {
        final index = entry.key;
        final frame = entry.value;
        final isLast = index == reversedStack.length - 1;
        final isFirst = index == 0;

        String methodName = frame;
        String classInfo = '';

        try {
          final bracketIndex = frame.indexOf('(');
          if (bracketIndex != -1) {
            final beforeBracket = frame.substring(0, bracketIndex);
            final lastDotIndex = beforeBracket.lastIndexOf('.');
            if (lastDotIndex != -1) {
              methodName = beforeBracket.substring(lastDotIndex + 1);
              classInfo = beforeBracket.substring(0, lastDotIndex);
            }
          }
        } catch (_) {}

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 32.w,
                  child: Column(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isLast
                              ? Colors.green
                              : (isFirst
                                  ? colorScheme.outlineVariant
                                  : colorScheme.primary.withValues(alpha: 0.6)),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2.w,
                          height: 50.h,
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isLast
                            ? Colors.green.withValues(alpha: 0.3)
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${reversedStack.length - index}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary.withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: SelectableText(
                                methodName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: isLast ? Colors.green : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (classInfo.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          SelectableText(
                            classInfo,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                        SizedBox(height: 4.h),
                        SelectableText(
                          frame,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: colorScheme.outline,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isLast)
              Padding(
                padding: EdgeInsets.only(left: 32.w, bottom: 8.h),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  size: 16.sp,
                  color: colorScheme.outlineVariant,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
