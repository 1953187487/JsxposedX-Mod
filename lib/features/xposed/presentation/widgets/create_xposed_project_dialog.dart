import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_action_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateXposedProjectDialog extends HookConsumerWidget {
  final String packageName;

  const CreateXposedProjectDialog({super.key, required this.packageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int>(0);
    final options = [context.l10n.visualType, context.l10n.traditionalType];
    final nameController = useTextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.projectName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: nameController,
          hintText: context.l10n.projectNameHint,
        ),
        SizedBox(height: 16.h),
        Text(
          context.l10n.projectType,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 12.w,
          children: List.generate(options.length, (index) {
            return ChoiceChip(
              label: Text(options[index]),
              selected: selectedIndex.value == index,
              onSelected: (selected) {
                if (selected) {
                  selectedIndex.value = index;
                }
              },
            );
          }),
        ),

        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ToastMessage.show(context.l10n.projectNameEmpty);
                  return;
                }
                ref.read(
                  createJsScriptProvider(
                    packageName: packageName,
                    localPath:
                        "${selectedIndex.value == 0 ? "[visual]" : "[traditional]"}${nameController.text}.js",
                    content: "",
                  ),
                );
                ToastMessage.show(
                  context.l10n.projectCreated(nameController.text),
                );
                ref.invalidate(jsScriptsProvider(packageName: packageName));
                Navigator.pop(context);
              },
              child: Text(context.l10n.projectCreate),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
          ],
        ),
      ],
    );
  }
}
