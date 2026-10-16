import 'dart:io';

import 'package:JsxposedX/features/ai/data/prompts/system_prompts.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_context.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 已导出到设备本地的 API 手册路径（供 shell_exec 检索）
class AiManualBundle {
  const AiManualBundle({
    required this.xposedManualPath,
    required this.fridaManualPath,
  });

  final String xposedManualPath;
  final String fridaManualPath;
}

class ApkReversePromptBuilder {
  ApkReversePromptBuilder({bool isZh = true})
    : _isZh = isZh,
      _withTools = false;

  bool _isZh;
  AiApkContext? _apkContext;
  AiManualBundle? _manualBundle;
  bool _withTools;

  ApkReversePromptBuilder lang(bool isZh) {
    _isZh = isZh;
    return this;
  }

  ApkReversePromptBuilder withApkContext(AiApkContext context) {
    _apkContext = context;
    return this;
  }

  /// 注入本地手册检索指引：脚本生成前由模型通过 shell_exec 按需查阅，
  /// 避免把整份 API 手册拼接进每轮系统提示词。
  ApkReversePromptBuilder withManualBundle(AiManualBundle bundle) {
    _manualBundle = bundle;
    return this;
  }

  ApkReversePromptBuilder withTools() {
    _withTools = true;
    return this;
  }

  String buildSystemPrompt() {
    final buffer = StringBuffer();
    buffer.writeln(
      _isZh ? SystemPrompts.reverseRoleZh : SystemPrompts.reverseRoleEn,
    );

    if (_apkContext != null) {
      buffer
        ..writeln()
        ..writeln(_apkContext!.toPromptText(isZh: _isZh));
    }

    if (_withTools) {
      buffer.writeln(
        _isZh ? SystemPrompts.toolGuideZh : SystemPrompts.toolGuideEn,
      );
    }

    if (_manualBundle != null) {
      final guide =
          (_isZh ? SystemPrompts.manualGuideZh : SystemPrompts.manualGuideEn)
              .replaceAll('{xposedPath}', _manualBundle!.xposedManualPath)
              .replaceAll('{fridaPath}', _manualBundle!.fridaManualPath);
      buffer.writeln(guide);
    }

    buffer.writeln(
      _isZh ? SystemPrompts.scriptRulesZh : SystemPrompts.scriptRulesEn,
    );

    buffer.writeln(
      _isZh ? SystemPrompts.outputGuideZh : SystemPrompts.outputGuideEn,
    );
    return buffer.toString();
  }

  /// 按语言导出对应版本的 API 手册到设备本地（英文界面导英文手册，
  /// 避免模型在英文会话中检索中文手册）。
  static Future<AiManualBundle> exportManualBundle({bool isZh = true}) async {
    final directory = await getApplicationSupportDirectory();
    final manualDirectory = Directory('${directory.path}/ai_manuals');
    await manualDirectory.create(recursive: true);

    final xposedAsset = isZh
        ? 'assets/raws/JsxposedX_API.md'
        : 'assets/raws/JsxposedX_API_en.md';
    final fridaAsset = isZh
        ? 'assets/raws/Frida_API.md'
        : 'assets/raws/Frida_API_en.md';
    final xposedPath = '${manualDirectory.path}/JsxposedX_API.md';
    final fridaPath = '${manualDirectory.path}/Frida_API.md';
    await _copyAsset(xposedAsset, xposedPath);
    await _copyAsset(fridaAsset, fridaPath);
    return AiManualBundle(
      xposedManualPath: xposedPath,
      fridaManualPath: fridaPath,
    );
  }

  static Future<void> _copyAsset(String assetPath, String targetPath) async {
    final content = await rootBundle.loadString(assetPath);
    await File(targetPath).writeAsString(content, flush: true);
  }
}
