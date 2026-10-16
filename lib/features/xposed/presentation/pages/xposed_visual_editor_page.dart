import 'dart:convert';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_code_editor/app_code_editor.dart';
import 'package:JsxposedX/common/widgets/app_code_editor/widgets/code_find_panel_view.dart';
import 'package:JsxposedX/common/widgets/run_app_button.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/block_code_generator.dart';
import 'package:JsxposedX/core/utils/js_formatter.dart';
import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:JsxposedX/features/xposed/presentation/constants/jsxposed_prompts.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_action_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_query_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/logcat_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/editor_tab_button.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/logcat_panel_view.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/visual_hook_editor_tab.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';

class XposedVisualEditorPage extends HookConsumerWidget {
  final String path;
  final String packageName;

  const XposedVisualEditorPage({
    super.key,
    required this.path,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final l10n = context.l10n;

    // State
    final blocks = useState<List<BlockNode>>([]);
    final codeController = useMemoized(
      () => CodeLineEditingController.fromText(''),
    );
    useEffect(() => codeController.dispose, []);

    final findController = useMemoized(
      () => CodeFindController(codeController),
    );
    useEffect(() => findController.dispose, []);

    final tabController = useTabController(initialLength: 2);
    final showLogcat = useState(false);
    final isLogcatFullscreen = useState(false);
    final scriptName = useMemoized(
      () => PathUtils.getName(path: path, isXposedScript: true),
    );
    final scriptFileName = useMemoized(() => path.split('/').last);
    final initialized = useState(false);
    final promptsBuilder = useMemoized(() => buildJsxposedPromptsBuilder());

    // Rebuild when findController.value changes (to show/hide panel)
    useListenable(findController);

    // Load script content
    ref.listen(
      readJsScriptProvider(packageName: packageName, localPath: path),
      (previous, next) {
        next.whenData((content) {
          if (!initialized.value && content.isNotEmpty) {
            initialized.value = true;
            codeController.text = content;
            blocks.value = BlockCodeGenerator.parseTree(content);
          }
        });
      },
    );

    // Sync: visual → code when switching to code tab
    useEffect(() {
      void listener() {
        if (tabController.index == 1) {
          _syncVisualToCode(blocks.value, codeController);
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    final tabButtons = _buildTabButtons(
      context,
      ref,
      codeController,
      findController,
      showLogcat,
      isLogcatFullscreen,
      scriptName,
    );

    return Scaffold(
      appBar: _buildAppBar(
        context,
        ref,
        scriptName,
        scriptFileName,
        codeController,
        blocks,
        showLogcat,
      ),
      body: Column(
        children: [
          // Tool tab bar (same as XposedEditorPage)
          CodeEditorTapRegion(
            child: Container(
              height: 50.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: tabButtons.map((btn) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: EditorTabButton(
                        icon: btn.icon,
                        label: btn.name,
                        onTap: () => btn.onClick(),
                        color: btn.color,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Divider(
            height: 1.h,
            thickness: 0.5,
            color: context.theme.dividerColor.withValues(alpha: 0.1),
          ),
          // Visual / Code tab bar
          TabBar(
            controller: tabController,
            tabs: [
              Tab(text: l10n.visualEditorTab),
              Tab(text: l10n.codeEditorTab),
            ],
          ),
          // Content
          Expanded(
            child: Column(
              children: [
                if (!isLogcatFullscreen.value)
                  Expanded(
                    flex: showLogcat.value ? 2 : 1,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _buildVisualTab(blocks),
                        _buildCodeTab(
                          codeController,
                          findController,
                          promptsBuilder,
                        ),
                      ],
                    ),
                  ),
                if (showLogcat.value)
                  Expanded(
                    flex: 1,
                    child: LogcatPanelView(
                      isFullscreen: isLogcatFullscreen.value,
                      onToggleFullscreen: () =>
                          isLogcatFullscreen.value = !isLogcatFullscreen.value,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    String scriptName,
    String scriptFileName,
    CodeLineEditingController codeController,
    ValueNotifier<List<BlockNode>> blocks,
    ValueNotifier<bool> showLogcat,
  ) {
    return AppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scriptName),
          Text(
            scriptFileName,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.save_outlined),
          tooltip: context.l10n.saveScript,
          onPressed: () async {
            _syncVisualToCode(blocks.value, codeController);
            await ref.read(
              createJsScriptProvider(
                packageName: packageName,
                content: codeController.text,
                localPath: path,
              ).future,
            );
            ToastMessage.show(context.l10n.scriptSaved);
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_download_outlined),
          tooltip: context.l10n.exportScript,
          onPressed: () async {
            _syncVisualToCode(blocks.value, codeController);
            await FilePicker.platform.saveFile(
              dialogTitle: context.l10n.exportScript,
              fileName: scriptFileName,
              bytes: utf8.encode(codeController.text),
            );
            ToastMessage.show(context.l10n.scriptExported);
          },
        ),
        RunAppButton(
          packageName: packageName,
          onClick: () async {
            _syncVisualToCode(blocks.value, codeController);
            await ref.read(
              createJsScriptProvider(
                packageName: packageName,
                content: codeController.text,
                localPath: path,
              ).future,
            );
            // showLogcat.value = true;
            final console = ref.read(logcatProvider.notifier);
            console.configureSession('xposed', scriptName);
            await console.start(packageName);
          },
        ),
      ],
    );
  }

  Widget _buildVisualTab(ValueNotifier<List<BlockNode>> blocks) {
    return VisualHookEditorTab(
      blocks: blocks.value,
      onBlocksChanged: (updated) => blocks.value = updated,
    );
  }

  Widget _buildCodeTab(
    CodeLineEditingController codeController,
    CodeFindController findController,
    CodeAutocompletePromptsBuilder promptsBuilder,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: AppCodeEditor(
        controller: codeController,
        findController: findController,
        promptsBuilder: promptsBuilder,
        findBuilder: (context, controller, readOnly) =>
            CodeFindPanelView(controller: controller, readOnly: readOnly),
      ),
    );
  }

  void _syncVisualToCode(
    List<BlockNode> blocks,
    CodeLineEditingController codeController,
  ) {
    final code = BlockCodeGenerator.generateJs(blocks);
    if (code != codeController.text) {
      codeController.text = code;
    }
  }

  List<_TabButtonData> _buildTabButtons(
    BuildContext context,
    WidgetRef ref,
    CodeLineEditingController codeController,
    CodeFindController findController,
    ValueNotifier<bool> showLogcat,
    ValueNotifier<bool> isLogcatFullscreen,
    String scriptName,
  ) {
    final l10n = context.l10n;
    return [
      _TabButtonData(
        name: l10n.formatCode,
        icon: Icons.format_align_left_rounded,
        color: Colors.orange,
        onClick: () {
          final text = codeController.text;
          final formatted = JsFormatter.format(text);
          if (formatted != text) {
            codeController.text = formatted;
          }
        },
      ),
      _TabButtonData(
        name: l10n.search,
        icon: Icons.search_rounded,
        color: Colors.purple,
        onClick: () {
          findController.findInputController.clear();
          findController.replaceInputController.clear();
          if (findController.value == null) {
            findController.value = const CodeFindValue(
              option: CodeFindOption(
                caseSensitive: false,
                regex: false,
                pattern: '',
              ),
              replaceMode: false,
            );
          } else {
            findController.value = null;
          }
        },
      ),
      _TabButtonData(
        name: l10n.terminal,
        icon: Icons.terminal_rounded,
        color: showLogcat.value ? Colors.green : Colors.grey,
        onClick: () {
          showLogcat.value = !showLogcat.value;
          if (showLogcat.value) {
            final console = ref.read(logcatProvider.notifier);
            console.configureSession('xposed', scriptName);
            console.start(packageName);
          } else {
            ref.read(logcatProvider.notifier).stop();
            isLogcatFullscreen.value = false;
          }
        },
      ),
      _TabButtonData(
        name: l10n.apiManual,
        icon: Icons.menu_book_rounded,
        color: Colors.cyan,
        onClick: () {
          context.push(HomeRoute.apiManual);
        },
      ),
    ];
  }
}

class _TabButtonData {
  final String name;
  final IconData icon;
  final VoidCallback onClick;
  final Color? color;

  const _TabButtonData({
    required this.name,
    required this.icon,
    required this.onClick,
    this.color,
  });
}
