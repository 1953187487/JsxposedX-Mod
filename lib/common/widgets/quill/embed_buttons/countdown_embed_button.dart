import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 倒计时嵌入按钮
class CountdownEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'countdown';

  @override
  Widget buttonWidget(BuildContext context) => const Text('倒计时');

  @override
  String dialogTitle(BuildContext context) => '配置倒计时';

  @override
  Widget build(BuildContext context, quill.QuillController controller) {
    final formKey = GlobalKey<FormBuilderState>();

    return IconButton(
      icon: buttonWidget(context),
      onPressed: () {
        CustomDialog.show(
          title: Text(dialogTitle(context)),
          hasClose: true,
          child: buildFormContent(context, formKey),
          actionButtons: [
            TextButton(
              onPressed: SmartDialog.dismiss,
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                  return;
                }
                final formData = formKey.currentState?.value ?? {};
                final config = buildConfigFromFormData(formData);
                insertToEditor(controller, config);
              },
              child: Text(context.l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (hookContext) {
        final selectedDate = useState<DateTime?>(null);
        final selectedTime = useState<TimeOfDay?>(null);

        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'title',
                labelText: '标题 (如: 活动截止)',
                validator: (value) {
                  if (value == null || value.isEmpty) return '标题不能为空';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormBuilderField<DateTime>(
                name: 'target_date',
                validator: (value) {
                  if (value == null) return '请选择日期';
                  return null;
                },
                builder: (field) {
                  return InkWell(
                    onTap: () async {
                      DateTime tempDate =
                          selectedDate.value ??
                          DateTime.now().add(const Duration(days: 1));
                      await SmartDialog.show(
                        tag: 'date_picker',
                        builder: (_) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: hookContext.theme.dialogBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CalendarDatePicker(
                                initialDate: tempDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                onDateChanged: (date) {
                                  tempDate = date;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => SmartDialog.dismiss(
                                        tag: 'date_picker',
                                      ),
                                      child: const Text('取消'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        selectedDate.value = tempDate;
                                        field.didChange(tempDate);
                                        SmartDialog.dismiss(tag: 'date_picker');
                                      },
                                      child: const Text('确定'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '目标日期',
                        errorText: field.errorText,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: hookContext.theme.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        selectedDate.value != null
                            ? '${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}'
                            : '点击选择日期',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              FormBuilderField<TimeOfDay>(
                name: 'target_time',
                builder: (field) {
                  return InkWell(
                    onTap: () async {
                      TimeOfDay tempTime = selectedTime.value ?? TimeOfDay.now();
                      await SmartDialog.show(
                        tag: 'time_picker',
                        builder: (_) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: hookContext.theme.dialogBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '选择时间',
                                style: hookContext.theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: ListWheelScrollView.useDelegate(
                                        itemExtent: 40,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        controller:
                                            FixedExtentScrollController(
                                              initialItem: tempTime.hour,
                                            ),
                                        onSelectedItemChanged: (index) {
                                          tempTime = TimeOfDay(
                                            hour: index,
                                            minute: tempTime.minute,
                                          );
                                        },
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                              childCount: 24,
                                              builder: (context, index) =>
                                                  Center(
                                                    child: Text(
                                                      index
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: hookContext
                                                          .theme
                                                          .textTheme
                                                          .headlineSmall,
                                                    ),
                                                  ),
                                            ),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: hookContext
                                          .theme
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: ListWheelScrollView.useDelegate(
                                        itemExtent: 40,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        controller:
                                            FixedExtentScrollController(
                                              initialItem: tempTime.minute,
                                            ),
                                        onSelectedItemChanged: (index) {
                                          tempTime = TimeOfDay(
                                            hour: tempTime.hour,
                                            minute: index,
                                          );
                                        },
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                              childCount: 60,
                                              builder: (context, index) =>
                                                  Center(
                                                    child: Text(
                                                      index
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                      style: hookContext
                                                          .theme
                                                          .textTheme
                                                          .headlineSmall,
                                                    ),
                                                  ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => SmartDialog.dismiss(
                                      tag: 'time_picker',
                                    ),
                                    child: const Text('取消'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      selectedTime.value = tempTime;
                                      field.didChange(tempTime);
                                      SmartDialog.dismiss(tag: 'time_picker');
                                    },
                                    child: const Text('确定'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '目标时间 (可选)',
                        suffixIcon: Icon(
                          Icons.access_time,
                          color: hookContext.theme.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        selectedTime.value != null
                            ? '${selectedTime.value!.hour.toString().padLeft(2, '0')}:${selectedTime.value!.minute.toString().padLeft(2, '0')}'
                            : '点击选择时间',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomTextField.formBuilder(
                name: 'expired_text',
                labelText: '到期提示语 (如: 活动已结束)',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final date = formData['target_date'] as DateTime?;
    final time = formData['target_time'] as TimeOfDay?;

    DateTime targetDateTime =
        date ?? DateTime.now().add(const Duration(days: 1));
    if (time != null) {
      targetDateTime = DateTime(
        targetDateTime.year,
        targetDateTime.month,
        targetDateTime.day,
        time.hour,
        time.minute,
      );
    }

    return {
      'title': formData['title'] ?? '倒计时',
      'target_timestamp': targetDateTime.millisecondsSinceEpoch,
      'expired_text': formData['expired_text'] ?? '已结束',
    };
  }
}
