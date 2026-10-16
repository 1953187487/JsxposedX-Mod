import 'dart:convert';
import 'dart:typed_data';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/file_picker_util.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/frida/presentation/providers/frida_action_provider.dart';
import 'package:JsxposedX/features/frida/presentation/providers/frida_query_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_action_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_query_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/widgets/script_type_button.dart';

class CodeSaveAction extends ConsumerWidget {
  final String code;
  final String? packageName;
  final String language;
  final String? scriptType;
  final String? suggestedFileName;

  const CodeSaveAction({
    super.key,
    required this.code,
    required this.packageName,
    required this.language,
    this.scriptType,
    this.suggestedFileName,
  });

  bool get _isJavaScriptFile {
    final normalized = language.trim().toLowerCase();
    return normalized == 'javascript' || normalized == 'js';
  }

  String _resolveExportExtension() {
    final normalized = language.trim().toLowerCase();
    switch (normalized) {
      case 'javascript':
      case 'js':
        return 'js';
      case 'typescript':
      case 'ts':
        return 'ts';
      case 'dart':
        return 'dart';
      case 'java':
        return 'java';
      case 'kotlin':
      case 'kt':
        return 'kt';
      case 'xml':
        return 'xml';
      case 'json':
        return 'json';
      case 'yaml':
      case 'yml':
        return 'yaml';
      case 'smali':
        return 'smali';
      case 'html':
        return 'html';
      case 'css':
        return 'css';
      case 'shell':
      case 'bash':
      case 'sh':
        return 'sh';
      case 'python':
      case 'py':
        return 'py';
      case 'markdown':
      case 'md':
        return 'md';
      case 'sql':
        return 'sql';
      case 'c':
        return 'c';
      case 'cpp':
      case 'c++':
        return 'cpp';
      case 'csharp':
      case 'c#':
      case 'cs':
        return 'cs';
      case 'plaintext':
      case 'text':
      case '':
        return 'txt';
      default:
        final sanitized = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '');
        return sanitized.isEmpty ? 'txt' : sanitized;
    }
  }

  String _buildExportFileName() {
    final ext = _resolveExportExtension();
    return 'ai_export_${DateTime.now().millisecondsSinceEpoch}.$ext';
  }

  String _normalizeScriptFileName(String rawName) {
    final withExtension = rawName.endsWith('.js') ? rawName : '$rawName.js';
    return withExtension;
  }

  String _normalizeXposedTraditionFileName(String rawName) {
    final fileName = _normalizeScriptFileName(rawName);
    if (fileName.startsWith('[tradition]')) {
      return fileName;
    }
    return '[tradition]$fileName';
  }

  Future<void> _exportCode(BuildContext context) async {
    // 悬浮窗为独立引擎，FilePicker.platform.saveFile 依赖宿主 Activity；
    // 检测到无路由环境时改走原生 SAF 保存代理。
    if (GoRouter.maybeOf(context) == null) {
      await _exportCodeViaOverlayProxy(context);
      return;
    }
    await FilePicker.platform.saveFile(
      dialogTitle: context.l10n.exportScript,
      fileName: _buildExportFileName(),
      bytes: utf8.encode(code),
    );
    if (context.mounted) {
      ToastMessage.show(context.l10n.scriptExported);
    }
  }

  Future<void> _exportCodeViaOverlayProxy(BuildContext context) async {
    final fileName = _buildExportFileName();
    try {
      final savedPath = await FilePickerUtil.saveFileWithOverlayProxy(
        fileName: fileName,
        bytes: Uint8List.fromList(utf8.encode(code)),
      );
      if (!context.mounted) {
        return;
      }
      ToastMessage.show(context.l10n.scriptExported);
      if (savedPath != null && savedPath.isNotEmpty) {
        await FlutterOverlayWindow.setClipboardData(savedPath);
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ToastMessage.show(context.l10n.aiScriptSaveFailed(e.toString()));
    }
  }

  Future<void> _showSaveDialog(BuildContext context, WidgetRef ref) async {
    final pkg = packageName;
    if (pkg == null || pkg.isEmpty) {
      ToastMessage.show(context.l10n.apkNoAiSession);
      return;
    }

    // 使用 AI 建议的文件名或生成默认文件名
    final defaultFileName = suggestedFileName?.isNotEmpty == true
        ? suggestedFileName!
        : 'ai_hook_${DateTime.now().millisecondsSinceEpoch}.js';

    Future<void> submit(String rawName, String scriptType) async {
      final fileName = scriptType == 'xposed'
          ? _normalizeXposedTraditionFileName(rawName)
          : _normalizeScriptFileName(rawName);
      try {
        if (scriptType == 'frida') {
          await ref.read(
            createFridaScriptProvider(
              packageName: pkg,
              localPath: fileName,
              content: code,
            ).future,
          );
          ref.invalidate(fridaScriptsProvider(packageName: pkg));
        } else {
          if (fileName == 'hook.js' || fileName == "hook") {
            ToastMessage.show(context.l10n.reservedScriptFileName);
            return;
          }
          await ref.read(
            createJsScriptProvider(
              packageName: pkg,
              localPath: fileName,
              content: code,
            ).future,
          );
          ref.invalidate(jsScriptsProvider(packageName: pkg));
        }
        if (context.mounted) {
          ToastMessage.show(
            context.l10n.aiScriptSavedTo(
              scriptType == 'frida'
                  ? context.l10n.fridaProject
                  : context.l10n.xposedProject,
              fileName,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ToastMessage.show(context.l10n.aiScriptSaveFailed(e.toString()));
        }
      }
    }

    // 悬浮窗为独立引擎，SmartDialog 未初始化，改用 OverlayPanelDialog 承载。
    if (GoRouter.maybeOf(context) == null) {
      await Navigator.of(context).push<void>(
        PageRouteBuilder<void>(
          opaque: false,
          barrierColor: Colors.transparent,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (routeContext, _, _) => OverlayPanelDialog.scaledCard(
            onClose: () => Navigator.of(routeContext).maybePop(),
            maxWidthPortrait: 380.0,
            maxWidthLandscape: 440.0,
            maxHeightPortrait: 520.0,
            maxHeightLandscape: 380.0,
            portraitBaseSize: const Size(340.0, 480.0),
            landscapeBaseSize: const Size(380.0, 360.0),
            cardBorderRadius: 18.0,
            childBuilder: (cardContext, viewport, scaledLayout) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0 * scaledLayout.scale),
                child: _SaveScriptDialogContent(
                  initialFileName: defaultFileName,
                  initialScriptType: scriptType,
                  onCancel: () => Navigator.of(cardContext).maybePop(),
                  onSubmit: submit,
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    await CustomDialog.show(
      title: Text(context.l10n.saveScript, style: TextStyle(fontSize: 16.sp)),
      child: _SaveScriptDialogContent(
        initialFileName: defaultFileName,
        initialScriptType: scriptType,
        onCancel: () => SmartDialog.dismiss(),
        onSubmit: submit,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = AiChatCompactScope.scaleOf(context);
    final isDark = context.isDark;
    final tooltip = _isJavaScriptFile
        ? context.l10n.saveScript
        : context.l10n.exportScript;
    final icon = _isJavaScriptFile
        ? Icons.save_outlined
        : Icons.file_download_outlined;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () async {
          if (_isJavaScriptFile) {
            await _showSaveDialog(context, ref);
            return;
          }
          await _exportCode(context);
        },
        borderRadius: BorderRadius.circular(4 * scale),
        child: Container(
          padding: EdgeInsets.all(4 * scale),
          child: Icon(
            icon,
            size: 16 * scale,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ),
    );
  }
}

/// 保存脚本对话框的内容，宿主与悬浮窗共用。
class _SaveScriptDialogContent extends StatefulWidget {
  const _SaveScriptDialogContent({
    required this.initialFileName,
    required this.initialScriptType,
    required this.onCancel,
    required this.onSubmit,
  });

  final String initialFileName;
  final String? initialScriptType;
  final VoidCallback onCancel;
  final Future<void> Function(String fileName, String scriptType) onSubmit;

  @override
  State<_SaveScriptDialogContent> createState() =>
      _SaveScriptDialogContentState();
}

class _SaveScriptDialogContentState extends State<_SaveScriptDialogContent> {
  late final TextEditingController _nameController;
  String? _selectedScriptType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFileName);
    _selectedScriptType = widget.initialScriptType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final scriptType = _selectedScriptType;
    final name = _nameController.text.trim();
    if (scriptType == null || name.isEmpty) {
      return;
    }
    widget.onCancel();
    await widget.onSubmit(name, scriptType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: context.l10n.projectName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
          ),
          style: TextStyle(fontSize: 13.sp, fontFamily: 'monospace'),
        ),
        SizedBox(height: 14.h),
        Text(context.l10n.selectScriptType, style: TextStyle(fontSize: 13.sp)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ScriptTypeButton(
                label: 'Frida',
                icon: Icons.bolt,
                color: const Color(0xFFFF6D00),
                selected: _selectedScriptType == 'frida',
                onTap: () => setState(() => _selectedScriptType = 'frida'),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ScriptTypeButton(
                label: 'Xposed',
                icon: Icons.extension,
                color: const Color(0xFF7C4DFF),
                selected: _selectedScriptType == 'xposed',
                onTap: () => setState(() => _selectedScriptType = 'xposed'),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: widget.onCancel,
              child: Text(context.l10n.cancel),
            ),
            SizedBox(width: 8.w),
            FilledButton(
              onPressed: _selectedScriptType == null ? null : _handleSubmit,
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ],
    );
  }
}
