import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_environment.dart';
import 'package:JsxposedX/features/ai/domain/environments/apk_reverse_prompt_builder.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_tool_registry.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart'
    as system;
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart'
    as legacy;
import 'package:JsxposedX/features/ai/domain/ports/ai_tool_executor.dart';
import 'package:JsxposedX/features/ai/domain/services/tool_executor.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_conversation_export_service.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_action_repository.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_query_repository.dart';
import 'package:JsxposedX/features/so_analysis/data/datasources/so_analysis_datasource.dart';

class ApkReverseAiEnvironment {
  ApkReverseAiEnvironment({
    required this.packageName,
    required this.isZh,
    required ApkAnalysisActionRepository apkActionRepository,
    required ApkAnalysisQueryRepository apkQueryRepository,
    required SoAnalysisDatasource soDataSource,
    required ScriptConversationBinding conversationBinding,
    AiConversationExportService? exportService,
  }) : _apkActionRepository = apkActionRepository,
       _apkQueryRepository = apkQueryRepository,
       _soDataSource = soDataSource,
       _conversationBinding = conversationBinding,
       _exportService = exportService;

  final String packageName;
  final bool isZh;
  final ApkAnalysisActionRepository _apkActionRepository;
  final ApkAnalysisQueryRepository _apkQueryRepository;
  final SoAnalysisDatasource _soDataSource;
  final ScriptConversationBinding _conversationBinding;
  final AiConversationExportService? _exportService;

  String? _sessionId;
  List<String> _dexPaths = const [];
  AiChatSessionEnvironment? _configuration;
  bool _disposed = false;

  String? get sessionId => _sessionId;
  List<String> get dexPaths => _dexPaths;
  AiChatSessionEnvironment get configuration =>
      _configuration ??
      (throw StateError('APK reverse environment is not initialized'));

  Future<AiChatSessionEnvironment> initialize() async {
    if (_disposed) {
      throw StateError('APK reverse environment has been disposed');
    }
    final previous = _sessionId;
    if (previous != null && previous.isNotEmpty) {
      await _apkActionRepository.closeApkSession(previous);
    }

    final sessionId = await _apkActionRepository.openApkSession(packageName);
    _sessionId = sessionId;
    final manifest = await _apkQueryRepository.parseManifest(sessionId);
    final assets = await _apkQueryRepository.getApkAssets(sessionId);
    final soFiles = assets
        .where((asset) => asset.name.endsWith('.so'))
        .map((asset) => asset.path)
        .toList(growable: false);
    _dexPaths = assets
        .where((asset) => asset.name.endsWith('.dex'))
        .map((asset) => asset.path)
        .toList(growable: false);

    final apkContext = AiApkContext.fromManifest(manifest, soFiles: soFiles);
    final manualBundle = await ApkReversePromptBuilder.exportManualBundle(
      isZh: isZh,
    );
    final prompt = ApkReversePromptBuilder(isZh: isZh)
        .withApkContext(apkContext)
        .withManualBundle(manualBundle)
        .withTools()
        .buildSystemPrompt();
    final allRegs = [
      ...AiToolRegistry.apkReverse(includeSoTools: true),
      ...AiToolRegistry.scriptLifecycle(),
      ...AiToolRegistry.contentProduction(),
      ...AiToolRegistry.dataAnalysis(),
      ...AiToolRegistry.systemControl(),
      ...AiToolRegistry.multimodal(),
    ];

    final ctx = ApkReverseToolRuntimeContext(
      repo: _apkQueryRepository,
      soDataSource: _soDataSource,
      sessionId: sessionId,
      dexPaths: _dexPaths,
      conversationBinding: _conversationBinding,
      packageName: packageName,
      isZh: isZh,
      exportService: _exportService,
    );
    final definitions = allRegs
        .map((r) => r.definition)
        .toList(growable: false);
    final legacyExecutor = ToolExecutor(
      handlers: {
        for (final r in allRegs) r.definition.name: r.handlerFactory(ctx),
      },
      registrations: {for (final r in allRegs) r.definition.name: r},
    );

    final configuration = AiChatSessionEnvironment(
      id: 'apk_reverse',
      scopeId: packageName,
      version: 'apk_reverse:${isZh ? "zh" : "en"}:v2',
      systemPrompt: prompt,
      tools: definitions
          .map(
            (definition) => system.AiToolSpec(
              name: definition.name,
              description: definition.description,
              inputSchema: definition.parameters,
            ),
          )
          .toList(growable: false),
      toolExecutor: _LegacyToolExecutorBridge(legacyExecutor),
    );
    _configuration = configuration;
    return configuration;
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    final sessionId = _sessionId;
    _sessionId = null;
    _dexPaths = const [];
    _configuration = null;
    if (sessionId != null && sessionId.isNotEmpty) {
      await _apkActionRepository.closeApkSession(sessionId);
    }
  }
}

class _LegacyToolExecutorBridge implements AiToolExecutor {
  const _LegacyToolExecutorBridge(this._delegate);

  final ToolExecutor _delegate;

  @override
  Future<system.AiToolResult> execute(
    system.AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    final result = await _delegate.execute(
      legacy.AiToolCall(
        id: call.id,
        name: call.name,
        arguments: Map<String, dynamic>.from(call.arguments),
      ),
      onProgress: onProgress,
    );
    return system.AiToolResult(
      toolCallId: result.toolCallId,
      name: result.toolName,
      success: result.success,
      content: result.success ? result.content : result.errorContent,
    );
  }
}
