import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/widgets/apk_class_map_tab.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/widgets/dex_code_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApkClassViewPage extends HookConsumerWidget {
  final String? sessionId;
  final List<String> dexPaths;
  final String className;
  final String? packageName;

  const ApkClassViewPage({
    super.key,
    this.sessionId,
    required this.dexPaths,
    required this.className,
    this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sid = sessionId;
    if (sid == null || sid.isEmpty) return const Loading();

    final tabIndex = useState(0);
    // 记录哪些 tab 被访问过，只有访问过才构建（懒加载）
    final visitedTabs = useState(<int>{0}); // 默认只加载 Smali

    // 页面加载时立即显示 loading
    useEffect(() {
      Loading.show();
      return () => Loading.hide();
    }, []);

    return Column(
      children: [
        _TabHeader(
          index: tabIndex.value,
          onChanged: (i) {
            tabIndex.value = i;
            if (!visitedTabs.value.contains(i)) {
              visitedTabs.value = {...visitedTabs.value, i};
            }
          },
        ),
        _ClassActionsBar(
          className: className,
          packageName: packageName,
          sessionId: sid,
          dexPaths: dexPaths,
          currentTab: tabIndex.value,
        ),
        Expanded(
          child: IndexedStack(
            index: tabIndex.value,
            children: [
              // Smali tab (index 0) - 默认加载
              _SmaliTab(
                sessionId: sid,
                dexPaths: dexPaths,
                className: className,
                packageName: packageName,
              ),
              // Java tab (index 1) - 仅在用户点击后才加载
              if (visitedTabs.value.contains(1))
                _JavaTab(
                  sessionId: sid,
                  dexPaths: dexPaths,
                  className: className,
                  packageName: packageName,
                )
              else
                const SizedBox.shrink(),
              // Map tab (index 2) - 仅在用户点击后才加载
              if (visitedTabs.value.contains(2))
                ApkClassMapTab(
                  sessionId: sid,
                  dexPaths: dexPaths,
                  className: className,
                  packageName: packageName ?? '',
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabHeader extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _TabHeader({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: 'Smali',
          selected: index == 0,
          onTap: () => onChanged(0),
        ),
        _TabItem(
          label: 'Java',
          selected: index == 1,
          onTap: () => onChanged(1),
        ),
        _TabItem(label: 'Map', selected: index == 2, onTap: () => onChanged(2)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? context.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClassActionsBar extends HookConsumerWidget {
  final String className;
  final String? packageName;
  final String sessionId;
  final List<String> dexPaths;
  final int currentTab;

  const _ClassActionsBar({
    required this.className,
    this.packageName,
    required this.sessionId,
    required this.dexPaths,
    required this.currentTab,
  });

  String get _shortName =>
      className.contains('.') ? className.split('.').last : className;

  void _sendToAi(BuildContext context, WidgetRef ref) {
    final pkg = packageName;
    if (pkg == null || pkg.isEmpty) {
      ToastMessage.show(context.l10n.apkNoAiSession);
      return;
    }
    final isSmali = currentTab == 0;
    final prompt = isSmali
        ? context.l10n.apkAnalyzeSmaliPrompt(className)
        : context.l10n.apkAnalyzeJavaPrompt(className);
    ref
        .read(aiChatRuntimeProvider(packageName: pkg).notifier)
        .send(prompt);
    ToastMessage.show(context.l10n.apkSentToAi(_shortName));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final hintColor = context.theme.hintColor;
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: className));
                ToastMessage.show(context.l10n.dexCopied(className));
              },
              child: Text(
                className,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: hintColor,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _ActionBtn(
            icon: Icons.psychology_outlined,
            label: context.l10n.apkAiAnalyze,
            color: context.colorScheme.primary,
            onTap: () => _sendToAi(context, ref),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.theme.hintColor;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: c),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: c),
          ),
        ],
      ),
    );
  }
}

class _JavaTab extends HookConsumerWidget {
  final String sessionId;
  final List<String> dexPaths;
  final String className;
  final String? packageName;

  const _JavaTab({
    required this.sessionId,
    required this.dexPaths,
    required this.className,
    this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(
      decompileClassProvider(
        sessionId: sessionId,
        dexPaths: dexPaths,
        className: className,
      ),
    );

    useEffect(() {
      if (codeAsync.isLoading) {
        Loading.show();
      } else {
        Loading.hide();
      }
      return null;
    }, [codeAsync.isLoading]);

    return codeAsync.when(
      data: (code) => _CodeView(
        code: code,
        language: 'java',
        packageName: packageName,
        className: className,
      ),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(
          decompileClassProvider(
            sessionId: sessionId,
            dexPaths: dexPaths,
            className: className,
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class _SmaliTab extends HookConsumerWidget {
  final String sessionId;
  final List<String> dexPaths;
  final String className;
  final String? packageName;

  const _SmaliTab({
    required this.sessionId,
    required this.dexPaths,
    required this.className,
    this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(
      getClassSmaliProvider(
        sessionId: sessionId,
        dexPaths: dexPaths,
        className: className,
      ),
    );

    useEffect(() {
      if (codeAsync.isLoading) {
        Loading.show();
      } else {
        Loading.hide();
      }
      return null;
    }, [codeAsync.isLoading]);

    return codeAsync.when(
      data: (code) => _CodeView(
        code: code,
        language: 'smali',
        packageName: packageName,
        className: className,
      ),
      error: (e, _) => RefError(
        onRetry: () => ref.invalidate(
          getClassSmaliProvider(
            sessionId: sessionId,
            dexPaths: dexPaths,
            className: className,
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class _CodeView extends HookConsumerWidget {
  final String code;
  final String language;
  final String? packageName;
  final String? className;

  const _CodeView({
    required this.code,
    required this.language,
    this.packageName,
    this.className,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pkg = packageName;
    final cls = className;
    return DexCodeViewer(
      code: code,
      language: language,
      onSendToAi: pkg != null && pkg.isNotEmpty
          ? (selectedText) {
              final langLabel = language == 'smali' ? 'Smali' : 'Java';
              final prompt = cls != null && cls.isNotEmpty
                  ? context.l10n.apkAnalyzeSelectedCode(
                      cls,
                      langLabel,
                      selectedText,
                    )
                  : selectedText;
              ref
                  .read(aiChatRuntimeProvider(packageName: pkg).notifier)
                  .send(prompt);
              ToastMessage.show(context.l10n.apkSentToAi(cls ?? ''));
            }
          : null,
    );
  }
}
