import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/project/domain/models/crypto_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CryptoRuleCard extends HookWidget {
  final CryptoRule rule;
  final ValueChanged<CryptoRule> onUpdate;
  final VoidCallback onDelete;

  const CryptoRuleCard({
    super.key,
    required this.rule,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: 替换为 L10n
    final l10n = context.l10n;

    final fingerprintCtrl = useTextEditingController(text: rule.fingerprint);
    final replaceWithCtrl = useTextEditingController(text: rule.replaceWith);

    // 常用算法列表
    final defaultAlgorithms = [
      '', // 代表全部
      'AES/CBC/PKCS5Padding',
      'AES/ECB/PKCS5Padding',
      'AES/GCM/NoPadding',
      'DES/CBC/PKCS5Padding',
      'RSA/ECB/PKCS1Padding',
    ];

    // 如果当前配置的算法不在常用列表里，把它临时加上，避免下拉框报错
    final activeAlgorithms = [...defaultAlgorithms];
    if (!activeAlgorithms.contains(rule.algorithm)) {
      activeAlgorithms.add(rule.algorithm);
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: context.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: context.theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rule_folder_rounded,
                    size: 20.w,
                    color: context.theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    l10n.ruleConfig,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onDelete,
                  tooltip: l10n.delete,
                )
              ],
            ),
            SizedBox(height: 16.h),
            
            // 指纹和方向
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: fingerprintCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.targetFingerprint,
                      hintText: '如: DA51A29A',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onChanged: (val) => onUpdate(rule.copyWith(fingerprint: val)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<bool>(
                    value: rule.isInput,
                    isExpanded: true, // 关键：解决文字过长导致的 RenderFlex overflow
                    decoration: InputDecoration(
                      labelText: l10n.interceptDirection,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: true, 
                        child: Text(l10n.directionInput, overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: false, 
                        child: Text(l10n.directionOutput, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        onUpdate(rule.copyWith(isInput: val));
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // 算法选择
            DropdownButtonFormField<String>(
              value: rule.algorithm,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.specifyAlgorithm,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              items: activeAlgorithms.map((algo) {
                return DropdownMenuItem(
                  value: algo,
                  child: Text(
                    algo.isEmpty ? l10n.anyAlgorithm : algo,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  onUpdate(rule.copyWith(algorithm: val));
                }
              },
            ),
            SizedBox(height: 16.h),
            
            // 替换数据
            TextField(
              controller: replaceWithCtrl,
              maxLines: null,
              decoration: InputDecoration(
                labelText: l10n.replaceData,
                hintText: l10n.replaceDataHint,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onChanged: (val) => onUpdate(rule.copyWith(replaceWith: val)),
            ),
          ],
        ),
      ),
    );
  }
}
