import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/block_variable_collector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VariablePickerSheet extends StatelessWidget {
  final List<VariableInfo> variables;
  final ValueChanged<String> onSelect;

  const VariablePickerSheet({
    super.key,
    required this.variables,
    required this.onSelect,
  });

  static void show(
    BuildContext context, {
    required List<VariableInfo> variables,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => VariablePickerSheet(
        variables: variables,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final contextVars = variables.where((v) => v.isContext).toList();
    final userVars = variables.where((v) => !v.isContext).toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              l10n.pickVariable,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (variables.isEmpty)
            Padding(
              padding: EdgeInsets.all(32.w),
              child: Text(
                l10n.noVariablesAvailable,
                style: TextStyle(
                  color: context.colorScheme.outline,
                  fontSize: 13.sp,
                ),
              ),
            )
          else ...[
            if (contextVars.isNotEmpty)
              _section(context, l10n.contextVariables, contextVars),
            if (userVars.isNotEmpty)
              _section(context, l10n.userVariables, userVars),
          ],
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 40.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<VariableInfo> vars,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.outline,
            ),
          ),
        ),
        ...vars.map((v) => _varTile(context, v)),
      ],
    );
  }

  Widget _varTile(BuildContext context, VariableInfo v) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        v.isContext ? Icons.settings_rounded : Icons.data_object_rounded,
        size: 18.r,
        color: v.isContext ? Colors.orange : Colors.blue,
      ),
      title: Text(
        v.name,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
      subtitle: Text(
        v.description ?? v.source,
        style: TextStyle(fontSize: 10.sp, color: context.colorScheme.outline),
      ),
      onTap: () {
        Navigator.pop(context);
        onSelect(v.name);
      },
    );
  }
}
