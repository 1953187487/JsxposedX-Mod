import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_script_log_repository.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/environments/script_lifecycle_tool_handlers.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_query_repository.dart';
import 'package:JsxposedX/features/so_analysis/data/datasources/so_analysis_datasource.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';
import 'package:JsxposedX/generated/so_analysis.g.dart';

// 测试用的 stub 实现，不需要任何实际功能
class _StubApkRepo implements ApkAnalysisQueryRepository {
  @override
  Future<List<ApkAsset>> getApkAssets(String sessionId) async => [];

  @override
  Future<List<ApkAsset>> getApkAssetsAt(String sessionId, String path) async => [];

  @override
  Future<ApkManifest> parseManifest(String sessionId) async => 
      ApkManifest(
        packageName: '',
        versionName: '',
        versionCode: 0,
        minSdk: 0,
        targetSdk: 0,
        permissions: [],
        activities: [],
        services: [],
        receivers: [],
        providers: [],
        debuggable: false,
        allowBackup: false,
      );

  @override
  Future<List<String>> getDexPackages(
      String sessionId, List<String> dexPaths, String packagePrefix) async => [];

  @override
  Future<List<DexClass>> getDexClasses(
      String sessionId, List<String> dexPaths, String packageName) async => [];

  @override
  Future<String> getClassSmali(
      String sessionId, List<String> dexPaths, String className) async => '';

  @override
  Future<String> decompileClass(
      String sessionId, List<String> dexPaths, String className) async => '';

  @override
  Future<List<String>> searchDexClasses(
      String sessionId, List<String> dexPaths, String keyword) async => [];
}

class _StubSoDataSource implements SoAnalysisDatasource {
  @override
  Future<SoElfHeader> parseSoHeader(String sessionId, String soPath) async =>
      SoElfHeader(
        magic: '',
        classType: '',
        dataEncoding: '',
        osAbi: '',
        fileType: '',
        machine: '',
        entryPoint: 0,
        programHeaderOffset: 0,
        sectionHeaderOffset: 0,
        flags: 0,
        programHeaderCount: 0,
        sectionHeaderCount: 0,
      );

  @override
  Future<List<SoSection>> getSoSections(String sessionId, String soPath) async => [];

  @override
  Future<List<SoSymbol>> getExportedSymbols(String sessionId, String soPath) async => [];

  @override
  Future<List<SoSymbol>> getImportedSymbols(String sessionId, String soPath) async => [];

  @override
  Future<List<SoDependency>> getDependencies(String sessionId, String soPath) async => [];

  @override
  Future<List<SoString>> getSoStrings(String sessionId, String soPath) async => [];

  @override
  Future<List<SoJniFunction>> getJniFunctions(String sessionId, String soPath) async => [];

  @override
  Future<String> generateFridaHook(
      String sessionId, String soPath, String symbolName, int address) async => '';
}

void main() {
  late AiDatabase database;
  late DriftScriptLogRepository scriptLogs;
  late GetScriptLogsHandler handler;

  ApkReverseToolRuntimeContext createContext(
    String conversationId, {
    String packageName = '',
  }) {
    final binding = ScriptConversationBinding(scriptLogs)
      ..conversationId = conversationId;
    
    return ApkReverseToolRuntimeContext(
      repo: _StubApkRepo(),
      soDataSource: _StubSoDataSource(),
      sessionId: 'test-session',
      dexPaths: [],
      conversationBinding: binding,
      packageName: packageName,
      isZh: true,
    );
  }

  setUp(() async {
    database = AiDatabase.forTesting(NativeDatabase.memory());
    scriptLogs = DriftScriptLogRepository(database);
  });

  tearDown(() => database.close());

  group('GetScriptLogsHandler - AI 会话日志查询', () {
    test('查询特定 AI 会话的脚本运行日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-123',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'VipManager_isVip_Hook.js',
        startedAt: now,
      );

      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-123',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'VipManager_isVip_Hook.js',
          level: 'I',
          message: 'Hook installed successfully',
          stackTrace: '',
          timestamp: now,
        ),
        ScriptLogRecord(
          id: 0,
          runId: 'run-123',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'VipManager_isVip_Hook.js',
          level: 'I',
          message: 'Hooked VipManager.isVip()',
          stackTrace: '',
          timestamp: now.add(const Duration(seconds: 1)),
        ),
        ScriptLogRecord(
          id: 0,
          runId: 'run-123',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'VipManager_isVip_Hook.js',
          level: 'W',
          message: 'Original method returned false',
          stackTrace: '',
          timestamp: now.add(const Duration(seconds: 2)),
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {},
        ),
      );

      expect(result, contains('Hook installed successfully'));
      expect(result, contains('Hooked VipManager.isVip()'));
      expect(result, contains('Original method returned false'));
      expect(result, contains('[xposed/I]'));
      expect(result, contains('[xposed/W]'));
      expect(result, contains('run-123'));
    });

    test('按 runId 过滤多次运行的日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      // 第一次运行
      await scriptLogs.startRun(
        runId: 'run-1',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-1',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'First run log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      // 第二次运行
      await scriptLogs.startRun(
        runId: 'run-2',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now.add(const Duration(minutes: 5)),
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-2',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Second run log',
          stackTrace: '',
          timestamp: now.add(const Duration(minutes: 5)),
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'runId': 'run-2'},
        ),
      );

      expect(result, contains('Second run log'));
      expect(result, contains('run-2'));
      expect(result, isNot(contains('First run log')));
      expect(result, isNot(contains('run-1')));
    });

    test('按 scriptName 过滤不同脚本的日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-hook',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-hook',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Hook log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      await scriptLogs.startRun(
        runId: 'run-frida',
        conversationId: 'conv-ai-session',
        source: 'frida',
        scriptName: 'trace.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-frida',
          conversationId: 'conv-ai-session',
          source: 'frida',
          scriptName: 'trace.js',
          level: 'I',
          message: 'Frida log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'scriptName': 'trace.js'},
        ),
      );

      expect(result, contains('Frida log'));
      expect(result, contains('trace.js'));
      expect(result, isNot(contains('Hook log')));
      expect(result, isNot(contains('hook.js')));
    });

    test('按 source 过滤 xposed 和 frida 日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-xposed',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-xposed',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Xposed hook',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      await scriptLogs.startRun(
        runId: 'run-frida',
        conversationId: 'conv-ai-session',
        source: 'frida',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-frida',
          conversationId: 'conv-ai-session',
          source: 'frida',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Frida hook',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'source': 'frida'},
        ),
      );

      expect(result, contains('Frida hook'));
      expect(result, contains('[frida/I]'));
      expect(result, isNot(contains('Xposed hook')));
      expect(result, isNot(contains('[xposed/I]')));
    });

    test('按 level 过滤错误日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-1',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'run-1',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Normal log',
          stackTrace: '',
          timestamp: now,
        ),
        ScriptLogRecord(
          id: 0,
          runId: 'run-1',
          conversationId: 'conv-ai-session',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'E',
          message: 'Error occurred',
          stackTrace: 'at hook.js:42',
          timestamp: now.add(const Duration(seconds: 1)),
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'level': 'E'},
        ),
      );

      expect(result, contains('Error occurred'));
      expect(result, contains('[xposed/E]'));
      expect(result, contains('at hook.js:42'));
      expect(result, isNot(contains('Normal log')));
    });

    test('查询空日志时返回友好提示', () async {
      handler = GetScriptLogsHandler(createContext('conv-empty'));

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {},
        ),
      );

      expect(result, contains('当前会话暂无匹配的脚本日志'));
    });

    test('会话 ID 为空时返回提示', () async {
      handler = GetScriptLogsHandler(createContext(''));

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {},
        ),
      );

      expect(result, contains('当前会话暂无脚本日志'));
    });
  });

  group('GetScriptLogsHandler - 独立运行日志回退', () {
    test('AI 会话无日志时回退到独立运行日志', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(
        createContext('conv-empty', packageName: 'com.example.app'),
      );

      // 独立运行的日志使用 standalone: conversationId
      await scriptLogs.startRun(
        runId: 'standalone-run-1',
        conversationId: 'standalone:com.example.app:xposed:hook.js',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'standalone-run-1',
          conversationId: 'standalone:com.example.app:xposed:hook.js',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Standalone hook log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'scriptName': 'hook.js'},
        ),
      );

      expect(result, contains('Standalone hook log'));
      expect(result, contains('[xposed/I]'));
    });

    test('独立运行日志按 scriptName 过滤', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(
        createContext('conv-empty', packageName: 'com.example.app'),
      );

      await scriptLogs.startRun(
        runId: 'standalone-run-1',
        conversationId: 'standalone:com.example.app:xposed:hook1.js',
        source: 'xposed',
        scriptName: 'hook1.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'standalone-run-1',
          conversationId: 'standalone:com.example.app:xposed:hook1.js',
          source: 'xposed',
          scriptName: 'hook1.js',
          level: 'I',
          message: 'Hook1 log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      await scriptLogs.startRun(
        runId: 'standalone-run-2',
        conversationId: 'standalone:com.example.app:xposed:hook2.js',
        source: 'xposed',
        scriptName: 'hook2.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'standalone-run-2',
          conversationId: 'standalone:com.example.app:xposed:hook2.js',
          source: 'xposed',
          scriptName: 'hook2.js',
          level: 'I',
          message: 'Hook2 log',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'scriptName': 'hook2.js'},
        ),
      );

      expect(result, contains('Hook2 log'));
      expect(result, isNot(contains('Hook1 log')));
    });

    test('独立运行日志按 source 过滤', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(
        createContext('conv-empty', packageName: 'com.example.app'),
      );

      await scriptLogs.startRun(
        runId: 'standalone-xposed',
        conversationId: 'standalone:com.example.app:xposed:hook.js',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'standalone-xposed',
          conversationId: 'standalone:com.example.app:xposed:hook.js',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Xposed standalone',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      await scriptLogs.startRun(
        runId: 'standalone-frida',
        conversationId: 'standalone:com.example.app:frida:hook.js',
        source: 'frida',
        scriptName: 'hook.js',
        startedAt: now,
      );
      await scriptLogs.appendLogs([
        ScriptLogRecord(
          id: 0,
          runId: 'standalone-frida',
          conversationId: 'standalone:com.example.app:frida:hook.js',
          source: 'frida',
          scriptName: 'hook.js',
          level: 'I',
          message: 'Frida standalone',
          stackTrace: '',
          timestamp: now,
        ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'source': 'frida', 'scriptName': 'hook.js'},
        ),
      );

      expect(result, contains('Frida standalone'));
      expect(result, isNot(contains('Xposed standalone')));
    });
  });

  group('GetScriptLogsHandler - 分页查询', () {
    test('limit 参数限制返回日志数量', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-1',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );

      await scriptLogs.appendLogs([
        for (var i = 0; i < 10; i++)
          ScriptLogRecord(
            id: 0,
            runId: 'run-1',
            conversationId: 'conv-ai-session',
            source: 'xposed',
            scriptName: 'hook.js',
            level: 'I',
            message: 'Log $i',
            stackTrace: '',
            timestamp: now.add(Duration(seconds: i)),
          ),
      ]);

      final result = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {'limit': 3},
        ),
      );

      final lines = result.split('\n');
      expect(lines.length, 3);
      expect(result, contains('Log 9'));
      expect(result, contains('Log 8'));
      expect(result, contains('Log 7'));
    });

    test('before 和 beforeId 参数实现游标分页', () async {
      final now = DateTime.utc(2026, 9, 25);
      handler = GetScriptLogsHandler(createContext('conv-ai-session'));

      await scriptLogs.startRun(
        runId: 'run-1',
        conversationId: 'conv-ai-session',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: now,
      );

      await scriptLogs.appendLogs([
        for (var i = 0; i < 5; i++)
          ScriptLogRecord(
            id: i + 1,
            runId: 'run-1',
            conversationId: 'conv-ai-session',
            source: 'xposed',
            scriptName: 'hook.js',
            level: 'I',
            message: 'Log $i',
            stackTrace: '',
            timestamp: now.add(Duration(seconds: i)),
          ),
      ]);

      // 第一页
      final firstPage = await scriptLogs.getLogs(
        conversationId: 'conv-ai-session',
        limit: 2,
      );
      expect(firstPage.length, 2);
      expect(firstPage[0].message, 'Log 4');
      expect(firstPage[1].message, 'Log 3');

      // 第二页，使用 before 和 beforeId
      final secondPageResult = await handler.handle(
        AiToolCall(
          id: 'call-1',
          name: 'get_script_logs',
          arguments: {
            'before': firstPage.last.timestamp.toIso8601String(),
            'beforeId': firstPage.last.id,
            'limit': 2,
          },
        ),
      );

      expect(secondPageResult, contains('Log 2'));
      expect(secondPageResult, contains('Log 1'));
      expect(secondPageResult, isNot(contains('Log 4')));
      expect(secondPageResult, isNot(contains('Log 3')));
    });
  });
}
