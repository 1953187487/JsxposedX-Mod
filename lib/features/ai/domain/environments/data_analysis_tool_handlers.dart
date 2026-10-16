import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';

// ═══ 基类 ═══

abstract class DataAnalysisHandler implements AiChatToolHandler {
  const DataAnalysisHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  String get _sessionId => context.sessionId;

  bool get _isZh => context.isZh;
}

// ═══ C1. analyze_manifest（P1） ═══

class AnalyzeManifestHandler extends DataAnalysisHandler {
  const AnalyzeManifestHandler(super.context);

  @override
  String get toolName => 'analyze_manifest';

  /// 危险权限特征表
  static const _dangerousPermissions = {
    'android.permission.READ_SMS': ('高风险', '读取短信 / Read SMS'),
    'android.permission.SEND_SMS': ('高风险', '发送短信 / Send SMS'),
    'android.permission.RECEIVE_SMS': ('高风险', '接收短信 / Receive SMS'),
    'android.permission.READ_CONTACTS': ('高风险', '读取联系人 / Read contacts'),
    'android.permission.READ_CALL_LOG': ('高风险', '读取通话记录 / Read call log'),
    'android.permission.CAMERA': ('中风险', '相机 / Camera'),
    'android.permission.RECORD_AUDIO': ('中风险', '录音 / Record audio'),
    'android.permission.ACCESS_FINE_LOCATION': ('中风险', '精确定位 / Fine location'),
    'android.permission.ACCESS_BACKGROUND_LOCATION': ('高风险', '后台定位 / Background location'),
    'android.permission.READ_EXTERNAL_STORAGE': ('中风险', '读外部存储 / Read external storage'),
    'android.permission.WRITE_EXTERNAL_STORAGE': ('中风险', '写外部存储 / Write external storage'),
    'android.permission.REQUEST_INSTALL_PACKAGES': ('中风险', '请求安装应用 / Request install packages'),
    'android.permission.SYSTEM_ALERT_WINDOW': ('中风险', '悬浮窗 / Overlay window'),
    'android.permission.BIND_ACCESSIBILITY_SERVICE': ('中风险', '无障碍服务 / Accessibility service'),
    'android.permission.BIND_DEVICE_ADMIN': ('高风险', '设备管理器 / Device admin'),
  };

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final focus = call.getString('focus', 'all');
    final showPermissions = focus == 'all' || focus == 'permissions';
    final showComponents = focus == 'all' || focus == 'components';

    try {
      final manifest = await context.repo.parseManifest(_sessionId);
      final buf = StringBuffer();

      buf.writeln(_isZh ? '## Manifest 风险分析\n' : '## Manifest Risk Analysis\n');

      if (showPermissions) {
        buf.writeln(_isZh ? '### 权限分析' : '### Permission Analysis');

        final riskyPerms = <String, String>{};
        for (final perm in manifest.permissions) {
          if (perm != null && _dangerousPermissions.containsKey(perm)) {
            riskyPerms[perm] = _dangerousPermissions[perm]!.$1;
          }
        }

        if (riskyPerms.isEmpty) {
          buf.writeln(_isZh ? '未发现危险权限' : 'No dangerous permissions found');
        } else {
          for (final entry in riskyPerms.entries) {
            final info = _dangerousPermissions[entry.key]!;
            buf.writeln('- **$entry.value**: `${entry.key}` → ${_isZh ? info.$2 : info.$2}');
          }
        }

        // debuggable 检查
        if (manifest.debuggable) {
          buf.writeln(
            _isZh
                ? '\n⚠️ **debuggable=true** —— 应用可调试，增加逆向风险'
                : '\n⚠️ **debuggable=true** —— App is debuggable, increases reverse engineering risk',
          );
        }

        // allowBackup 检查
        if (manifest.allowBackup) {
          buf.writeln(
            _isZh
                ? '\n⚠️ **allowBackup=true** —— 允许备份，数据可能泄露'
                : '\n⚠️ **allowBackup=true** —— Backup allowed, data may leak',
          );
        }

        buf.writeln();
      }

      if (showComponents) {
        buf.writeln(_isZh ? '### 组件暴露面' : '### Component Exposure');

        final activities = manifest.activities.whereType<ApkComponent>();
        final services = manifest.services.whereType<ApkComponent>();
        final receivers = manifest.receivers.whereType<ApkComponent>();
        final providers = manifest.providers.whereType<ApkComponent>();
        final exportedActivities = activities.where((a) => a.exported);
        final exportedServices = services.where((s) => s.exported);
        final exportedReceivers = receivers.where((r) => r.exported);
        final exportedProviders = providers.where((p) => p.exported);

        final total = exportedActivities.length +
            exportedServices.length +
            exportedReceivers.length +
            exportedProviders.length;

        if (total == 0) {
          buf.writeln(_isZh ? '无导出组件' : 'No exported components');
        } else {
          buf.writeln(
            _isZh
                ? '共 $total 个导出组件：Activity ${exportedActivities.length} / Service ${exportedServices.length} / Receiver ${exportedReceivers.length} / Provider ${exportedProviders.length}'
                : 'Total $total exported components: Activity ${exportedActivities.length} / Service ${exportedServices.length} / Receiver ${exportedReceivers.length} / Provider ${exportedProviders.length}',
          );

          if (exportedActivities.isNotEmpty) {
            buf.writeln(_isZh ? '\n**导出 Activity:**' : '\n**Exported Activities:**');
            for (final a in exportedActivities.take(10)) {
              buf.writeln('- ${a.name}');
            }
            if (exportedActivities.length > 10) {
              buf.writeln(
                _isZh
                    ? '  ... 还有 ${exportedActivities.length - 10} 个'
                    : '  ... and ${exportedActivities.length - 10} more',
              );
            }
          }
        }
      }

      return buf.toString().trimRight();
    } catch (e) {
      throw Exception(
        '${_isZh ? "Manifest 解析失败" : "Manifest parse failed"}: $e',
      );
    }
  }
}

// ═══ C2. detect_packers（P1） ═══

class DetectPackersHandler extends DataAnalysisHandler {
  const DetectPackersHandler(super.context);

  @override
  String get toolName => 'detect_packers';

  /// 壳特征库：so 文件名 → 壳名 + 证据说明
  static const _packerSignatures = <String, ({String name, String desc})>{
    'libjiagu.so': (name: '360 加固 / 360 Jiagu', desc: '360 加固特征库'),
    'libjiagu_a64.so': (name: '360 加固 64位 / 360 Jiagu 64bit', desc: '360 加固 64 位变体'),
    'libjiagu_x86.so': (name: '360 加固 x86 / 360 Jiagu x86', desc: '360 加固 x86 变体'),
    'libshell.so': (name: '梆梆加固 / Bangcle', desc: '梆梆加固主特征'),
    'libsecexe.so': (name: '梆梆加固 / Bangcle', desc: '梆梆加固变体'),
    'libDexHelper.so': (name: '梆梆加固 / Bangcle', desc: '梆梆 DexHelper'),
    'libSecShell.so': (name: '梆梆加固 / Bangcle', desc: '梆梆 SecShell 特征'),
    'libexec.so': (name: '爱加密 / Ijiami', desc: '爱加密主特征'),
    'libexecmain.so': (name: '爱加密 / Ijiami', desc: '爱加密变体'),
    'libdefender.so': (name: '腾讯乐固 / Tencent Legu', desc: '腾讯乐固主特征'),
    'libtpssafe.so': (name: '腾讯御安全 / Tencent YuSafe', desc: '腾讯御安全主特征'),
    'libprotectClass.so': (name: '几维加固 / Kiwi Guard', desc: '几维特征'),
    'libAPKProtect.so': (name: 'APKProtect', desc: 'APKProtect 特征'),
    'libbaiduprotect.so': (name: '百度加固 / Baidu Guard', desc: '百度加固特征'),
    'libCrypto.so': (name: '网易易盾 / NetEase Yidun', desc: '网易易盾特征'),
    'libnesec.so': (name: '网易易盾 / NetEase Yidun', desc: '变体'),
  };

  /// Application 类名特征
  static const _appClassSignatures = {
    'com.qihoo360': '360 加固 / 360 Jiagu',
    'com.bangcle': '梆梆加固 / Bangcle',
    'com.secneo': '梆梆加固 / Bangcle',
    'com.ijiami': '爱加密 / Ijiami',
    'com.tencent.StubShell': '腾讯乐固 / Tencent Legu',
    'com.tencent.bugly': '腾讯御安全 / Tencent YuSafe',
    'com.kiwisec': '几维加固 / Kiwi Guard',
    'com.baidu.protect': '百度加固 / Baidu Guard',
    'com.netease.nis': '网易易盾 / NetEase Yidun',
  };

  /// applicationLabel 壳关键词
  static const _packerLabelKeywords = [
    'jiagu', 'bangcle', 'ijiami', 'legu', 'protect', 'guard', 'secneo',
    'qihu', 'tencent', 'baidu', 'netease', 'yidun', 'kiwi',
  ];

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    try {
      final manifest = await context.repo.parseManifest(_sessionId);
      final assets = await context.repo.getApkAssets(_sessionId);
      final soFiles = assets
          .where((a) => a.name.endsWith('.so'))
          .map((a) => a.name)
          .toSet();

      // 1. so 特征匹配
      final soMatches = <String>{};
      final soEvidence = <String, String>{};
      for (final soFile in soFiles) {
        if (_packerSignatures.containsKey(soFile)) {
          final sig = _packerSignatures[soFile]!;
          soMatches.add(sig.name);
          soEvidence[soFile] = sig.desc;
        }
      }

      // 2. Application 标签特征（applicationLabel 含壳厂商关键词）
      final appMatches = <String>{};
      final appLabel = manifest.applicationLabel;
      if (appLabel != null) {
        for (final entry in _appClassSignatures.entries) {
          if (appLabel.contains(entry.key) || 
              _packerLabelKeywords.any((kw) => appLabel.toLowerCase().contains(kw))) {
            appMatches.add(entry.value);
          }
        }
      }

      final allPackerNames = {...soMatches, ...appMatches};
      final buf = StringBuffer();

      if (allPackerNames.isEmpty) {
        buf.writeln(
          _isZh
              ? '## 加固检测\n\n未检测到已知壳特征。\n\n注意：这不能完全排除使用未知壳或自定义壳的可能，建议进一步分析代码。'
              : '## Packer Detection\n\nNo known packer signatures detected.\n\nNote: This does not rule out unknown/custom packers. Further analysis is recommended.',
        );
      } else {
        buf.writeln(_isZh ? '## 加固检测\n' : '## Packer Detection\n');
        buf.writeln(
          _isZh
              ? '**检测结果**: 发现 ${allPackerNames.length} 个匹配\n'
              : '**Result**: ${allPackerNames.length} match(es) found\n',
        );
        for (final name in allPackerNames) {
          buf.writeln('- $name');
        }

        if (soEvidence.isNotEmpty) {
          buf.writeln(_isZh ? '\n**SO 证据:**' : '\n**SO Evidence:**');
          for (final entry in soEvidence.entries) {
            buf.writeln('- `${entry.key}` → ${entry.value}');
          }
        }

        if (appMatches.isNotEmpty) {
          buf.writeln(
            _isZh
                ? '\n**Application 标签证据**: ${appLabel ?? "未知"}'
                : '\n**Application Label Evidence**: ${appLabel ?? "unknown"}',
          );
        }

        buf.writeln(
          _isZh
              ? '\n**建议**: 先用 generate_frida_hook 工具分析 Native 层，再尝试脱壳。'
              : '\n**Suggestion**: Use generate_frida_hook to analyze the native layer first, then attempt unpacking.',
        );
      }

      return buf.toString().trimRight();
    } catch (e) {
      throw Exception(
        '${_isZh ? "检测失败" : "Detection failed"}: $e',
      );
    }
  }
}

// ═══ C3. detect_sdk（P2） ═══

class DetectSdkHandler extends DataAnalysisHandler {
  const DetectSdkHandler(super.context);

  @override
  String get toolName => 'detect_sdk';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    return _isZh
        ? 'SDK 检测功能需特征库支持，正在开发中。请先用 list_packages 浏览包结构。'
        : 'SDK detection requires a signature database, under development. Use list_packages to browse package structure.';
  }
}

// ═══ C4. search_code_patterns（P2） ═══

class SearchCodePatternsHandler extends DataAnalysisHandler {
  const SearchCodePatternsHandler(super.context);

  @override
  String get toolName => 'search_code_patterns';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final pattern = call.getString('pattern');
    if (pattern.isEmpty) throw ArgumentError('pattern 不能为空');

    return _isZh
        ? '代码模式搜索功能需 native 批量扫描支持，正在开发中。请用 search_classes + decompile_class 逐个查看。'
        : 'Code pattern search requires native batch scanning, under development. Use search_classes + decompile_class for individual checks.';
  }
}