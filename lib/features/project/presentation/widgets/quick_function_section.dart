import 'package:JsxposedX/core/enums/project/quick_functions_enum.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_section.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/dialog_keyword_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuickFunctionSection extends StatelessWidget {
  final String title;
  final List<({String functionKey, String name, IconData icon})> items;
  final String packageName;

  const QuickFunctionSection({
    super.key,
    required this.title,
    required this.items,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      items: [
        for (int i = 0; i < items.length; i++) ...[
          QuickFunctionTile(
            functionKey: items[i].functionKey,
            name: items[i].name,
            icon: items[i].icon,
            packageName: packageName,
          ),
          if (i < items.length - 1)
            Divider(
              height: 1,
              indent: 60.w,
              endIndent: 20.w,
              thickness: 0.5,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
        ],
      ],
    );
  }
}

class QuickFunctionTile extends HookConsumerWidget {
  final String functionKey;
  final String name;
  final IconData icon;
  final String packageName;

  const QuickFunctionTile({
    super.key,
    required this.functionKey,
    required this.name,
    required this.icon,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(
      getQuickFunctionStatusProvider(
        packageName: packageName,
        name: functionKey,
      ),
    );

    void toggle(bool val) {
      Future.microtask(() async {
        await ref.read(
          setQuickFunctionStatusProvider(
            packageName: packageName,
            name: functionKey,
            status: val,
          ).future,
        );
        ref.invalidate(
          getQuickFunctionStatusProvider(
            packageName: packageName,
            name: functionKey,
          ),
        );
      });
    }

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () => toggle(!(statusAsync.value ?? false)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22.w,
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            maxLines: 1,
          ),
        ),
        trailing: statusAsync.when(
          data: (val) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (functionKey == QuickFunctionsEnum.removeDialogs)
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.w,
                  ),
                  onPressed: () => DialogKeywordSheet.show(
                    context,
                    packageName: packageName,
                    functionKey: functionKey,
                  ),
                ),
              if (functionKey == QuickFunctionsEnum.algorithmicTracking)
                IconButton(
                  icon: Icon(
                    Icons.history_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.w,
                  ),
                  onPressed: () => context.push(
                    HomeRoute.toCryptoAuditLog(packageName: packageName),
                  ),
                ),
              Switch.adaptive(
                value: val,
                onChanged: toggle,
              ),
            ],
          ),
          loading: () => SizedBox(
            width: 20.w,
            height: 20.w,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => Switch.adaptive(
            value: false,
            onChanged: toggle,
          ),
        ),
      ),
    );
  }
}
