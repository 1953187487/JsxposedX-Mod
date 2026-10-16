import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_search_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_form_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_session_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_task_feedback.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchDialog extends HookConsumerWidget {
  const MemoryToolSearchDialog({
    super.key,
    required this.onOpenBrowseTab,
    required this.onClose,
  });

  final VoidCallback onOpenBrowseTab;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
    final searchFormState = ref.watch(memoryToolSearchFormProvider);
    final searchActionState = ref.watch(memorySearchActionProvider);
    final taskStateAsync = ref.watch(getSearchTaskStateProvider);
    final sessionStateAsync = ref.watch(getSearchSessionStateProvider);
    final hasMatchingSession = ref.watch(hasMatchingSearchSessionProvider);
    final hasRunningTask = ref.watch(hasRunningSearchTaskProvider);
    final searchFormNotifier = ref.read(memoryToolSearchFormProvider.notifier);
    final valueController = useTextEditingController(
      text: searchFormState.value,
    );
    final canRunFirstScan =
        selectedProcess != null &&
        !searchActionState.isLoading &&
        !hasRunningTask &&
        searchFormState.supportsSelectedMatchMode;
    final canRunNextScan =
        selectedProcess != null &&
        !searchActionState.isLoading &&
        !hasRunningTask &&
        hasMatchingSession &&
        searchFormState.supportsSelectedMatchMode;
    final canReset =
        selectedProcess != null &&
        !searchActionState.isLoading &&
        !hasRunningTask;

    useEffect(() {
      Future.microtask(() {
        ref.invalidate(getSearchSessionStateProvider);
        ref.invalidate(getSearchTaskStateProvider);
      });
      return null;
    }, const []);

    useEffect(() {
      if (valueController.text == searchFormState.value) {
        return null;
      }

      valueController.value = valueController.value.copyWith(
        text: searchFormState.value,
        selection: TextSelection.collapsed(
          offset: searchFormState.value.length,
        ),
        composing: TextRange.empty,
      );
      return null;
    }, [searchFormState.value, valueController]);

    Future<void> runAndClose(Future<void> Function() action) async {
      await action();
      if (!context.mounted) {
        return;
      }

      final latestFormState = ref.read(memoryToolSearchFormProvider);
      final latestActionState = ref.read(memorySearchActionProvider);
      final validationError = latestFormState.validationError;
      if (validationError != null) {
        await ToastOverlayMessage.show(
          _searchValidationToastMessage(context, validationError),
          duration: const Duration(milliseconds: 1600),
        );
      }
      final shouldDismiss =
          validationError == null && !latestActionState.hasError;
      if (shouldDismiss) {
        onClose();
      }
    }

    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 388.0,
      maxWidthLandscape: 560.0,
      maxHeightPortrait: 520.0,
      maxHeightLandscape: 420.0,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MemoryToolSearchToolbar(
                canRunFirstScan: canRunFirstScan,
                canRunNextScan: canRunNextScan,
                canReset: canReset,
                onFirstScan: () {
                  runAndClose(searchFormNotifier.firstScan);
                },
                onNextScan: () {
                  runAndClose(searchFormNotifier.nextScan);
                },
                onReset: () {
                  runAndClose(searchFormNotifier.resetSearchSession);
                },
              ),
              SizedBox(height: 12.r),
              if (selectedProcess != null) ...<Widget>[
                MemoryToolSearchSessionCard(
                  sessionStateAsync: sessionStateAsync,
                  selectedPid: selectedProcess.pid,
                ),
                SizedBox(height: 12.r),
              ],
              MemoryToolSearchFormCard(
                valueController: valueController,
                state: searchFormState,
                actionState: searchActionState,
                hasRunningTask: hasRunningTask,
                hasMatchingSession: hasMatchingSession,
                onValueChanged: searchFormNotifier.updateValue,
                onMatchModeChanged: searchFormNotifier.updateMatchMode,
                onFuzzyModeChanged: searchFormNotifier.updateFuzzyMode,
                onValueCategoryChanged: searchFormNotifier.updateValueCategory,
                onValueTypeOptionChanged:
                    searchFormNotifier.updateValueTypeOption,
                onRangePresetChanged: searchFormNotifier.updateRangePreset,
                onCustomRangeSectionToggled:
                    searchFormNotifier.toggleCustomRangeSection,
                onEndianChanged: searchFormNotifier.updateEndian,
                taskStatus: MemoryToolSearchTaskFeedback(
                  taskStateAsync: taskStateAsync,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _searchValidationToastMessage(
  BuildContext context,
  MemoryToolSearchValidationError validationError,
) {
  return switch (validationError) {
    MemoryToolSearchValidationError.valueRequired =>
      context.l10n.memoryToolValidationValueRequired,
    MemoryToolSearchValidationError.invalidBytes =>
      context.l10n.memoryToolValidationBytesInvalid,
    MemoryToolSearchValidationError.invalidInteger =>
      context.l10n.memoryToolValidationIntegerInvalid,
    MemoryToolSearchValidationError.integerOutOfRange =>
      context.l10n.memoryToolValidationIntegerOutOfRange,
    MemoryToolSearchValidationError.invalidDecimal =>
      context.l10n.memoryToolValidationDecimalInvalid,
    MemoryToolSearchValidationError.invalidGroupSearch =>
      context.isZh
          ? '联合搜索格式错误，例：i32:100;i32:200::32'
          : 'Invalid group search format. Example: i32:100;i32:200::32',
    MemoryToolSearchValidationError.groupSearchMissingWindow =>
      context.isZh
          ? '联合搜索缺少 ::window，例：i32:100;i32:200::32'
          : 'Group search is missing ::window. Example: i32:100;i32:200::32',
    MemoryToolSearchValidationError.groupSearchInvalidWindow =>
      context.isZh
          ? '联合搜索 window 必须是大于 0 的整数。'
          : 'Group search window must be an integer greater than 0.',
    MemoryToolSearchValidationError.groupSearchWindowTooLarge =>
      context.isZh
          ? '联合搜索 window 最大支持 4096 字节。'
          : 'Group search window supports at most 4096 bytes.',
    MemoryToolSearchValidationError.groupSearchTooFewConditions =>
      context.isZh
          ? '联合搜索至少需要两个条件。'
          : 'Group search requires at least two conditions.',
    MemoryToolSearchValidationError.unsupportedType =>
      context.l10n.memoryToolValidationTypeUnsupported,
  };
}
