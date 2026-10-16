import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/project/domain/models/crypto_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/crypto_rule_card.dart';

class VisualCryptoEditorTab extends HookWidget {
  final List<CryptoRule> rules;
  final ValueChanged<List<CryptoRule>> onChanged;

  const VisualCryptoEditorTab({
    super.key,
    required this.rules,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return Column(
      children: [
        if (rules.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rule_rounded,
                    size: 48.w,
                    color: context.theme.colorScheme.outline,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.noVisualRules,
                    style: TextStyle(color: context.theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: rules.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final rule = rules[index];
                return CryptoRuleCard(
                  rule: rule,
                  onUpdate: (newRule) {
                    final newRules = List<CryptoRule>.from(rules);
                    newRules[index] = newRule;
                    onChanged(newRules);
                  },
                  onDelete: () {
                    final newRules = List<CryptoRule>.from(rules);
                    newRules.removeAt(index);
                    onChanged(newRules);
                  },
                );
              },
            ),
          ),
        SizedBox(height: 12.h),
        ElevatedButton.icon(
          onPressed: () {
            final newRules = List<CryptoRule>.from(rules)..add(CryptoRule());
            onChanged(newRules);
          },
          icon: const Icon(Icons.add),
          label: Text(context.l10n.addRuleBtn),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 48.h),
          ),
        ),
      ],
    );
  }
}
