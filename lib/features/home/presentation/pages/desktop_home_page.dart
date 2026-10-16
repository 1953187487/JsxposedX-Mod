import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/common/widgets/app_code_editor.dart';
import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/common/widgets/toast.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:JsxposedX/core/utils/js_formatter.dart';
import 'package:JsxposedX/core/utils/procedure_utils.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_connection_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_locale_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_logs_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_theme_provider.dart';
import 'package:JsxposedX/features/home/presentation/utils/update_check_helper.dart';
import 'package:JsxposedX/features/home/presentation/widgets/notice_bottom_sheet.dart';
import 'package:JsxposedX/features/home/presentation/widgets/update_check_dialog.dart';
import 'package:JsxposedX/features/frida/presentation/constants/frida_prompts.dart';
import 'package:JsxposedX/features/xposed/presentation/constants/jsxposed_prompts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:xterm/xterm.dart';

/// PC 端主页面（壳子）
///
/// PC 端定位为与手机端跨端通信的独立客户端，
/// 此处仅提供窗口骨架：侧边栏导航 + 主工作区。
/// 不依赖任何手机端业务逻辑（工程/Xposed/Frida 等）。
class DesktopHomePage extends HookConsumerWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final l10n = context.l10n;

    final navItems = <_DesktopNavItem>[
      _DesktopNavItem(
        label: l10n.desktopNavWorkbench,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
      ),
      _DesktopNavItem(
        label: l10n.desktopNavSettings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
      ),
    ];
    final selectedIndex = currentIndex.value >= navItems.length
        ? navItems.length - 1
        : currentIndex.value;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        await AppBottomSheet.show<void>(
          context: context,
          title: context.l10n.notice,
          child: const NoticeBottomSheet(),
        );
        if (context.mounted) {
          await _checkDesktopUpdate(context, ref, showLatestResult: false);
        }
      });
      return null;
    }, const []);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _ActivityBar(
                  navItems: navItems,
                  currentIndex: selectedIndex,
                  onSelect: (index) => currentIndex.value = index,
                ),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: const [
                      _DesktopWorkbenchView(),
                      _DesktopSettingsView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _DesktopStatusBar(),
        ],
      ),
    );
  }
}

class _ActivityBar extends HookConsumerWidget {
  final List<_DesktopNavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const _ActivityBar({
    required this.navItems,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final dividerColor = colorScheme.outlineVariant.withValues(alpha: 0.5);

    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(right: BorderSide(color: dividerColor)),
      ),
      child: Column(
        children: [
          Tooltip(
            message: 'JsxposedX',
            child: SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: dividerColor),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: navItems.length - 1,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final selected = currentIndex == index;
                return _ActivityButton(
                  tooltip: item.label,
                  icon: selected ? item.selectedIcon : item.icon,
                  selected: selected,
                  onPressed: () => onSelect(index),
                );
              },
            ),
          ),
          _ActivityButton(
            tooltip: navItems.last.label,
            icon: currentIndex == navItems.length - 1
                ? navItems.last.selectedIcon
                : navItems.last.icon,
            selected: currentIndex == navItems.length - 1,
            onPressed: () => onSelect(navItems.length - 1),
          ),
        ],
      ),
    );
  }
}

class _ActivityButton extends StatelessWidget {
  const _ActivityButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.selected = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2,
                    color: selected ? colors.primary : Colors.transparent,
                  ),
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: selected ? colors.onSurface : colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _checkDesktopUpdate(
  BuildContext context,
  WidgetRef ref, {
  required bool showLatestResult,
}) async {
  try {
    if (showLatestResult) {
      ref.invalidate(updateInfoProvider);
    }
    final localBuildNumber = await ProcedureUtils.getBuildNumber();
    final update = await ref.read(updateInfoProvider.future);
    if (!context.mounted) return;

    if (shouldShowUpdateDialog(
      update: update,
      localBuildNumber: localBuildNumber,
    )) {
      await UpdateCheckDialog.show(context, update: update);
      return;
    }

    if (showLatestResult && context.mounted) {
      Toast.showToast(context, context.l10n.desktopUpdateLatest);
    }
  } catch (error, stackTrace) {
    debugPrint('Failed to check desktop update: $error');
    debugPrintStack(stackTrace: stackTrace);
    if (showLatestResult && context.mounted) {
      Toast.showToast(context, context.l10n.desktopUpdateCheckFailed);
    }
  }
}

class _DesktopSettingsView extends HookConsumerWidget {
  const _DesktopSettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecking = useState(false);
    final colorScheme = context.colorScheme;
    final packageInfo = useFuture(
      useMemoized(ProcedureUtils.getPackageInfo, const []),
    );
    final version = packageInfo.data;

    return ColoredBox(
      color: colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text(
            context.l10n.desktopNavSettings,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.desktopSettingsAppearance,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Material(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          context.isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                        ),
                        title: Text(context.l10n.desktopSettingsColorTheme),
                        subtitle: Text(
                          context.isDark
                              ? context.l10n.desktopSettingsThemeDark
                              : context.l10n.desktopSettingsThemeLight,
                        ),
                        trailing: Switch(
                          value: context.isDark,
                          onChanged: (_) => ref
                              .read(desktopThemeModeProvider.notifier)
                              .toggle(),
                        ),
                        onTap: () => ref
                            .read(desktopThemeModeProvider.notifier)
                            .toggle(),
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(
                          context.l10n.desktopSettingsDisplayLanguage,
                        ),
                        subtitle: Text(
                          Localizations.localeOf(context).languageCode == 'en'
                              ? context.l10n.english
                              : context.l10n.chinese,
                        ),
                        trailing: const Icon(Icons.swap_horiz),
                        onTap: () =>
                            ref.read(desktopLocaleProvider.notifier).toggle(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.desktopSettingsApplication,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Material(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: const Icon(Icons.system_update_alt),
                    title: Text(context.l10n.desktopUpdateCheck),
                    subtitle: Text(
                      version == null
                          ? context.l10n.desktopUpdateCheckDescription
                          : context.l10n.desktopCurrentVersion(
                              version.version,
                              version.buildNumber,
                            ),
                    ),
                    trailing: isChecking.value
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    enabled: !isChecking.value,
                    onTap: () async {
                      isChecking.value = true;
                      await _checkDesktopUpdate(
                        context,
                        ref,
                        showLatestResult: true,
                      );
                      if (context.mounted) {
                        isChecking.value = false;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ..._buildPromotionSections(context, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 社区 / 关注作者 / 关于，沿用手机端设置里的引流内容
  List<Widget> _buildPromotionSections(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final l10n = context.l10n;
    return [
      Text(
        l10n.desktopSettingsCommunity,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 8),
      Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CacheImage(imageUrl: AssetsConstants.muxue, size: 32),
              ),
              title: Text(l10n.desktopSettingsCommunityForum),
              subtitle: Text(l10n.desktopSettingsCommunityDescription),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoForumUrl),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: const Icon(Icons.forum_outlined),
              title: Text(l10n.desktopSettingsOfficialMirror),
              subtitle: const Text(_promoForumHost),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoForumUrl),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(l10n.desktopSettingsJoinDiscord),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoDiscordUrl),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: Text(l10n.desktopSettingsJoinQQGroup),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoQqGroupUrl),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: Text(l10n.desktopSettingsTargetRange),
              trailing: const Icon(Icons.open_in_new),
              onTap: () =>
                  UrlHelper.openUrlInBrowser(url: _promoTargetRangeUrl),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text(
        l10n.desktopSettingsFollowAuthor,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 8),
      Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            for (final link in _promoCreatorLinks) ...[
              ListTile(
                leading: SizedBox.square(
                  dimension: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CacheImage(
                        imageUrl: link.iconUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                title: Text(link.title),
                subtitle: Text(l10n.desktopSettingsMorePlatforms),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => UrlHelper.openUrlInBrowser(url: link.url),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
            ],
            ListTile(
              leading: const Icon(Icons.qr_code_rounded),
              title: Text(l10n.desktopSettingsWechat),
              trailing: const Icon(Icons.chevron_right),
              // 与手机端一致，弹窗展示公众号二维码
              onTap: () => _showWechatDialog(context),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text(
        l10n.desktopSettingsAbout,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 8),
      Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.public_outlined),
              title: Text(l10n.desktopSettingsOfficialSite),
              subtitle: Text(l10n.desktopSettingsOfficialSiteHint),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoProjectUrl),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: const Icon(Icons.code_rounded),
              title: Text(l10n.desktopSettingsRepository),
              subtitle: const Text('GitHub'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => UrlHelper.openUrlInBrowser(url: _promoRepositoryUrl),
            ),
          ],
        ),
      ),
    ];
  }

  /// 与手机端一致，弹窗展示公众号二维码
  Future<void> _showWechatDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.desktopSettingsWechat),
        content: SizedBox(
          width: 380,
          child: AspectRatio(
            aspectRatio: 1885 / 624,
            child: Image.asset(AssetsConstants.wx, fit: BoxFit.contain),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );
  }
}

/// PC 端设置页的引流外链，与手机端设置保持一致
const String _promoForumHost = 'muxueai.pro';
const String _promoForumUrl = 'https://muxueai.pro';
const String _promoDiscordUrl = 'https://discord.gg/sUHbq6jHeZ';
const String _promoQqGroupUrl =
    'https://qun.qq.com/universal-share/share?ac=1&authKey=CoeFZQRhWhCHjLTPhZC%2BVcCSkHb431ulekylEVq8Cy9g%2FF9nNwzaak3lrpzPmez4&busi_data=eyJncm91cENvZGUiOiIzMzUwNDc4MzQiLCJ0b2tlbiI6IjhkekxXRklPcU9nNCtLbnhQM3FjeWFOT3VnTW5SY2E2ZVNYL25Fdjc5dlI1a1ZVMTlsYUtwbzNRblo2R01xOXMiLCJ1aW4iOiIzMTEzMTQzNjY2In0%3D&data=_T2_0SMUSubLMt0YcN1MGZJF9zB2cR1tByzZ7-nin-3yDQ_QIxc9UfAHGCD4I5pkd1bunaTW6aZqZ3NmHeepJg&svctype=4&tempid=h5_group_info';
const String _promoTargetRangeUrl =
    'https://pan.xunlei.com/s/VOodpELVGUCsmDw41eT_cxBaA1?pwd=2x75';
const String _promoProjectUrl = 'https://jsxposed.org';
const String _promoRepositoryUrl = 'https://github.com/dugongzi/JsxposedX';

const List<_PromoLink> _promoCreatorLinks = [
  _PromoLink(
    title: 'Facebook',
    url: 'https://www.facebook.com/share/16nAHDLhAp/?mibextid=wwXIfr',
    iconUrl: AssetsConstants.facebook,
  ),
  _PromoLink(
    title: 'TikTok',
    url: 'https://www.tiktok.com/@wanfengd?_r=1&_t=ZP-94YMtmcFzAN',
    iconUrl: AssetsConstants.tiktok,
  ),
  _PromoLink(
    title: '抖音',
    url: 'https://v.douyin.com/hgm3ny4eehs/',
    iconUrl: AssetsConstants.tiktok,
  ),
  _PromoLink(
    title: '哔哩哔哩',
    url: 'https://b23.tv/wIvEf06',
    iconUrl: AssetsConstants.blbl,
  ),
  _PromoLink(
    title: 'YouTube',
    url:
        'https://youtube.com/channel/UCXH3m2W67bwMDBsTRibagmw?si=i1kwAbgOMrY3gtKE',
    iconUrl: AssetsConstants.youtube,
  ),
];

class _PromoLink {
  const _PromoLink({
    required this.title,
    required this.url,
    required this.iconUrl,
  });

  final String title;
  final String url;
  final String iconUrl;
}

class _DesktopWorkbenchView extends HookConsumerWidget {
  const _DesktopWorkbenchView();

  // 输出面板高度约束，交互对齐 VS Code：最小高度防止过度收缩，
  // 拖拽上限为窗口高度减去编辑器最小可用空间。
  static const _defaultOutputHeight = 240.0;
  static const _minOutputHeight = 100.0;
  static const _minEditorHeight = 140.0;

  // 侧栏宽度约束，交互与输出面板一致：拖拽调宽、双击复位
  static const _defaultSidebarWidth = 220.0;
  static const _minSidebarWidth = 170.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(desktopConnectionProvider);
    final colors = context.colorScheme;
    final outputExpanded = useState(true);
    final outputHeight = useState(_defaultOutputHeight);
    final sidebarWidth = useState(_defaultSidebarWidth);

    // 连接建立后拉一次手机端控制台状态，保证暂停/自动滚动/搜索与手机端一致
    useEffect(() {
      if (connection.isConnected) {
        ref.read(desktopLogsProvider.notifier).syncState();
      }
      return null;
    }, [connection.isConnected]);

    return ColoredBox(
      color: colors.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showProjectPane = constraints.maxWidth >= 700;
          final showExpandedOutput =
              outputExpanded.value && constraints.maxHeight >= 240;
          // 拖拽上限：至少给编辑器留出最小空间；窗口太矮时退化为最小面板高度
          final maxOutputHeight = math.max(
            _minOutputHeight,
            constraints.maxHeight - _minEditorHeight,
          );
          final panelHeight = showExpandedOutput
              ? outputHeight.value.clamp(_minOutputHeight, maxOutputHeight)
              : 39.0;
          final maxSidebarWidth = math.max(
            _minSidebarWidth,
            constraints.maxWidth * 0.5,
          );
          final sideWidth = sidebarWidth.value.clamp(
            _minSidebarWidth,
            maxSidebarWidth,
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showProjectPane) ...[
                SizedBox(width: sideWidth, child: const _ProjectExplorer()),
                _SidebarSash(
                  width: sideWidth,
                  minWidth: _minSidebarWidth,
                  maxWidth: maxSidebarWidth,
                  onResize: (value) => sidebarWidth.value = value.clamp(
                    _minSidebarWidth,
                    maxSidebarWidth,
                  ),
                  onReset: () => sidebarWidth.value = _defaultSidebarWidth,
                ),
              ],
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _EditorWorkspace(
                        key: ref.watch(_editorWorkspaceKeyProvider),
                        connected: connection.isConnected,
                      ),
                    ),
                    if (showExpandedOutput)
                      _PanelSash(
                        height: panelHeight,
                        minHeight: _minOutputHeight,
                        maxHeight: maxOutputHeight,
                        onResize: (value) => outputHeight.value = value.clamp(
                          _minOutputHeight,
                          maxOutputHeight,
                        ),
                        onReset: () =>
                            outputHeight.value = _defaultOutputHeight,
                      ),
                    if (constraints.maxHeight >= 40)
                      SizedBox(
                        height: panelHeight,
                        child: _RunOutputPanel(
                          expanded: showExpandedOutput,
                          onToggle: () =>
                              outputExpanded.value = !outputExpanded.value,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _showDeviceDetails(
  BuildContext context,
  DesktopConnectionState connection,
) async {
  final info = connection.deviceInfo;
  if (info == null) return;
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(info.model ?? context.l10n.desktopDeviceDefaultName),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.desktopDeviceSummary(
                info.manufacturer ?? 'Android',
                '${info.androidApi}',
                info.abi,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.desktopDeviceCapabilities,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...?connection.capabilities?.values.entries.map(
              (entry) => _CapabilityRow(name: entry.key, value: entry.value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

/// 资源管理器与编辑器共享的脚本选择状态
@immutable
class DesktopScriptSelection {
  const DesktopScriptSelection({
    required this.packageName,
    required this.source,
    required this.localPath,
    required this.name,
    this.enabled = false,
  });

  final String packageName;
  final String source;
  final String localPath;
  final String name;

  /// 打开时的启用状态，仅作编辑器开关的初值；
  /// 不参与相等判断，避免切换开关导致重新拉取脚本。
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      other is DesktopScriptSelection &&
      other.packageName == packageName &&
      other.source == source &&
      other.localPath == localPath;

  @override
  int get hashCode => Object.hash(packageName, source, localPath);
}

class _SelectedScriptNotifier extends Notifier<DesktopScriptSelection?> {
  @override
  DesktopScriptSelection? build() => null;

  set selection(DesktopScriptSelection? value) {
    state = value;
    // 切换项目时自动启动控制台（后台原生实现，划掉应用后依然可用）
    if (value != null) {
      final logs = ref.read(desktopLogsProvider.notifier);
      // 避免重复启动（已在运行且目标包名匹配则跳过）
      if (logs.state.state.targetPackage != value.packageName) {
        logs.start(value.packageName);
      }
    }
  }
}

final _selectedScriptProvider =
    NotifierProvider<_SelectedScriptNotifier, DesktopScriptSelection?>(
      _SelectedScriptNotifier.new,
    );

// 全局 key 用于访问编辑器状态以保存内容
final _editorWorkspaceKeyProvider = Provider<GlobalKey<_EditorWorkspaceState>>(
  (ref) => GlobalKey<_EditorWorkspaceState>(),
);

class _ProjectExplorer extends ConsumerWidget {
  const _ProjectExplorer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(desktopConnectionProvider);
    final selected = ref.watch(_selectedScriptProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.desktopExplorerTitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              if (connection.isConnected)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16),
                  iconSize: 16,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  tooltip: context.l10n.refresh,
                  onPressed: () {
                    // 触发刷新
                    ref
                        .read(desktopConnectionProvider.notifier)
                        .contextRevision
                        .value++;
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: !connection.isConnected
              ? _ExplorerPlaceholder(
                  icon: Icons.link_off,
                  message: context.l10n.desktopEditorConnectDevice,
                )
              : _ProjectTree(
                  connection: connection,
                  selected: selected,
                  onSelect: (selection) =>
                      ref.read(_selectedScriptProvider.notifier).selection =
                          selection,
                ),
        ),
      ],
    );
  }
}

class _ExplorerPlaceholder extends StatelessWidget {
  const _ExplorerPlaceholder({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, size: 32, color: colors.outline),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// 项目（包名目录）二级树，脚本按 Frida / Xposed 分组
class _ProjectTree extends HookConsumerWidget {
  const _ProjectTree({
    super.key,
    required this.connection,
    required this.selected,
    required this.onSelect,
  });

  final DesktopConnectionState connection;
  final DesktopScriptSelection? selected;
  final ValueChanged<DesktopScriptSelection> onSelect;

  Future<_ExplorerData> _load(WidgetRef ref) async {
    final notifier = ref.read(desktopConnectionProvider.notifier);
    final projects = await notifier.listProjects();
    final scripts = <String, Map<String, List<DesktopScript>>>{};
    for (final project in projects) {
      final bySource = <String, List<DesktopScript>>{};
      for (final source in JsxposedScriptSource.values) {
        bySource[source] = await notifier.listScripts(
          packageName: project.packageName,
          source: source,
        );
      }
      scripts[project.packageName] = bySource;
    }
    return _ExplorerData(projects: projects, scripts: scripts);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsedProjects = useState(<String>{});
    final collapsedGroups = useState(<String>{});
    final data = useState<_ExplorerData?>(null);
    final error = useState<Object?>(null);
    final loading = useState(true);

    // 初始加载
    useEffect(() {
      _load(ref)
          .then((result) {
            data.value = result;
            loading.value = false;
          })
          .catchError((e) {
            error.value = e;
            loading.value = false;
          });
      return null;
    }, const []);

    // 监听 contextRevision 变化（创建/删除脚本后自动刷新）
    final notifier = ref.read(desktopConnectionProvider.notifier);
    useValueListenable(notifier.contextRevision);
    useEffect(() {
      // contextRevision 变化时重新加载
      if (data.value != null) {
        // 不是初次加载才触发
        loading.value = true;
        error.value = null;
        _load(ref)
            .then((result) {
              data.value = result;
              loading.value = false;
            })
            .catchError((e) {
              error.value = e;
              loading.value = false;
            });
      }
      return null;
    }, [notifier.contextRevision.value]);

    if (error.value != null) {
      return _ExplorerPlaceholder(
        icon: Icons.error_outline,
        message: '${error.value}',
      );
    }
    if (loading.value || data.value == null) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final explorerData = data.value!;
    if (explorerData.projects.isEmpty) {
      return _ExplorerPlaceholder(
        icon: Icons.folder_off_outlined,
        message: context.l10n.desktopExplorerDescription,
      );
    }
    final rows = _flatten(
      explorerData,
      collapsedProjects.value,
      collapsedGroups.value,
    );
    // 懒加载：行 widget 由 itemBuilder 按可视范围按需构建，
    // 大量脚本时只渲染屏幕内的列表项
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final selected = this.selected;
        switch (rows[index]) {
          case _ProjectRow(:final project):
            return _ProjectNode(
              project: project,
              expanded: !collapsedProjects.value.contains(project.packageName),
              onToggle: () {
                final next = {...collapsedProjects.value};
                if (next.contains(project.packageName)) {
                  next.remove(project.packageName);
                } else {
                  next.add(project.packageName);
                }
                collapsedProjects.value = next;
              },
            );
          case _GroupRow(:final project, :final source):
            return _ScriptGroup(
              source: source,
              packageName: project.packageName,
              expanded: !collapsedGroups.value.contains(
                '${project.packageName}:$source',
              ),
              onToggle: () {
                final key = '${project.packageName}:$source';
                final next = {...collapsedGroups.value};
                if (next.contains(key)) {
                  next.remove(key);
                } else {
                  next.add(key);
                }
                collapsedGroups.value = next;
              },
              onSelect: onSelect,
            );
          case _ScriptRow(:final project, :final source, :final script):
            return _ScriptNode(
              packageName: project.packageName,
              source: source,
              script: script,
              active:
                  selected?.packageName == project.packageName &&
                  selected?.source == source &&
                  selected?.localPath == script.localPath,
              onSelect: onSelect,
            );
          case _GroupEmptyRow():
            return Padding(
              padding: const EdgeInsets.fromLTRB(34, 2, 12, 2),
              child: Text(
                context.l10n.desktopExplorerNoScripts,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colorScheme.outline,
                ),
              ),
            );
        }
      },
    );
  }

  /// 把「项目 → 分组 → 脚本」树打平为行数据，折叠的子树直接跳过不产生行
  List<_ExplorerRow> _flatten(
    _ExplorerData data,
    Set<String> collapsedProjects,
    Set<String> collapsedGroups,
  ) {
    final rows = <_ExplorerRow>[];
    for (final project in data.projects) {
      rows.add(_ProjectRow(project));
      if (collapsedProjects.contains(project.packageName)) continue;
      final bySource =
          data.scripts[project.packageName] ??
          const <String, List<DesktopScript>>{};
      for (final source in JsxposedScriptSource.values) {
        rows.add(_GroupRow(project, source));
        if (collapsedGroups.contains('${project.packageName}:$source')) {
          continue;
        }
        final scripts = bySource[source] ?? const <DesktopScript>[];
        if (scripts.isEmpty) {
          rows.add(const _GroupEmptyRow());
          continue;
        }
        for (final script in scripts) {
          rows.add(
            _ScriptRow(project: project, source: source, script: script),
          );
        }
      }
    }
    return rows;
  }
}

class _ExplorerData {
  const _ExplorerData({required this.projects, required this.scripts});

  final List<DesktopProject> projects;
  final Map<String, Map<String, List<DesktopScript>>> scripts;
}

/// 资源管理器打平后的行数据，供 ListView.builder 按需构建行 widget
sealed class _ExplorerRow {
  const _ExplorerRow();
}

class _ProjectRow extends _ExplorerRow {
  const _ProjectRow(this.project);

  final DesktopProject project;
}

class _GroupRow extends _ExplorerRow {
  const _GroupRow(this.project, this.source);

  final DesktopProject project;
  final String source;
}

class _ScriptRow extends _ExplorerRow {
  const _ScriptRow({
    required this.project,
    required this.source,
    required this.script,
  });

  final DesktopProject project;
  final String source;
  final DesktopScript script;
}

class _GroupEmptyRow extends _ExplorerRow {
  const _GroupEmptyRow();
}

class _ProjectNode extends StatefulWidget {
  const _ProjectNode({
    required this.project,
    required this.expanded,
    required this.onToggle,
  });

  final DesktopProject project;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  State<_ProjectNode> createState() => _ProjectNodeState();
}

class _ProjectNodeState extends State<_ProjectNode> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final name = widget.project.name.isEmpty
        ? widget.project.packageName
        : widget.project.name;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onToggle,
        onSecondaryTapUp: (details) {
          // _showGroupContextMenu(context, details.globalPosition);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovering
                ? colors.surfaceContainerHighest.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                widget.expanded ? Icons.expand_more : Icons.chevron_right,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              _AppEntryIcon(iconUrl: widget.project.iconUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: name,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Tooltip(
                      message: widget.project.packageName,
                      child: Text(
                        widget.project.packageName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScriptGroup extends ConsumerStatefulWidget {
  const _ScriptGroup({
    required this.source,
    required this.expanded,
    required this.onToggle,
    required this.packageName,
    required this.onSelect,
  });

  final String source;
  final bool expanded;
  final VoidCallback onToggle;
  final String packageName;
  final ValueChanged<DesktopScriptSelection> onSelect;

  @override
  ConsumerState<_ScriptGroup> createState() => _ScriptGroupState();
}

class _ScriptGroupState extends ConsumerState<_ScriptGroup> {
  bool _hovering = false;

  void _showGroupContextMenu(BuildContext context, Offset position) {
    final colors = context.colorScheme;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.add_outlined, size: 16, color: colors.onSurface),
              const SizedBox(width: 12),
              Text(context.l10n.create),
            ],
          ),
          onTap: () {
            Future.microtask(() => _createScript());
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.download_outlined, size: 16, color: colors.onSurface),
              const SizedBox(width: 12),
              Text(context.l10n.importScript),
            ],
          ),
          onTap: () {
            Future.microtask(() => _importScript());
          },
        ),
      ],
    );
  }

  Future<void> _createScript() async {
    final scriptName = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(context.l10n.createScript),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: context.l10n.scriptName,
              hintText: 'my_script.js',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(context.l10n.create),
            ),
          ],
        );
      },
    );

    if (scriptName == null || scriptName.isEmpty) return;

    // 确保文件名以 .js 结尾
    final fileName = scriptName.endsWith('.js') ? scriptName : '$scriptName.js';

    try {
      // 创建空脚本
      final notifier = ref.read(desktopConnectionProvider.notifier);
      await notifier.writeScript(
        packageName: widget.packageName,
        source: widget.source,
        localPath: fileName,
        content: '// ${context.l10n.newScript}\n',
      );

      if (mounted) {
        Toast.showToast(context, context.l10n.createSuccess);
        // 创建成功后自动切换到新脚本
        widget.onSelect(
          DesktopScriptSelection(
            packageName: widget.packageName,
            source: widget.source,
            localPath: fileName,
            name: fileName,
            enabled: false,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Toast.showToast(context, '${context.l10n.createFailed}: $e');
      }
    }
  }

  Future<void> _importScript() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['js'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      final notifier = ref.read(desktopConnectionProvider.notifier);

      for (final file in result.files) {
        if (file.path == null) continue;

        final content = await File(file.path!).readAsString();
        final fileName = file.name;

        await notifier.writeScript(
          packageName: widget.packageName,
          source: widget.source,
          localPath: fileName,
          content: content,
        );
      }

      if (mounted) {
        Toast.showToast(context, context.l10n.importSuccess);
      }
    } catch (e) {
      if (mounted) {
        Toast.showToast(context, '${context.l10n.importFailed}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final label = widget.source == JsxposedScriptSource.frida
        ? context.l10n.desktopExplorerFridaScripts
        : context.l10n.desktopExplorerXposedScripts;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onToggle,
        onSecondaryTapUp: (details) {
          _showGroupContextMenu(context, details.globalPosition);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 12, 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: _hovering
                ? colors.surfaceContainerHigh
                : colors.surfaceContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(
                color: widget.source == JsxposedScriptSource.frida
                    ? const Color(0xFFE85C45)
                    : const Color(0xFF5C9CEE),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.expanded ? Icons.expand_more : Icons.chevron_right,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 开关启停状态的内存缓存，用于左侧脚本列表与开关联动（开启→绿色文字）
final _scriptEnabledOverrides =
    NotifierProvider<_ScriptEnabledOverrides, Map<String, bool>>(
      _ScriptEnabledOverrides.new,
    );

class _ScriptEnabledOverrides extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => const {};
  void set(String key, bool value) => state = {...state, key: value};
}

class _ScriptNode extends ConsumerStatefulWidget {
  const _ScriptNode({
    required this.packageName,
    required this.source,
    required this.script,
    required this.active,
    required this.onSelect,
  });

  final String packageName;
  final String source;
  final DesktopScript script;
  final bool active;
  final ValueChanged<DesktopScriptSelection> onSelect;

  @override
  ConsumerState<_ScriptNode> createState() => _ScriptNodeState();
}

class _ScriptNodeState extends ConsumerState<_ScriptNode> {
  bool _hovering = false;

  Future<void> _saveCurrentScriptBeforeSwitch() async {
    // 获取当前正在编辑的脚本
    final currentSelection = ref.read(_selectedScriptProvider);
    if (currentSelection == null) return;

    // 如果点击的是当前正在编辑的脚本，不需要保存
    if (currentSelection.packageName == widget.packageName &&
        currentSelection.source == widget.source &&
        currentSelection.localPath == widget.script.localPath) {
      return;
    }

    // 获取编辑器状态并保存
    try {
      final workspaceKey = ref.read(_editorWorkspaceKeyProvider);
      final workspaceState = workspaceKey.currentState;
      if (workspaceState != null && workspaceState._controller != null) {
        await ref
            .read(desktopConnectionProvider.notifier)
            .writeScript(
              packageName: currentSelection.packageName,
              source: currentSelection.source,
              localPath: currentSelection.localPath,
              content: workspaceState._controller!.text,
            );
      }
    } catch (e) {
      // 保存失败不影响切换
    }
  }

  void _showScriptContextMenu(BuildContext context, Offset position) {
    final colors = context.colorScheme;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 16, color: colors.onSurface),
              const SizedBox(width: 12),
              Text(context.l10n.share),
            ],
          ),
          onTap: () {
            Future.microtask(() => _shareScript());
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 16, color: colors.error),
              const SizedBox(width: 12),
              Text(context.l10n.delete, style: TextStyle(color: colors.error)),
            ],
          ),
          onTap: () {
            Future.microtask(() => _deleteScript());
          },
        ),
      ],
    );
  }

  Future<void> _shareScript() async {
    try {
      // 先获取脚本内容
      final notifier = ref.read(desktopConnectionProvider.notifier);
      final content = await notifier.readScript(
        packageName: widget.packageName,
        source: widget.source,
        localPath: widget.script.localPath,
      );

      // 导出脚本文件
      final fileName = widget.script.name;
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: context.l10n.share,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['js'],
      );

      if (filePath != null) {
        final file = File(filePath);
        await file.writeAsString(content);
        if (mounted) {
          Toast.showToast(context, context.l10n.shareSuccess);
        }
      }
    } catch (e) {
      if (mounted) {
        Toast.showToast(context, '${context.l10n.shareFailed}: $e');
      }
    }
  }

  Future<void> _deleteScript() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.confirmDelete),
        content: Text(
          '${context.l10n.deleteScriptHint}: ${widget.script.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(desktopConnectionProvider.notifier)
          .deleteScript(
            packageName: widget.packageName,
            source: widget.source,
            localPath: widget.script.localPath,
          );

      if (mounted) {
        Toast.showToast(context, context.l10n.deleteSuccess);
        // 删除脚本后，如果当前正在编辑该脚本，则清空编辑器
        if (widget.active) {
          ref.read(_selectedScriptProvider.notifier).selection = null;
        }
      }
    } catch (e) {
      if (mounted) {
        Toast.showToast(context, '${context.l10n.deleteFailed}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final overrides = ref.watch(_scriptEnabledOverrides);
    final key =
        '${widget.packageName}|${widget.source}|${widget.script.localPath}';
    final enabled = overrides[key] ?? widget.script.enabled;
    final isDark = colors.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Container(
        margin: const EdgeInsets.fromLTRB(28, 3, 12, 3),
        decoration: BoxDecoration(
          color: widget.active
              ? (isDark
                    ? colors.primary.withValues(alpha: 0.25)
                    : colors.primary.withValues(alpha: 0.15))
              : _hovering
              ? colors.surfaceContainerHighest.withValues(alpha: 0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: widget.active
              ? Border.all(
                  color: isDark
                      ? colors.primary.withValues(alpha: 0.6)
                      : colors.primary.withValues(alpha: 0.5),
                  width: 1,
                )
              : null,
          boxShadow: widget.active
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(
                      alpha: isDark ? 0.3 : 0.15,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: () async {
            // 切换脚本前先保存当前脚本
            await _saveCurrentScriptBeforeSwitch();
            widget.onSelect(
              DesktopScriptSelection(
                packageName: widget.packageName,
                source: widget.source,
                localPath: widget.script.localPath,
                name: widget.script.name,
                enabled: widget.script.enabled,
              ),
            );
          },
          onSecondaryTapUp: (details) {
            _showScriptContextMenu(context, details.globalPosition);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const _JsScriptIcon(),
                const SizedBox(width: 10),
                Expanded(
                  child: Tooltip(
                    message: widget.script.name,
                    child: Text(
                      widget.script.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: widget.active
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: enabled
                            ? (widget.active && isDark
                                  ? const Color(0xFF66BB6A)
                                  : const Color(0xFF2E7D32))
                            : widget.active
                            ? (isDark
                                  ? colors.primary
                                  : colors.primary.withValues(alpha: 0.9))
                            : colors.onSurface,
                      ),
                    ),
                  ),
                ),
                if (enabled)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 侧栏与内容区之间的拖拽分隔条，交互对齐 VS Code：
/// 悬停/拖拽时高亮，光标为左右调整尺寸，向右拖加宽侧栏，双击恢复默认宽度。
class _SidebarSash extends StatefulWidget {
  const _SidebarSash({
    required this.width,
    required this.minWidth,
    required this.maxWidth,
    required this.onResize,
    required this.onReset,
  });

  final double width;
  final double minWidth;
  final double maxWidth;
  final ValueChanged<double> onResize;
  final VoidCallback onReset;

  @override
  State<_SidebarSash> createState() => _SidebarSashState();
}

class _SidebarSashState extends State<_SidebarSash> {
  bool _active = false;
  double? _dragStartX;
  double? _dragStartWidth;

  void _endDrag() {
    setState(() {
      _dragStartX = null;
      _dragStartWidth = null;
      _active = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final highlight = colors.primary.withValues(alpha: 0.55);
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (_) => setState(() => _active = true),
      onExit: (_) => setState(() => _active = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          _dragStartX = details.globalPosition.dx;
          _dragStartWidth = widget.width;
          setState(() => _active = true);
        },
        onHorizontalDragUpdate: (details) {
          final startWidth = _dragStartWidth;
          final startX = _dragStartX;
          if (startWidth == null || startX == null) return;
          widget.onResize(startWidth + details.globalPosition.dx - startX);
        },
        onHorizontalDragEnd: (_) => _endDrag(),
        onHorizontalDragCancel: _endDrag,
        onDoubleTap: widget.onReset,
        child: SizedBox(
          width: 5,
          child: Center(
            child: ColoredBox(
              color: _active ? highlight : colors.outlineVariant,
              child: const SizedBox(width: 1, height: double.infinity),
            ),
          ),
        ),
      ),
    );
  }
}

/// 应用条目的 app 图标：Android 机器人，仿 VS Code 文件图标主题的
/// 彩色扁平字形风格（seti/Material Icon Theme 均为此路线）。
class _AppEntryIcon extends StatelessWidget {
  const _AppEntryIcon({this.iconUrl});

  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      // 支持 data URL (base64)
      if (iconUrl!.startsWith('data:image/')) {
        try {
          final base64String = iconUrl!.split(',').last;
          final bytes = base64Decode(base64String);
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              bytes,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.android_outlined,
                  size: 28,
                  color: Color(0xFF3DDC84),
                );
              },
            ),
          );
        } catch (e) {
          return const Icon(
            Icons.android_outlined,
            size: 28,
            color: Color(0xFF3DDC84),
          );
        }
      }
      // 支持网络 URL
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CacheImage(
          imageUrl: iconUrl!,
          width: 28,
          height: 28,
          fit: BoxFit.cover,
        ),
      );
    }
    return const Icon(
      Icons.android_outlined,
      size: 28,
      color: Color(0xFF3DDC84),
    );
  }
}

/// JS 脚本的文件图标：黄底「JS」方块，对齐 VS Code 文件图标主题中
/// JavaScript 的经典样式。
class _JsScriptIcon extends StatelessWidget {
  const _JsScriptIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF7DF1E),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'JS',
        style: TextStyle(
          fontSize: 7,
          height: 1,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
          letterSpacing: -0.5,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

class _CapabilityRow extends StatelessWidget {
  const _CapabilityRow({required this.name, required this.value});

  final String name;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final available = value is bool
        ? value as bool
        : value is Map
        ? value['available'] == true
        : value != null;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        available ? Icons.check_circle_outline : Icons.block,
        size: 17,
        color: available
            ? const Color(0xFF2E7D32)
            : context.colorScheme.outline,
      ),
      title: Text(name),
    );
  }
}

class _EditorWorkspace extends ConsumerStatefulWidget {
  const _EditorWorkspace({super.key, required this.connected});

  final bool connected;

  @override
  ConsumerState<_EditorWorkspace> createState() => _EditorWorkspaceState();
}

class _EditorWorkspaceState extends ConsumerState<_EditorWorkspace> {
  DesktopScriptSelection? _loaded;
  CodeLineEditingController? _controller;
  bool _loading = false;
  bool _running = false;

  /// Frida 脚本保存后是否重启目标应用。Xposed 必须重启才能生效，故不参与开关。
  bool _restartApp = false;

  /// 当前脚本在设备端的启用状态，开关切换后立即写入设备端
  bool _scriptEnabled = false;
  bool _togglingScript = false;
  String? _error;

  static final _fridaPrompts = buildFridaPromptsBuilder();
  static final _xposedPrompts = buildJsxposedPromptsBuilder();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // build 只负责渲染，选中变化用 listen 处理，避免在 build 期间 setState
    _syncSelection(ref.read(_selectedScriptProvider));
  }

  /// 切换选中脚本时重新从手机端拉取内容，本地未保存的修改会被覆盖
  void _syncSelection(DesktopScriptSelection? selection) {
    if (selection == _loaded) return;
    if (selection == null) {
      setState(() {
        _loaded = null;
        _controller?.dispose();
        _controller = null;
        _error = null;
        _scriptEnabled = false;
      });
      return;
    }
    // 优先使用最近开关确认后的缓存值（设备真实状态），避免旧 listScripts 覆盖
    final overrides = ref.read(_scriptEnabledOverrides);
    final key =
        '${selection.packageName}|${selection.source}|${selection.localPath}';
    setState(() {
      _loaded = selection;
      _scriptEnabled = overrides[key] ?? selection.enabled;
      _loading = true;
      _error = null;
    });
    final notifier = ref.read(desktopConnectionProvider.notifier);
    notifier
        .readScript(
          packageName: selection.packageName,
          source: selection.source,
          localPath: selection.localPath,
        )
        .then((content) {
          if (!mounted || _loaded != selection) return;
          final previous = _controller;
          setState(() {
            _controller = CodeLineEditingController.fromText(content);
            _loading = false;
          });
          previous?.dispose();
        })
        .catchError((Object error) {
          if (!mounted || _loaded != selection) return;
          setState(() {
            _loading = false;
            _error = '$error';
          });
        });
  }

  /// Ctrl/Cmd+S 与运行按钮共用：保存到手机端并触发注入。
  /// Xposed 侧恒为重启应用，Frida 侧由用户开关决定。
  Future<void> _saveAndRun() async {
    final selection = _loaded;
    final controller = _controller;
    if (selection == null || controller == null) return;
    setState(() => _running = true);
    final isFrida = selection.source == JsxposedScriptSource.frida;
    final runningMessage = context.l10n.desktopEditorRunning;
    try {
      await ref
          .read(desktopConnectionProvider.notifier)
          .runScript(
            packageName: selection.packageName,
            source: selection.source,
            localPath: selection.localPath,
            content: controller.text,
            restartApp: isFrida ? _restartApp : true,
          );
      if (mounted) {
        Toast.showToast(context, runningMessage);
      }
    } catch (error) {
      if (mounted) {
        Toast.showToast(context, '$error');
      }
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  /// Ctrl/Cmd+Shift+F 格式化代码
  void _formatCode() {
    final controller = _controller;
    if (controller == null) return;

    try {
      final text = controller.text;
      final formatted = JsFormatter.format(text);
      if (formatted != text) {
        controller.text = formatted;
      }
    } catch (error) {
      Toast.showToast(context, '格式化失败: $error');
    }
  }

  /// 切换当前脚本在设备端的启用状态，成功后刷新资源管理器里的状态
  Future<void> _toggleScriptEnabled(bool enabled) async {
    final selection = _loaded;
    if (selection == null || _togglingScript) return;
    setState(() => _togglingScript = true);
    final notifier = ref.read(desktopConnectionProvider.notifier);
    try {
      await notifier.toggleScript(
        packageName: selection.packageName,
        source: selection.source,
        localPath: selection.localPath,
        enabled: enabled,
      );
      if (!mounted) return;
      // 设备端已确认，校正本地状态（与乐观值一致）
      setState(() => _scriptEnabled = enabled);
      // 联动左侧脚本列表（开启→绿色文字）
      ref
          .read(_scriptEnabledOverrides.notifier)
          .set(
            '${selection.packageName}|${selection.source}|${selection.localPath}',
            enabled,
          );
    } catch (error) {
      if (mounted) {
        Toast.showToast(context, '$error');
      }
    } finally {
      if (mounted) setState(() => _togglingScript = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    // 选中变化通过 listen 处理，build 只做渲染，避免每次重建都重新加载脚本
    ref.listen(_selectedScriptProvider, (_, next) => _syncSelection(next));
    final selection = _loaded;

    return Column(
      children: [
        _buildEditorToolbar(colors, selection),
        Expanded(child: _buildBody(colors, selection)),
      ],
    );
  }

  Widget _buildEditorToolbar(
    ColorScheme colors,
    DesktopScriptSelection? selection,
  ) {
    final isFrida = selection?.source == JsxposedScriptSource.frida;
    final busy = _running || _loading;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: colors.surfaceContainerLow,
      child: Row(
        children: [
          // 脚本选项菜单放在标签页最左侧，避免开关挤占标题栏
          if (selection != null) ...[
            PopupMenuButton<Never>(
              tooltip: context.l10n.desktopEditorOptions,
              icon: const Icon(Icons.tune, size: 18),
              padding: EdgeInsets.zero,
              splashRadius: 18,
              itemBuilder: (context) => [
                // 用开关直接呈现状态，一眼能看出脚本在设备上是开还是关；
                // 不设 value，点开关不会收起菜单
                PopupMenuItem<Never>(
                  padding: const EdgeInsets.only(left: 14, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.desktopEditorRunScript,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: busy
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                              ),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setMenuState) => Switch(
                          value: _scriptEnabled,
                          onChanged: busy || _togglingScript
                              ? null
                              : (value) {
                                  // 点击即本地翻转（菜单内即时显示），后台再同步设备
                                  setState(() => _scriptEnabled = value);
                                  setMenuState(() {});
                                  _toggleScriptEnabled(value);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFrida)
                  PopupMenuItem<Never>(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.l10n.desktopEditorRestartApp,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: busy
                                      ? colors.onSurfaceVariant
                                      : colors.onSurface,
                                ),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (context, setMenuState) => Switch(
                            value: _restartApp,
                            onChanged: busy
                                ? null
                                : (value) {
                                    // 点击即本地翻转（菜单内即时显示）
                                    setState(() => _restartApp = value);
                                    setMenuState(() {});
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 2),
            const _JsScriptIcon(),
          ] else
            const Icon(Icons.code, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selection?.name ?? context.l10n.desktopEditorUntitled,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (selection != null)
            IconButton(
              tooltip: context.l10n.desktopEditorSaveAndRun,
              visualDensity: VisualDensity.compact,
              onPressed: busy ? null : _saveAndRun,
              icon: _running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colors, DesktopScriptSelection? selection) {
    if (selection == null) {
      return _EditorEmptyState(
        icon: Icons.code_outlined,
        title: widget.connected
            ? context.l10n.desktopEditorCreateScript
            : context.l10n.desktopEditorConnectDevice,
        description: context.l10n.desktopEditorDescription,
      );
    }
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (_error != null) {
      return _EditorEmptyState(
        icon: Icons.error_outline,
        title: context.l10n.desktopEditorLoadFailed,
        description: _error!,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CallbackShortcuts(
        bindings: {
          // Ctrl+Alt+L 格式化代码 (Windows/Linux)
          const SingleActivator(
            LogicalKeyboardKey.keyL,
            control: true,
            alt: true,
          ): _formatCode,
          // Cmd+Option+L 格式化代码 (macOS)
          const SingleActivator(LogicalKeyboardKey.keyL, meta: true, alt: true):
              _formatCode,
        },
        child: AppCodeEditor(
          controller: _controller!,
          language: 'javascript',
          readOnly: false,
          // 与手机端共用同一套内置代码提示
          promptsBuilder: selection.source == JsxposedScriptSource.frida
              ? _fridaPrompts
              : _xposedPrompts,
          // 桌面端使用物理键盘，不需要符号输入栏
          showToolbar: false,
          // Ctrl/Cmd+S 保存并运行
          onSave: _saveAndRun,
        ),
      ),
    );
  }
}

class _EditorEmptyState extends StatelessWidget {
  const _EditorEmptyState({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    // 面板拉高会压缩编辑器区，内容超出时可滚动，避免 RenderFlex 溢出条纹
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.outline),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// 编辑器与输出面板之间的拖拽分隔条，交互对齐 VS Code：
/// 平时不可见，悬停/拖拽时高亮，光标为上下调整尺寸，双击恢复默认高度。
/// 分隔条位于面板顶部：向上拖增大面板、向下拖缩小面板，与 VS Code 同向。
class _PanelSash extends StatefulWidget {
  const _PanelSash({
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.onResize,
    required this.onReset,
  });

  final double height;
  final double minHeight;
  final double maxHeight;
  final ValueChanged<double> onResize;
  final VoidCallback onReset;

  @override
  State<_PanelSash> createState() => _PanelSashState();
}

class _PanelSashState extends State<_PanelSash> {
  bool _active = false;
  double? _dragStartY;
  double? _dragStartHeight;

  void _endDrag() {
    setState(() {
      _dragStartY = null;
      _dragStartHeight = null;
      _active = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final highlight = context.colorScheme.primary.withValues(alpha: 0.55);
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUpDown,
      onEnter: (_) => setState(() => _active = true),
      onExit: (_) => setState(() => _active = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) {
          _dragStartY = details.globalPosition.dy;
          _dragStartHeight = widget.height;
          setState(() => _active = true);
        },
        onVerticalDragUpdate: (details) {
          final startHeight = _dragStartHeight;
          final startY = _dragStartY;
          if (startHeight == null || startY == null) return;
          widget.onResize(startHeight + startY - details.globalPosition.dy);
        },
        onVerticalDragEnd: (_) => _endDrag(),
        onVerticalDragCancel: _endDrag,
        onDoubleTap: widget.onReset,
        child: SizedBox(
          width: double.infinity,
          height: 4,
          child: ColoredBox(color: _active ? highlight : Colors.transparent),
        ),
      ),
    );
  }
}

class _RunOutputPanel extends ConsumerStatefulWidget {
  const _RunOutputPanel({required this.expanded, required this.onToggle});

  final bool expanded;
  final VoidCallback onToggle;

  @override
  ConsumerState<_RunOutputPanel> createState() => _RunOutputPanelState();
}

class _RunOutputPanelState extends ConsumerState<_RunOutputPanel> {
  /// 复制的日志条数上限，与手机端控制台保持一致
  static const _maxCopyEntries = 5000;

  /// 搜索输入的防抖时长，避免每次敲键都走一趟协议
  static const _searchDebounce = Duration(milliseconds: 200);

  /// 会话哨兵：命令后追加该语句，用于判定本次输出结束并回传当前目录
  static const _shellDoneCommand =
      r'''printf '\n__JSXDONE__%s|%s\n' "$?" "$PWD"''';
  static const _shellDoneMarker = '\n__JSXDONE__';

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _shellFocusNode = FocusNode();
  final _shellHistory = <String>[];
  late final Terminal _shellTerminal;
  StreamSubscription<JsxposedMessage>? _shellEventsSub;
  String _shellInput = "";

  /// 命令行提示符里的主机名，连接设备后替换为设备型号
  String _promptHost = 'device';

  /// 常驻会话的当前目录，由哨兵回传，cd 之后提示符随之变化
  String _shellCwd = '~';

  /// 尚未写入终端的输出，用于跨分片识别哨兵行
  String _shellPending = '';
  bool _shellSessionOpen = false;
  Timer? _searchDebounceTimer;
  int _shellHistoryIndex = -1;
  bool _shellRunning = false;
  String? _sourceFilter;
  String? _levelFilter;
  bool _regexEnabled = false;
  bool _caseSensitive = false;
  bool _showHistory = false;
  bool _showTerminal = false;

  @override
  void initState() {
    super.initState();
    _shellTerminal = Terminal(maxLines: 10000, onOutput: _onShellInput);
    _promptHost = _hostFromState(ref.read(desktopConnectionProvider));
    _shellTerminal.write(_shellPrompt);
    // 会话输出由设备端事件推送，这里只负责落到终端缓冲区
    _shellEventsSub = ref
        .read(desktopConnectionProvider.notifier)
        .events
        .listen(_onShellEvent);
    // 终端跟随连接推送：掉线立即提示，设备切换后同步提示符
    ref.listenManual(desktopConnectionProvider, (previous, next) {
      final wasConnected = previous?.isConnected ?? false;
      if (wasConnected && !next.isConnected) {
        _promptHost = 'device';
        // 会话随连接一起失效，重置目录并等待下次连接重建
        _shellSessionOpen = false;
        _shellCwd = '~';
        _shellPending = '';
        // 执行中的命令会因请求失败自行提示，这里只处理空闲时掉线
        if (_shellRunning) return;
        _shellInput = '';
        if (!mounted) return;
        _shellTerminal.write('\r\x1b[K');
        _shellTerminal.write('${context.l10n.desktopShellDisconnected}\r\n');
        _writeShellPrompt();
        return;
      }
      final host = _hostFromState(next);
      if (host == _promptHost) return;
      _promptHost = host;
      // 只有光标停在空提示符上时才重绘，避免打断正在输入或执行的命令
      if (!mounted || _shellRunning || _shellInput.isNotEmpty) return;
      _shellTerminal.write('\r\x1b[K');
      _writeShellPrompt();
    });
    // 自动滚动由手机端的 autoScroll 状态决定，这里只负责落到列表底部
    ref.listenManual(desktopLogsProvider, (previous, next) {
      if (!next.state.autoScroll || !mounted) return;
      if (previous?.entries.length == next.entries.length) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _shellEventsSub?.cancel();
    _searchController.dispose();
    _shellFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 把搜索词防抖后交给手机端，本地不保留搜索状态
  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      _searchDebounce,
      () => ref.read(desktopLogsProvider.notifier).setSearch(value),
    );
  }

  void _copyEntry(DesktopLogEntry entry) {
    Clipboard.setData(ClipboardData(text: _formatEntry(entry)));
    Toast.showToast(context, context.l10n.consoleLogCopied);
  }

  /// 终端把键盘输入以原始序列回调过来，这里自行处理行编辑。
  /// 回车执行、退格删字符、上下键翻历史，其余可见字符直接回显。
  void _onShellInput(String data) {
    var index = 0;
    while (index < data.length) {
      // 方向键等转义序列：\x1b[A 上、\x1b[B 下
      if (data.startsWith('\x1b[A', index)) {
        _navigateShellHistory(false);
        index += 3;
        continue;
      }
      if (data.startsWith('\x1b[B', index)) {
        _navigateShellHistory(true);
        index += 3;
        continue;
      }
      final unit = data[index];
      index++;
      if (unit == '\r' || unit == '\n') {
        _shellTerminal.write('\r\n');
        _submitShellInput();
        return;
      }
      if (unit == '\x7f' || unit == '\b') {
        if (_shellInput.isNotEmpty) {
          _shellInput = _shellInput.substring(0, _shellInput.length - 1);
          _shellTerminal.write('\b \b');
        }
        continue;
      }
      // 其余控制字符忽略，避免污染命令行
      if (unit.codeUnitAt(0) < 0x20) continue;
      _shellInput += unit;
      _shellTerminal.write(unit);
    }
  }

  /// 上下键翻历史，整行替换（先擦掉当前输入再写回目标命令）
  void _replaceShellInput(String next) {
    for (var i = 0; i < _shellInput.length; i++) {
      _shellTerminal.write('\b \b');
    }
    _shellInput = next;
    _shellTerminal.write(next);
  }

  void _navigateShellHistory(bool forward) {
    if (_shellHistory.isEmpty) return;
    final next = forward ? _shellHistoryIndex + 1 : _shellHistoryIndex - 1;
    if (next < -1 || next >= _shellHistory.length) return;
    _shellHistoryIndex = next;
    _replaceShellInput(next == -1 ? '' : _shellHistory[next]);
  }

  void _submitShellInput() {
    final command = _shellInput.trim();
    _shellInput = '';
    if (command.isEmpty) {
      _writeShellPrompt();
      return;
    }
    unawaited(_runShellCommand(command));
  }

  String get _shellPrompt => 'root@$_promptHost:$_shellCwd# ';

  /// 提示符主机名：优先设备型号，回退设备 ID，未连接时为 device
  String _hostFromState(DesktopConnectionState state) {
    final model = state.deviceInfo?.model?.trim();
    if (model != null && model.isNotEmpty) {
      return model.replaceAll(RegExp(r'\s+'), '-');
    }
    final deviceId = state.deviceInfo?.deviceId.trim();
    if (deviceId != null && deviceId.isNotEmpty) return deviceId;
    return 'device';
  }

  void _writeShellPrompt() {
    _shellTerminal.write(_shellPrompt);
  }

  Future<void> _runShellCommand(String command) async {
    if (_shellRunning) return;
    if (_shellHistory.isEmpty || _shellHistory.last != command) {
      _shellHistory.add(command);
    }
    _shellHistoryIndex = -1;
    if (!ref.read(desktopConnectionProvider).isConnected) {
      _shellTerminal.write('${context.l10n.desktopShellStatusNoDevice}\r\n');
      _writeShellPrompt();
      return;
    }
    _shellRunning = true;
    final unavailableText = context.l10n.desktopShellDisconnected;
    try {
      if (!await _ensureShellSession()) {
        throw StateError(unavailableText);
      }
      // 命令后追一条哨兵，用于判定本次输出结束并回报退出码与当前目录
      await ref
          .read(desktopConnectionProvider.notifier)
          .writeShellSession('$command\n$_shellDoneCommand\n');
    } catch (error) {
      if (!mounted) return;
      _shellRunning = false;
      _shellTerminal.write('$error\r\n');
      _writeShellPrompt();
    }
  }

  /// 确保设备端存在常驻 shell 会话，首次使用时开启
  Future<bool> _ensureShellSession() async {
    if (_shellSessionOpen) return true;
    final opened = await ref
        .read(desktopConnectionProvider.notifier)
        .openShellSession();
    _shellSessionOpen = opened;
    return opened;
  }

  /// 常驻会话的推送：输出落到终端，会话结束则复位状态
  void _onShellEvent(JsxposedMessage message) {
    switch (message.event) {
      case JsxposedEvent.shellOutput:
        final payload = message.result;
        if (payload is! Map) return;
        final data = payload['data'];
        if (data is! String || data.isEmpty) return;
        _handleShellOutput(data);
      case JsxposedEvent.shellExit:
        _shellSessionOpen = false;
        _shellPending = '';
        if (!mounted) return;
        if (_shellRunning) {
          _shellRunning = false;
          _writeShellPrompt();
        }
        _shellTerminal.write('${context.l10n.desktopShellSessionClosed}\r\n');
    }
  }

  /// 输出是分片到达的，先缓冲再按哨兵行切分，避免把哨兵写进终端
  void _handleShellOutput(String data) {
    _shellPending += data;
    while (true) {
      final marker = _shellPending.indexOf(_shellDoneMarker);
      if (marker < 0) break;
      final lineEnd = _shellPending.indexOf('\n', marker + 1);
      // 哨兵行尚未收全，等下一片数据
      if (lineEnd < 0) break;
      final head = _shellPending.substring(0, marker);
      final payload = _shellPending
          .substring(marker + _shellDoneMarker.length, lineEnd)
          .trim();
      _shellPending = _shellPending.substring(lineEnd + 1);
      if (head.isNotEmpty) {
        _shellTerminal.write(head.replaceAll('\n', '\r\n'));
      }
      _settleShellCommand(payload);
    }
    if (_shellPending.isNotEmpty) {
      _shellTerminal.write(_shellPending.replaceAll('\n', '\r\n'));
      _shellPending = '';
    }
  }

  /// 哨兵回传格式为「退出码|当前目录」
  void _settleShellCommand(String payload) {
    final separator = payload.indexOf('|');
    final exitCode = separator < 0 ? payload : payload.substring(0, separator);
    final cwd = separator < 0 ? '' : payload.substring(separator + 1).trim();
    if (cwd.isNotEmpty) _shellCwd = cwd;
    _shellRunning = false;
    if (!mounted) return;
    if (exitCode != '0' && exitCode.isNotEmpty) {
      _shellTerminal.write('exit $exitCode\r\n');
    }
    _writeShellPrompt();
  }

  @override
  Widget build(BuildContext context) {
    final mirror = ref.watch(desktopLogsProvider);
    final consoleState = mirror.state;
    final matcher = _SearchMatcher(
      query: consoleState.searchQuery,
      regex: _regexEnabled,
      caseSensitive: _caseSensitive,
    );

    final filtered = [
      for (final entry in mirror.entries)
        if (_sourceFilter == null && _levelFilter == null && !matcher.isActive)
          entry
        else if (_matchesEntry(entry, matcher))
          entry,
    ];
    final levelCounts = _countLevels(filtered);

    final filteredHistory = [
      for (final log in mirror.historyLogs)
        if (_matchesHistory(log, matcher)) log,
    ];

    final list = _showHistory
        ? _buildHistoryList(mirror, filtered, filteredHistory, matcher)
        : _buildLogList(
            entries: filtered,
            totalCount: mirror.entries.length,
            hasFilter: _hasFilter(matcher),
            matcher: matcher,
          );

    final colors = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        children: [
          _ConsoleTabBar(
            terminalSelected: _showTerminal,
            onLogs: () => setState(() => _showTerminal = false),
            onTerminal: () => setState(() => _showTerminal = true),
          ),
          Divider(height: 1, thickness: 0.6, color: colors.outlineVariant),
          if (!_showTerminal) ...[
            _ConsoleToolbar(
              state: consoleState,
              filteredCount: filtered.length,
              totalCount: mirror.entries.length,
              levelCounts: levelCounts,
              regexEnabled: _regexEnabled,
              caseSensitive: _caseSensitive,
              regexValid: matcher.regexValid,
              showHistory: _showHistory,
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onToggleRegex: () =>
                  setState(() => _regexEnabled = !_regexEnabled),
              onToggleCase: () =>
                  setState(() => _caseSensitive = !_caseSensitive),
              onToggleAutoScroll: () => ref
                  .read(desktopLogsProvider.notifier)
                  .setAutoScroll(!consoleState.autoScroll),
              onToggleHistory: () => setState(() {
                _showHistory = !_showHistory;
                if (_showHistory && mirror.historyLogs.isEmpty) {
                  ref.read(desktopLogsProvider.notifier).loadHistory();
                }
              }),
              onTogglePause: () => ref
                  .read(desktopLogsProvider.notifier)
                  .setPaused(!consoleState.isPaused),
              onCopyVisible: () => _copyVisible(filtered),
              onExportVisible: () => _exportVisible(filtered),
              onDeleteHistory: _deleteHistory,
              onClear: () {
                ref.read(desktopLogsProvider.notifier).clear();
              },
              expanded: widget.expanded,
              onToggleExpanded: widget.onToggle,
            ),
            Divider(height: 1, thickness: 0.6, color: colors.outlineVariant),
            _ConsoleFilterRow(
              sourceFilter: _sourceFilter,
              levelFilter: _levelFilter,
              onSourceChanged: (value) {
                setState(() => _sourceFilter = value);
                // 同步到设备端，让原生控制台过滤（划掉应用后也能生效）
                ref.read(desktopLogsProvider.notifier).setSource(value ?? '');
              },
              onLevelChanged: (value) {
                setState(() => _levelFilter = value);
                // 同步到设备端，让原生控制台过滤（划掉应用后也能生效）
                ref.read(desktopLogsProvider.notifier).setLevel(value ?? 'V');
              },
            ),
            Divider(
              height: 1,
              thickness: 0.4,
              color: colors.outlineVariant.withValues(alpha: 0.6),
            ),
            Expanded(child: widget.expanded ? list : const SizedBox.shrink()),
          ] else
            Expanded(
              child: _ShellTerminal(
                terminal: _shellTerminal,
                focusNode: _shellFocusNode,
              ),
            ),
        ],
      ),
    );
  }

  bool _hasFilter(_SearchMatcher matcher) =>
      _sourceFilter != null || _levelFilter != null || matcher.isActive;

  bool _matchesEntry(DesktopLogEntry entry, _SearchMatcher matcher) {
    if (_sourceFilter != null && entry.source != _sourceFilter) return false;
    if (_levelFilter != null && entry.level != _levelFilter) return false;
    if (matcher.isActive && !matcher.matches(entry.searchText)) return false;
    return true;
  }

  bool _matchesHistory(DesktopHistoryLog log, _SearchMatcher matcher) {
    if (!_showHistory) return false;
    if (_sourceFilter != null && log.source != _sourceFilter) return false;
    if (_levelFilter != null && log.level != _levelFilter) return false;
    if (matcher.isActive) {
      final haystack = [
        log.message,
        log.scriptName,
        log.source,
        log.stackTrace,
      ].join('\n');
      if (!matcher.matches(haystack)) return false;
    }
    return true;
  }

  Map<String, int> _countLevels(List<DesktopLogEntry> entries) {
    final counts = {'D': 0, 'I': 0, 'W': 0, 'E': 0};
    for (final entry in entries) {
      if (counts.containsKey(entry.level)) {
        counts[entry.level] = counts[entry.level]! + 1;
      }
    }
    return counts;
  }

  Widget _buildLogList({
    required List<DesktopLogEntry> entries,
    required int totalCount,
    required bool hasFilter,
    required _SearchMatcher matcher,
  }) {
    if (entries.isEmpty) {
      return _ConsoleEmptyState(
        isFiltered: hasFilter,
        message: hasFilter ? context.l10n.noLogsFiltered : context.l10n.noLogs,
      );
    }
    return SelectionArea(
      child: SuperListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: entries.length,
        itemBuilder: (context, index) => _LogRow(
          entry: entries[index],
          matcher: matcher,
          onCopy: () => _copyEntry(entries[index]),
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    DesktopConsoleMirror mirror,
    List<DesktopLogEntry> liveEntries,
    List<DesktopHistoryLog> historyEntries,
    _SearchMatcher matcher,
  ) {
    if (mirror.historyLoading && mirror.historyLogs.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final conversationId = mirror.state.sessionConversationId;
    if (conversationId == null || conversationId.isEmpty) {
      return _ConsoleEmptyState(
        isFiltered: false,
        message: context.l10n.consoleDeleteHistoryUnavailable,
      );
    }
    if (mirror.historyLogs.isEmpty && liveEntries.isEmpty) {
      return _ConsoleEmptyState(
        isFiltered: false,
        message: context.l10n.consoleNoHistory,
      );
    }
    return SelectionArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 4)),
          SliverToBoxAdapter(
            child: _HistoryLoadOlderButton(
              loading: mirror.historyLoading,
              hasMore: mirror.historyHasMore,
              error: mirror.historyError,
              onTap: () => ref
                  .read(desktopLogsProvider.notifier)
                  .loadHistory(older: true),
            ),
          ),
          SuperSliverList.builder(
            itemCount: historyEntries.length,
            itemBuilder: (context, index) =>
                _PersistedLogRow(log: historyEntries[index]),
          ),
          if (liveEntries.isNotEmpty)
            SliverToBoxAdapter(
              child: _LiveSectionDivider(label: context.l10n.consoleLiveBelow),
            ),
          SuperSliverList.builder(
            itemCount: liveEntries.length,
            itemBuilder: (context, index) => _LogRow(
              entry: liveEntries[index],
              matcher: matcher,
              onCopy: () => _copyEntry(liveEntries[index]),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 4)),
        ],
      ),
    );
  }

  Future<void> _copyVisible(List<DesktopLogEntry> entries) async {
    final truncated = entries.length > _maxCopyEntries;
    final source = truncated
        ? entries.sublist(entries.length - _maxCopyEntries)
        : entries;
    await Clipboard.setData(
      ClipboardData(text: source.map(_formatEntry).join('\n')),
    );
    if (!mounted) return;
    Toast.showToast(
      context,
      truncated
          ? context.l10n.consoleCopiedTruncated(source.length, entries.length)
          : context.l10n.consoleCopied(source.length),
    );
  }

  Future<void> _exportVisible(List<DesktopLogEntry> entries) async {
    final text = entries.map(_formatEntry).join('\n');
    final sessionId = ref.read(desktopLogsProvider).state.sessionId;
    try {
      await FilePicker.platform.saveFile(
        dialogTitle: context.l10n.consoleExportDialogTitle,
        fileName: 'jsxposed-console-$sessionId.log',
        bytes: utf8.encode(text),
      );
    } catch (error) {
      if (!mounted) return;
      Toast.showToast(context, context.l10n.exportFailed('$error'));
    }
  }

  Future<void> _deleteHistory() async {
    final conversationId = ref
        .read(desktopLogsProvider)
        .state
        .sessionConversationId;
    if (conversationId == null || conversationId.isEmpty) {
      Toast.showToast(context, context.l10n.consoleDeleteHistoryUnavailable);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.consoleDeleteHistoryConfirmTitle),
        content: Text(context.l10n.consoleDeleteHistoryConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(desktopLogsProvider.notifier).deleteHistory();
    if (!mounted) return;
    Toast.showToast(context, context.l10n.consoleDeleteHistoryDone);
  }
}

/// 与手机端控制台一致的检索匹配器：支持普通串与正则，并负责命中高亮切分
class _SearchMatcher {
  _SearchMatcher({
    required String query,
    required this.regex,
    required this.caseSensitive,
  }) : needle = caseSensitive ? query : query.toLowerCase(),
       regexValid = _checkRegex(query, regex, caseSensitive),
       _pattern = regex && _checkRegex(query, regex, caseSensitive)
           ? RegExp(query, caseSensitive: caseSensitive)
           : null;

  final String needle;
  final bool regex;
  final bool caseSensitive;
  final bool regexValid;
  final RegExp? _pattern;

  bool get isActive =>
      regex ? regexValid && needle.isNotEmpty : needle.isNotEmpty;

  static bool _checkRegex(String query, bool regex, bool caseSensitive) {
    if (!regex || query.isEmpty) return true;
    try {
      RegExp(query, caseSensitive: caseSensitive);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool matches(String haystack) {
    if (!isActive) return true;
    if (_pattern != null) return _pattern.hasMatch(haystack);
    return (caseSensitive ? haystack : haystack.toLowerCase()).contains(needle);
  }

  /// 把 [text] 按命中位置切成 span，命中片段使用 [highlight]
  List<TextSpan> split(String text, TextStyle base, TextStyle highlight) {
    if (!isActive) return [TextSpan(text: text, style: base)];
    final ranges = <(int, int)>[];
    if (_pattern != null) {
      for (final match in _pattern.allMatches(text)) {
        ranges.add((match.start, match.end));
      }
    } else {
      final haystack = caseSensitive ? text : text.toLowerCase();
      var start = haystack.indexOf(needle);
      while (start != -1) {
        ranges.add((start, start + needle.length));
        start = haystack.indexOf(needle, start + needle.length);
      }
    }
    if (ranges.isEmpty) return [TextSpan(text: text, style: base)];

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final (start, end) in ranges) {
      if (start < cursor) continue;
      if (start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, start), style: base));
      }
      spans.add(TextSpan(text: text.substring(start, end), style: highlight));
      cursor = end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: base));
    }
    return spans;
  }
}

class _ConsoleToolbar extends StatelessWidget {
  const _ConsoleToolbar({
    required this.state,
    required this.filteredCount,
    required this.totalCount,
    required this.levelCounts,
    required this.regexEnabled,
    required this.caseSensitive,
    required this.regexValid,
    required this.showHistory,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleRegex,
    required this.onToggleCase,
    required this.onToggleAutoScroll,
    required this.onToggleHistory,
    required this.onTogglePause,
    required this.onCopyVisible,
    required this.onExportVisible,
    required this.onDeleteHistory,
    required this.onClear,
    required this.expanded,
    required this.onToggleExpanded,
  });

  static const _kLevels = ['E', 'W', 'I', 'D'];

  final DesktopConsoleState state;
  final int filteredCount;
  final int totalCount;
  final Map<String, int> levelCounts;
  final bool regexEnabled;
  final bool caseSensitive;
  final bool regexValid;
  final bool showHistory;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleRegex;
  final VoidCallback onToggleCase;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback onToggleHistory;
  final VoidCallback onTogglePause;
  final VoidCallback onCopyVisible;
  final VoidCallback onExportVisible;
  final VoidCallback onDeleteHistory;
  final VoidCallback onClear;
  final bool expanded;
  final VoidCallback onToggleExpanded;

  Color _statusColor(BuildContext context) {
    if (state.isPaused) return const Color(0xFFFFA726);
    if (state.isRunning || state.isStarting) return const Color(0xFF66BB6A);
    return context.colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final hasFilter = filteredCount != totalCount;
    return Container(
      height: 38,
      color: colors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            Icons.terminal_rounded,
            size: 13,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _statusColor(context),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.terminal,
            style: TextStyle(
              fontSize: 11,
              color: colors.onSurface,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          if (totalCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: hasFilter
                    ? colors.primary.withValues(alpha: 0.12)
                    : colors.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hasFilter ? '$filteredCount/$totalCount' : '$totalCount',
                style: TextStyle(
                  fontSize: 9.5,
                  fontFamily: 'monospace',
                  color: hasFilter ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ),
          for (final level in _kLevels)
            if ((levelCounts[level] ?? 0) > 0)
              _LevelCountBadge(level: level, count: levelCounts[level]!),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 26,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: colors.onSurface,
                ),
                cursorColor: colors.primary,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: context.l10n.terminalFilterHint,
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 14,
                    color: regexValid ? colors.onSurfaceVariant : colors.error,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 26,
                    minHeight: 26,
                  ),
                  suffixIcon: regexEnabled
                      ? Text(
                          '.*',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'monospace',
                            color: colors.primary,
                          ),
                        )
                      : (caseSensitive
                            ? Text(
                                'Aa',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                  color: colors.primary,
                                ),
                              )
                            : null),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 26,
                    minHeight: 26,
                  ),
                  filled: true,
                  fillColor: colors.onSurface.withValues(alpha: 0.06),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.8,
                      color: regexValid
                          ? colors.onSurface.withValues(alpha: 0.5)
                          : colors.error,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ),
          ),
          _ToolbarIconButton(
            icon: Icons.code_rounded,
            tooltip: context.l10n.consoleRegexSearch,
            active: regexEnabled,
            onTap: onToggleRegex,
          ),
          _ToolbarIconButton(
            icon: Icons.text_fields_rounded,
            tooltip: context.l10n.consoleCaseSensitive,
            active: caseSensitive,
            onTap: onToggleCase,
          ),
          _ToolbarIconButton(
            icon: state.autoScroll
                ? Icons.vertical_align_bottom_rounded
                : Icons.pause_circle_outline_rounded,
            tooltip: context.l10n.consoleHistory,
            active: state.autoScroll,
            onTap: onToggleAutoScroll,
          ),
          _ToolbarIconButton(
            icon: showHistory
                ? Icons.history_rounded
                : Icons.history_toggle_off_rounded,
            tooltip: context.l10n.consoleHistory,
            active: showHistory,
            onTap: onToggleHistory,
          ),
          _ToolbarIconButton(
            icon: state.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            tooltip: state.isPaused
                ? context.l10n.consoleResumeOutput
                : context.l10n.consolePauseOutput,
            active: state.isPaused,
            onTap: onTogglePause,
          ),
          PopupMenuButton<String>(
            tooltip: context.l10n.consoleActions,
            padding: EdgeInsets.zero,
            iconSize: 15,
            icon: Icon(Icons.more_vert, color: colors.onSurfaceVariant),
            constraints: const BoxConstraints(minWidth: 27, minHeight: 28),
            color: colors.surfaceContainerHigh,
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  onCopyVisible();
                case 'export':
                  onExportVisible();
                case 'deleteHistory':
                  onDeleteHistory();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'copy',
                child: _MenuRow(
                  icon: Icons.copy_all_outlined,
                  label: context.l10n.consoleCopyVisible,
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: _MenuRow(
                  icon: Icons.download_outlined,
                  label: context.l10n.consoleExportVisible,
                ),
              ),
              PopupMenuItem(
                value: 'deleteHistory',
                child: _MenuRow(
                  icon: Icons.delete_outline,
                  label: context.l10n.consoleDeleteHistory,
                ),
              ),
            ],
          ),
          _ToolbarIconButton(
            icon: Icons.delete_sweep_outlined,
            tooltip: context.l10n.consoleClearViewTooltip,
            onTap: onClear,
          ),
          _ToolbarIconButton(
            icon: expanded ? Icons.expand_more : Icons.expand_less,
            tooltip: expanded
                ? context.l10n.desktopOutputCollapse
                : context.l10n.desktopOutputExpand,
            onTap: onToggleExpanded,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: context.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: context.colorScheme.onSurface),
        ),
      ],
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 27,
          height: 28,
          child: Icon(
            icon,
            size: 15,
            color: active
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _LevelCountBadge extends StatelessWidget {
  const _LevelCountBadge({required this.level, required this.count});

  final String level;
  final int count;

  Color get _color => switch (level) {
    'E' => const Color(0xFFEF5350),
    'W' => const Color(0xFFFFA726),
    'D' => const Color(0xFF42A5F5),
    _ => const Color(0xFF90A4AE),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '$level$count',
          style: TextStyle(
            fontSize: 9,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            color: _color,
          ),
        ),
      ),
    );
  }
}

class _ConsoleFilterRow extends StatelessWidget {
  const _ConsoleFilterRow({
    required this.sourceFilter,
    required this.levelFilter,
    required this.onSourceChanged,
    required this.onLevelChanged,
  });

  static const _kSources = [
    'session',
    'frida',
    'xposed',
    'app',
    'framework',
    'system',
  ];
  static const _kLevels = ['D', 'I', 'W', 'E'];

  final String? sourceFilter;
  final String? levelFilter;
  final ValueChanged<String?> onSourceChanged;
  final ValueChanged<String?> onLevelChanged;

  String _sourceLabel(BuildContext context, String source) => switch (source) {
    'session' => context.l10n.consoleSourceSession,
    'frida' => context.l10n.consoleSourceFrida,
    'xposed' => context.l10n.consoleSourceXposed,
    'app' => context.l10n.consoleSourceApp,
    'framework' => context.l10n.consoleSourceCore,
    _ => context.l10n.consoleSourceSystem,
  };

  String _levelLabel(BuildContext context, String level) => level;

  Color _getLevelColor(String level) => switch (level) {
    'D' => Colors.blue,
    'I' => Colors.green,
    'W' => Colors.orange,
    'E' => Colors.red,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
          bottom: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          _TagChip(
            label: context.l10n.consoleAll,
            selected: sourceFilter == null && levelFilter == null,
            onTap: () {
              onSourceChanged(null);
              onLevelChanged(null);
            },
          ),
          for (final source in _kSources) ...[
            const SizedBox(width: 6),
            _TagChip(
              label: _sourceLabel(context, source),
              selected: sourceFilter == source,
              onTap: () =>
                  onSourceChanged(sourceFilter == source ? null : source),
            ),
          ],
          const SizedBox(width: 8),
          Container(width: 1, color: context.colorScheme.outlineVariant),
          const SizedBox(width: 8),
          for (final level in _kLevels) ...[
            _TagChip(
              label: _levelLabel(context, level),
              selected: levelFilter == level,
              onTap: () => onLevelChanged(levelFilter == level ? null : level),
              color: _getLevelColor(level),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? context.colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: selected
              ? chipColor.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? chipColor.withValues(alpha: 0.32)
                : (color != null
                      ? chipColor.withValues(alpha: 0.24)
                      : context.colorScheme.outlineVariant),
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color != null
                ? chipColor
                : (selected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant),
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ConsoleEmptyState extends StatelessWidget {
  const _ConsoleEmptyState({required this.isFiltered, required this.message});

  final bool isFiltered;
  final String message;

  @override
  Widget build(BuildContext context) {
    // 面板拖到最小高度时内容区有限，可滚动避免 RenderFlex 溢出
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFiltered ? Icons.filter_list_off : Icons.terminal_rounded,
              size: 28,
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsoleTabBar extends StatelessWidget {
  const _ConsoleTabBar({
    required this.terminalSelected,
    required this.onLogs,
    required this.onTerminal,
  });

  final bool terminalSelected;
  final VoidCallback onLogs;
  final VoidCallback onTerminal;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    Widget tab({
      required String label,
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? colors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? colors.primary : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(
          label: context.l10n.desktopConsoleLogs,
          icon: Icons.article_outlined,
          selected: !terminalSelected,
          onTap: onLogs,
        ),
        tab(
          label: context.l10n.desktopConsoleTerminal,
          icon: Icons.terminal,
          selected: terminalSelected,
          onTap: onTerminal,
        ),
      ],
    );
  }
}

/// 真正的终端视图：缓冲区、光标、滚动和按键都由 xterm 负责。
class _ShellTerminal extends StatelessWidget {
  const _ShellTerminal({required this.terminal, required this.focusNode});

  final Terminal terminal;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0C0C0C),
      // xterm 4.0 的点击聚焦走内部 IME 通道（requestKeyboard），在 Windows
      // 上会被手势仲裁/IME 吞掉，导致终端拿不到焦点。这里在原始指针层面
      // 强制 requestFocus，保证点击终端任意位置都能获得键盘焦点。
      child: Listener(
        onPointerDown: (_) => focusNode.requestFocus(),
        child: TerminalView(
          terminal,
          focusNode: focusNode,
          autofocus: true,
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          textStyle: const TerminalStyle(fontSize: 13, fontFamily: 'monospace'),
          theme: const TerminalTheme(
            cursor: Color(0xFFB8E986),
            selection: Color(0x5533A6FF),
            foreground: Color(0xFFD6D6D6),
            background: Color(0xFF0C0C0C),
            black: Color(0xFF1A1A1A),
            red: Color(0xFFEF9A9A),
            green: Color(0xFFB8E986),
            yellow: Color(0xFFFFD54F),
            blue: Color(0xFF82B1FF),
            magenta: Color(0xFFCE93D8),
            cyan: Color(0xFF80DEEA),
            white: Color(0xFFD6D6D6),
            brightBlack: Color(0xFF6B6B6B),
            brightRed: Color(0xFFEF9A9A),
            brightGreen: Color(0xFFB8E986),
            brightYellow: Color(0xFFFFD54F),
            brightBlue: Color(0xFF82B1FF),
            brightMagenta: Color(0xFFCE93D8),
            brightCyan: Color(0xFF80DEEA),
            brightWhite: Color(0xFFFFFFFF),
            searchHitBackground: Color(0xFFFFD54F),
            searchHitBackgroundCurrent: Color(0xFFFFB300),
            searchHitForeground: Color(0xFF111111),
          ),
        ),
      ),
    );
  }
}

class _LogRow extends StatefulWidget {
  const _LogRow({
    required this.entry,
    required this.matcher,
    required this.onCopy,
  });

  final DesktopLogEntry entry;
  final _SearchMatcher matcher;
  final VoidCallback onCopy;

  @override
  State<_LogRow> createState() => _LogRowState();
}

class _LogRowState extends State<_LogRow> {
  bool _stackExpanded = false;

  DesktopLogEntry get entry => widget.entry;

  Color get _levelColor => switch (entry.level) {
    'E' || 'F' => const Color(0xFFEF5350),
    'W' => const Color(0xFFFFA726),
    'D' => const Color(0xFF42A5F5),
    _ => const Color(0xFFB0BEC5),
  };

  Color get _sourceColor => switch (entry.source) {
    'frida' => const Color(0xFFFFB74D),
    'xposed' => const Color(0xFF81C784),
    'app' => const Color(0xFF64B5F6),
    'framework' => const Color(0xFFBA68C8),
    _ => const Color(0xFF90A4AE),
  };

  Color get _rowBgColor => _levelColor.withValues(alpha: 0.08);

  TextStyle _messageStyle(BuildContext context) => TextStyle(
    fontFamily: 'monospace',
    fontSize: 11.5,
    color: entry.level == 'E' || entry.level == 'F'
        ? const Color(0xFFEF9A9A)
        : entry.level == 'W'
        ? const Color(0xFFFFCC80)
        : context.colorScheme.onSurface,
    height: 1.35,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final messageStyle = _messageStyle(context);

    String timeDisplay = '';
    if (entry.timestamp.isNotEmpty) {
      try {
        final dt = DateTime.parse(entry.timestamp);
        timeDisplay =
            '${dt.month.toString().padLeft(2, '0')}-'
            '${dt.day.toString().padLeft(2, '0')} '
            '${dt.hour.toString().padLeft(2, '0')}:'
            '${dt.minute.toString().padLeft(2, '0')}:'
            '${dt.second.toString().padLeft(2, '0')}';
      } catch (_) {
        timeDisplay = entry.timestamp.length > 6
            ? entry.timestamp.substring(6)
            : '';
      }
    }

    final hasStructured = entry.tag.isNotEmpty || entry.source.isNotEmpty;
    final messageText = hasStructured ? entry.message : entry.rawLine;
    final meta = [
      entry.source.toUpperCase(),
      if (entry.scriptName.isNotEmpty) entry.scriptName,
      if (entry.tag.isNotEmpty) entry.tag,
    ].join('  ·  ');
    final highlightStyle = messageStyle.copyWith(
      color: const Color(0xFF111111),
      backgroundColor: const Color(0xFFFFD54F),
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: _rowBgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionContainer.disabled(
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _levelColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                entry.level,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: _levelColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meta,
                        style: TextStyle(
                          fontSize: 10,
                          color: _sourceColor.withValues(alpha: 0.85),
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (timeDisplay.isNotEmpty)
                      Text(
                        timeDisplay,
                        style: TextStyle(
                          fontSize: 9,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                          fontFamily: 'monospace',
                        ),
                      ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    children: widget.matcher.split(
                      messageText,
                      messageStyle,
                      highlightStyle,
                    ),
                  ),
                ),
                if (entry.stackTrace.isNotEmpty)
                  GestureDetector(
                    onTap: () =>
                        setState(() => _stackExpanded = !_stackExpanded),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.stackTrace,
                          maxLines: _stackExpanded ? null : 5,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: Color(0xFFEF9A9A),
                            height: 1.3,
                          ),
                        ),
                        SelectionContainer.disabled(
                          child: Text(
                            _stackExpanded
                                ? context.l10n.consoleCollapseStack
                                : context.l10n.consoleExpandStack,
                            style: TextStyle(
                              fontSize: 9,
                              color: colors.primary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SelectionContainer.disabled(
            child: IconButton(
              tooltip: context.l10n.consoleLogCopied,
              iconSize: 14,
              visualDensity: VisualDensity.compact,
              onPressed: widget.onCopy,
              icon: Icon(
                Icons.copy_rounded,
                color: colors.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersistedLogRow extends StatelessWidget {
  const _PersistedLogRow({required this.log});

  final DesktopHistoryLog log;

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer()
      ..write('[${log.timestamp.toLocal()}] ')
      ..write('[${log.source}/${log.level}] ');
    if (log.scriptName.isNotEmpty) buffer.write('${log.scriptName} ');
    if (log.runId.isNotEmpty) buffer.write('(run ${log.runId}): ');
    buffer.write(log.message);
    if (log.stackTrace.isNotEmpty) buffer.write('\n${log.stackTrace}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(
        buffer.toString(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: context.colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
      ),
    );
  }
}

class _LiveSectionDivider extends StatelessWidget {
  const _LiveSectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: context.colorScheme.outlineVariant,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                color: context.colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: context.colorScheme.outlineVariant,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryLoadOlderButton extends StatelessWidget {
  const _HistoryLoadOlderButton({
    required this.loading,
    required this.hasMore,
    required this.error,
    required this.onTap,
  });

  final bool loading;
  final bool hasMore;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: hasMore ? onTap : null,
                child: Text(
                  error == null ? context.l10n.consoleLoadOlder : '$error',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
      ),
    );
  }
}

String _formatEntry(DesktopLogEntry entry) {
  final buffer = StringBuffer();
  if (entry.timestamp.isNotEmpty) buffer.write('${entry.timestamp} ');
  buffer.write('${entry.level} [${entry.source.toUpperCase()}]');
  if (entry.scriptName.isNotEmpty) buffer.write('[${entry.scriptName}]');
  if (entry.pid.isNotEmpty) buffer.write('[pid:${entry.pid}]');
  buffer.write(' ${entry.displayText}');
  if (entry.stackTrace.isNotEmpty) buffer.write('\n${entry.stackTrace}');
  return buffer.toString();
}

/// 侧边栏导航项数据
class _DesktopNavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _DesktopNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class _DesktopStatusBar extends ConsumerWidget {
  const _DesktopStatusBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(desktopConnectionProvider);
    final colors = context.colorScheme;
    final connected = connection.isConnected;
    return Container(
      height: 22,
      color: connected ? colors.primary : colors.surfaceContainerHighest,
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            InkWell(
              onTap: () => _showConnectionManager(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      connected ? Icons.device_hub : Icons.phonelink_off,
                      size: 13,
                      color: connected
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      connection.deviceInfo?.model ??
                          (connection.isConnecting
                              ? context.l10n.desktopStatusConnecting
                              : context.l10n.desktopStatusNoDevice),
                      style: TextStyle(
                        fontSize: 11,
                        color: connected
                            ? colors.onPrimary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                    // 未连接时提供快捷刷新并自动连接
                    if (!connected) ...[
                      const SizedBox(width: 4),
                      _ConnectionToolButton(
                        tooltip: context.l10n.desktopStatusQuickConnect,
                        icon: connection.isConnecting
                            ? Icons.sync
                            : Icons.refresh,
                        size: 13,
                        color: colors.onSurfaceVariant,
                        onPressed: connection.isConnecting
                            ? null
                            : () => ref
                                  .read(desktopConnectionProvider.notifier)
                                  .quickConnectAdb(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (connected && constraints.maxWidth >= 420)
              InkWell(
                onTap: () => _showDeviceDetails(context, connection),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    context.l10n.desktopStatusDeviceInfo(
                      '${connection.deviceInfo?.androidApi ?? '-'}',
                      connection.deviceInfo?.abi ?? '-',
                    ),
                    style: TextStyle(fontSize: 11, color: colors.onPrimary),
                  ),
                ),
              ),
            const Spacer(),
            if (constraints.maxWidth >= 560)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Jsxposed Protocol 1.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: connected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showConnectionManager(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.desktopNavDeviceConnection),
      content: const SizedBox(
        width: 380,
        child: SingleChildScrollView(child: _ConnectionPanel()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

Future<void> _showAdbSettingsDialog(
  BuildContext context,
  DesktopConnectionNotifier notifier,
) async {
  final pairAddressController = TextEditingController();
  final pairCodeController = TextEditingController();
  final connectAddressController = TextEditingController();
  final l10n = context.l10n;

  await showDialog<void>(
    context: context,
    builder: (context) {
      var isRunning = false;
      String? commandOutput;
      var commandSucceeded = false;

      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.desktopConnectionAdbSettings),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.desktopConnectionPairSection,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pairAddressController,
                    enabled: !isRunning,
                    decoration: InputDecoration(
                      labelText: l10n.desktopConnectionPairAddressHint,
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pairCodeController,
                          enabled: !isRunning,
                          decoration: InputDecoration(
                            labelText: l10n.desktopConnectionPairCodeHint,
                            prefixIcon: const Icon(Icons.password),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: isRunning
                            ? null
                            : () async {
                                if (pairAddressController.text.trim().isEmpty ||
                                    pairCodeController.text.trim().isEmpty) {
                                  return;
                                }
                                setDialogState(() {
                                  isRunning = true;
                                  commandOutput = null;
                                  commandSucceeded = false;
                                });
                                final result = await notifier.pairAdb(
                                  pairAddressController.text,
                                  pairCodeController.text,
                                );
                                if (!context.mounted) return;
                                setDialogState(() {
                                  isRunning = false;
                                  commandSucceeded = result.isSuccess;
                                  commandOutput = result.isSuccess
                                      ? '${result.details}\n\n${l10n.desktopConnectionPairNextStep}'
                                      : result.details;
                                });
                              },
                        child: Text(l10n.desktopConnectionPair),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.desktopConnectionWirelessSection,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: connectAddressController,
                          enabled: !isRunning,
                          decoration: InputDecoration(
                            labelText: l10n.desktopConnectionAdbAddressHint,
                            prefixIcon: const Icon(Icons.wifi),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: isRunning
                            ? null
                            : () async {
                                if (connectAddressController.text
                                    .trim()
                                    .isEmpty) {
                                  return;
                                }
                                setDialogState(() {
                                  isRunning = true;
                                  commandOutput = null;
                                  commandSucceeded = false;
                                });
                                final result = await notifier
                                    .connectAdbWireless(
                                      connectAddressController.text,
                                    );
                                if (!context.mounted) return;
                                if (result.isSuccess) {
                                  Navigator.pop(context);
                                  await notifier.connectAdb();
                                  return;
                                }
                                setDialogState(() {
                                  isRunning = false;
                                  commandOutput = result.details;
                                });
                              },
                        child: Text(l10n.desktopConnectionAdbConnect),
                      ),
                    ],
                  ),
                  if (isRunning) ...[
                    const SizedBox(height: 16),
                    const LinearProgressIndicator(),
                  ],
                  if (commandOutput != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 220),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: commandSucceeded
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          commandOutput!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isRunning ? null : () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
        ),
      );
    },
  );

  pairAddressController.dispose();
  pairCodeController.dispose();
  connectAddressController.dispose();
}

class _ConnectionToolButton extends StatelessWidget {
  const _ConnectionToolButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 32,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: Icon(icon, size: size * 0.53, color: color),
      ),
    );
  }
}

class _AdbDeviceTile extends StatelessWidget {
  const _AdbDeviceTile({
    required this.device,
    required this.selected,
    required this.busy,
    required this.onTap,
  });

  final DesktopAdbDevice device;
  final bool selected;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final authorized = device.isAuthorized;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected ? colors.primaryContainer : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: busy ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(
                  authorized ? Icons.phone_android : Icons.phonelink_lock,
                  size: 17,
                  color: authorized ? colors.primary : colors.outline,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authorized
                            ? device.serial
                            : context.l10n.desktopConnectionDeviceUnauthorized,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: authorized
                              ? colors.onSurfaceVariant
                              : colors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, size: 17, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionStatusRow extends StatelessWidget {
  const _ConnectionStatusRow({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectionPanel extends HookConsumerWidget {
  const _ConnectionPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(desktopConnectionProvider);
    final notifier = ref.read(desktopConnectionProvider.notifier);
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final selectedDevice = connection.adbDevices
        .where((device) => device.serial == connection.selectedAdbSerial)
        .firstOrNull;

    final statusColor = switch (connection.status) {
      DesktopConnectionStatus.connected => const Color(0xFF4CAF50),
      DesktopConnectionStatus.connecting => const Color(0xFFFFA726),
      DesktopConnectionStatus.disconnected => colorScheme.outline,
    };

    final statusText = switch (connection.status) {
      DesktopConnectionStatus.connected => l10n.desktopConnectionConnected,
      DesktopConnectionStatus.connecting => l10n.desktopConnectionConnecting,
      DesktopConnectionStatus.disconnected =>
        l10n.desktopConnectionDisconnected,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.devices_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.desktopNavDeviceConnection,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.desktopDeviceListTitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              _ConnectionToolButton(
                tooltip: l10n.desktopConnectionRefresh,
                icon: Icons.refresh,
                onPressed: connection.isConnecting
                    ? null
                    : notifier.scanAdbDevices,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (connection.adbDevices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.desktopDeviceListEmpty,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Column(
              children: connection.adbDevices
                  .map(
                    (device) => _AdbDeviceTile(
                      device: device,
                      selected: device.serial == connection.selectedAdbSerial,
                      busy: connection.isConnecting,
                      onTap: () => notifier.switchAdbDevice(device.serial),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: connection.isConnecting
                ? null
                : () => _showAdbSettingsDialog(context, notifier),
            icon: const Icon(Icons.settings_ethernet, size: 17),
            label: Text(l10n.desktopConnectionConfigureAdb),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: _ConnectionStatusRow(
              color: statusColor,
              text: connection.isConnected && selectedDevice != null
                  ? l10n.desktopConnectionAdbActive(selectedDevice.displayName)
                  : statusText,
            ),
          ),
          if (selectedDevice != null && !selectedDevice.isAuthorized) ...[
            const SizedBox(height: 8),
            Text(
              l10n.desktopConnectionDeviceUnauthorized,
              style: TextStyle(fontSize: 11, color: colorScheme.error),
            ),
          ],
          if (connection.error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: SelectableText(
                      connection.error!,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  _ConnectionToolButton(
                    tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                    icon: Icons.close,
                    color: colorScheme.onErrorContainer,
                    onPressed: notifier.clearError,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          if (connection.isConnected) ...[
            Text(
              connection.address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 7),
          ],
          SizedBox(
            height: 38,
            child: connection.isConnected
                ? OutlinedButton.icon(
                    onPressed: notifier.disconnect,
                    icon: const Icon(Icons.link_off, size: 17),
                    label: Text(l10n.desktopConnectionDisconnect),
                  )
                : FilledButton.icon(
                    onPressed:
                        connection.isConnecting ||
                            selectedDevice?.isAuthorized != true
                        ? null
                        : notifier.connectAdb,
                    icon: connection.isConnecting
                        ? const SizedBox.square(
                            dimension: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.phone_android, size: 17),
                    label: Text(
                      connection.isConnecting
                          ? l10n.desktopConnectionConnecting
                          : l10n.desktopConnectionConnectAdb,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
