import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_script_log_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide
        AiAssistantProfile,
        AiConversation,
        AiModelDefinition,
        AiProviderConnection;

void main() {
  late AiDatabase database;
  late DriftAiCatalogRepository catalog;
  late DriftAiConversationRepository conversations;
  late DriftScriptLogRepository scriptLogs;

  setUp(() async {
    database = AiDatabase.forTesting(NativeDatabase.memory());
    catalog = DriftAiCatalogRepository(database);
    conversations = DriftAiConversationRepository(database);
    scriptLogs = DriftScriptLogRepository(database);
    final now = DateTime.utc(2026, 9, 5);
    await catalog.saveConnectionBundle(
      connection: AiProviderConnection(
        id: 'connection',
        providerId: 'openai',
        displayName: 'OpenAI',
        baseUri: Uri.parse('https://example.test/v1/'),
      ),
      models: const [
        AiModelDefinition(
          id: 'model',
          connectionId: 'connection',
          displayName: 'Model',
          capabilities: AiModelCapabilities(),
          limits: AiModelLimits(),
        ),
      ],
      assistants: [
        AiAssistantProfile(
          id: 'assistant',
          name: 'Assistant',
          connectionId: 'connection',
          modelId: 'model',
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
  });

  tearDown(() => database.close());

  test(
    'marks runs left running by a previous process as interrupted',
    () async {
      final startedAt = DateTime.utc(2026, 9, 5);
      await scriptLogs.startRun(
        runId: 'stale-run',
        conversationId: 'conversation',
        source: 'xposed',
        scriptName: 'hook.js',
        startedAt: startedAt,
      );

      await scriptLogs.recoverInterruptedRuns();

      final run = await scriptLogs.getRun('stale-run');
      expect(run?.status, 'interrupted');
      expect(run?.finishedAt, isNotNull);
      expect(run?.conversationId, 'conversation');
    },
  );

  test('persists connection, model and assistant as entities', () async {
    final now = DateTime.utc(2026, 9, 5);
    final connection = AiProviderConnection(
      id: 'connection',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: Uri.parse('https://example.test/v1/'),
      credentialRef: 'credential-ref',
    );
    const model = AiModelDefinition(
      id: 'model',
      connectionId: 'connection',
      displayName: 'Model',
      capabilities: AiModelCapabilities(streaming: true),
      limits: AiModelLimits(contextTokens: 128000),
    );
    final assistant = AiAssistantProfile(
      id: 'assistant',
      name: 'Default',
      connectionId: 'connection',
      modelId: 'model',
      createdAt: now,
      updatedAt: now,
    );

    await catalog.saveConnection(connection);
    await catalog.saveModels('connection', [model]);
    await catalog.saveAssistant(assistant);

    expect(await catalog.getConnection('connection'), connection);
    expect(await catalog.getModel('connection', 'model'), model);
    expect(await catalog.getAssistant('assistant'), assistant);
  });

  test('saves a catalog bundle atomically', () async {
    final now = DateTime.utc(2026, 9, 5);
    await database.customStatement('''
      CREATE TRIGGER reject_assistant_insert
      BEFORE INSERT ON ai_assistant_profiles
      BEGIN
        SELECT RAISE(ABORT, 'test failure');
      END;
    ''');

    await expectLater(
      catalog.saveConnectionBundle(
        connection: AiProviderConnection(
          id: 'atomic-connection',
          providerId: 'openai',
          displayName: 'OpenAI',
          baseUri: Uri.parse('https://example.test/v1/'),
        ),
        models: const [
          AiModelDefinition(
            id: 'atomic-model',
            connectionId: 'atomic-connection',
            displayName: 'Model',
            capabilities: AiModelCapabilities(),
            limits: AiModelLimits(),
          ),
        ],
        assistants: [
          AiAssistantProfile(
            id: 'atomic-assistant',
            name: 'Assistant',
            connectionId: 'atomic-connection',
            modelId: 'atomic-model',
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      throwsA(anything),
    );

    expect(await catalog.getConnection('atomic-connection'), isNull);
    expect(await catalog.getModels('atomic-connection'), isEmpty);
  });

  test('refuses to delete a connection referenced by an assistant', () async {
    final now = DateTime.utc(2026, 9, 5);
    await catalog.saveConnectionBundle(
      connection: AiProviderConnection(
        id: 'connection',
        providerId: 'openai',
        displayName: 'OpenAI',
        baseUri: Uri.parse('https://example.test/v1/'),
      ),
      models: const [
        AiModelDefinition(
          id: 'model',
          connectionId: 'connection',
          displayName: 'Model',
          capabilities: AiModelCapabilities(),
          limits: AiModelLimits(),
        ),
      ],
      assistants: [
        AiAssistantProfile(
          id: 'assistant',
          name: 'Assistant',
          connectionId: 'connection',
          modelId: 'model',
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );

    await expectLater(catalog.deleteConnection('connection'), throwsStateError);
    expect(await catalog.getConnection('connection'), isNotNull);
    expect(await catalog.getModel('connection', 'model'), isNotNull);
  });

  test('refuses to save models for a missing connection', () async {
    await expectLater(
      catalog.saveModels('missing', const [
        AiModelDefinition(
          id: 'model',
          connectionId: 'missing',
          displayName: 'Model',
          capabilities: AiModelCapabilities(),
          limits: AiModelLimits(),
        ),
      ]),
      throwsStateError,
    );
  });

  test('refuses to persist credentials in custom headers', () async {
    await expectLater(
      catalog.saveConnection(
        AiProviderConnection(
          id: 'unsafe',
          providerId: 'openai',
          displayName: 'Unsafe',
          baseUri: Uri.parse('https://example.test/v1/'),
          customHeaders: const {'Authorization': 'Bearer secret'},
        ),
      ),
      throwsArgumentError,
    );

    expect(await catalog.getConnection('unsafe'), isNull);
  });

  test('refuses dangling conversations and messages', () async {
    final now = DateTime.utc(2026, 9, 5);
    await expectLater(
      conversations.saveConversation(
        AiConversation(
          id: 'dangling',
          title: 'Dangling',
          assistantId: 'missing',
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsStateError,
    );
    await expectLater(
      conversations.saveMessage(
        AiMessage(
          id: 'dangling-message',
          conversationId: 'missing',
          role: AiMessageRole.user,
          parts: const [AiContentPart.text('hello')],
          createdAt: now,
        ),
      ),
      throwsStateError,
    );
  });

  test('refuses to delete referenced models and assistants', () async {
    final now = DateTime.utc(2026, 9, 5);
    await expectLater(
      catalog.deleteModel('connection', 'model'),
      throwsStateError,
    );
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await expectLater(catalog.deleteAssistant('assistant'), throwsStateError);
  });

  test('paginates messages in chronological display order', () async {
    final now = DateTime.utc(2026, 9, 5);
    final conversation = AiConversation(
      id: 'conversation',
      title: 'Chat',
      assistantId: 'assistant',
      createdAt: now,
      updatedAt: now,
    );
    await conversations.saveConversation(conversation);
    await conversations.saveMessages([
      for (var index = 0; index < 3; index++)
        AiMessage(
          id: 'message-$index',
          conversationId: 'conversation',
          role: index.isEven ? AiMessageRole.user : AiMessageRole.assistant,
          parts: [AiContentPart.text('$index')],
          createdAt: now.add(Duration(seconds: index)),
        ),
    ]);

    final messages = await conversations.getMessages('conversation', limit: 2);

    expect(messages.map((message) => message.id), ['message-1', 'message-2']);
  });

  test('message cursor does not skip equal timestamps', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await conversations.saveMessages([
      for (var index = 0; index < 4; index++)
        AiMessage(
          id: 'message-$index',
          conversationId: 'conversation',
          role: AiMessageRole.user,
          parts: [AiContentPart.text('$index')],
          createdAt: now,
        ),
    ]);

    final latest = await conversations.getMessages('conversation', limit: 2);
    final older = await conversations.getMessages(
      'conversation',
      before: AiMessageCursor(
        createdAt: latest.first.createdAt,
        id: latest.first.id,
      ),
      limit: 2,
    );

    expect(older.map((message) => message.id), ['message-0', 'message-1']);
    expect(latest.map((message) => message.id), ['message-2', 'message-3']);
  });

  test('deletes messages with their conversation', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await conversations.saveMessage(
      AiMessage(
        id: 'message',
        conversationId: 'conversation',
        role: AiMessageRole.user,
        parts: const [AiContentPart.text('hello')],
        createdAt: now,
      ),
    );

    await conversations.deleteConversation('conversation');

    expect(await conversations.getConversation('conversation'), isNull);
    expect(await conversations.getMessages('conversation'), isEmpty);
  });

  test('stores, paginates, trims and cascades script logs', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await scriptLogs.startRun(
      runId: 'run-1',
      conversationId: 'conversation',
      source: 'xposed',
      scriptName: 'hook.js',
      startedAt: now,
    );
    await scriptLogs.startRun(
      runId: 'run-active',
      conversationId: 'conversation',
      source: 'frida',
      scriptName: 'active.js',
      startedAt: now,
    );
    await scriptLogs.appendLogs([
      for (var index = 0; index < 3; index++)
        ScriptLogRecord(
          id: index,
          runId: 'run-1',
          conversationId: 'conversation',
          source: 'xposed',
          scriptName: 'hook.js',
          level: 'I',
          message: 'message-$index',
          stackTrace: '',
          timestamp: now.add(Duration(seconds: index)),
        ),
      ScriptLogRecord(
        id: 0,
        runId: 'run-active',
        conversationId: 'conversation',
        source: 'frida',
        scriptName: 'active.js',
        level: 'I',
        message: 'active-message',
        stackTrace: '',
        timestamp: now.subtract(const Duration(days: 60)),
      ),
    ]);

    final latest = await scriptLogs.getLogs(
      conversationId: 'conversation',
      runId: 'run-1',
      limit: 2,
    );
    final older = await scriptLogs.getLogs(
      conversationId: 'conversation',
      runId: 'run-1',
      before: latest.last.timestamp,
      beforeId: latest.last.id,
      limit: 2,
    );

    expect(latest.map((log) => log.message), ['message-2', 'message-1']);
    expect(older.map((log) => log.message), ['message-0']);

    await scriptLogs.finishRun(
      'run-1',
      status: 'stopped',
      finishedAt: now.add(const Duration(seconds: 3)),
    );
    await scriptLogs.trimLogs(olderThan: now.add(const Duration(seconds: 1)));
    expect(
      (await scriptLogs.getLogs(
        conversationId: 'conversation',
        runId: 'run-1',
      )).map((log) => log.message),
      ['message-2', 'message-1'],
    );
    expect(
      (await scriptLogs.getLogs(
        conversationId: 'conversation',
        runId: 'run-active',
      )).map((log) => log.message),
      ['active-message'],
    );

    await conversations.deleteConversation('conversation');
    expect(await scriptLogs.getLogs(conversationId: 'conversation'), isEmpty);
  });

  test(
    'keeps xposed logs after database reopen and isolates projects',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'jsxposedx-script-logs-',
      );
      final databaseFile = File('${tempDirectory.path}/logs.sqlite');
      addTearDown(() async {
        if (tempDirectory.existsSync()) {
          await tempDirectory.delete(recursive: true);
        }
      });

      final firstDatabase = AiDatabase.forTesting(NativeDatabase(databaseFile));
      final firstRepository = DriftScriptLogRepository(firstDatabase);
      final now = DateTime.utc(2026, 9, 24);
      for (final project in ['project-a', 'project-b']) {
        await firstRepository.startRun(
          runId: 'run-$project',
          conversationId: 'standalone:$project:xposed:hook.js[Java]',
          source: 'xposed',
          scriptName: 'hook.js[Java]',
          startedAt: now,
        );
        await firstRepository.appendLogs([
          ScriptLogRecord(
            id: 0,
            runId: 'run-$project',
            conversationId: 'standalone:$project:xposed:hook.js[Java]',
            source: 'xposed',
            scriptName: 'hook.js[Java]',
            level: 'I',
            message: 'log-$project',
            stackTrace: '',
            timestamp: now,
          ),
        ]);
      }
      await firstDatabase.close();

      final reopenedDatabase = AiDatabase.forTesting(
        NativeDatabase(databaseFile),
      );
      final reopenedRepository = DriftScriptLogRepository(reopenedDatabase);
      final projectALogs = await reopenedRepository.getLogs(
        conversationId: 'standalone:project-a:xposed:hook.js[Java]',
      );
      final projectBLogs = await reopenedRepository.getLogs(
        conversationId: 'standalone:project-b:xposed:hook.js[Java]',
      );

      expect(projectALogs.map((log) => log.message), ['log-project-a']);
      expect(projectBLogs.map((log) => log.message), ['log-project-b']);
      await reopenedDatabase.close();
    },
  );

  test('restores a persisted conversation context snapshot', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final snapshot = AiChatSessionContext(
      sessionRules: 'environment rules',
      sessionMemory: const AiChatSessionMemory(userGoals: ['goal']),
      taskState: const AiChatTaskState(lastUserGoal: 'goal', lastError: 'boom'),
      toolTrace: const AiToolExecutionTrace(
        toolCallIds: ['fc_1'],
        resultSummaries: {'fc_1': 'ok'},
      ),
      checkpoint: const AiChatCheckpoint(
        createdAtIso: '2026-09-05T00:00:00.000Z',
      ),
      stats: const AiChatContextStats(
        tokenBudget: 4096,
        estimatedTokens: 12,
        remainingTokens: 4084,
      ),
    );

    expect(await conversations.getConversationContext('conversation'), isNull);

    await conversations.saveConversationContext('conversation', snapshot);
    final restored = await conversations.getConversationContext('conversation');

    expect(restored, isNotNull);
    expect(restored!.toStorageJson(), snapshot.toStorageJson());
    expect(restored.checkpoint!.createdAtIso, '2026-09-05T00:00:00.000Z');
    expect(restored.stats.tokenBudget, 4096);
  });

  test('overwrites the previous snapshot for the same conversation', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await conversations.saveConversationContext(
      'conversation',
      const AiChatSessionContext(sessionRules: 'first'),
    );
    await conversations.saveConversationContext(
      'conversation',
      const AiChatSessionContext(sessionRules: 'second'),
    );

    final restored = await conversations.getConversationContext('conversation');
    expect(restored!.sessionRules, 'second');
  });

  test('refuses to persist a context for a missing conversation', () async {
    await expectLater(
      conversations.saveConversationContext(
        'missing',
        const AiChatSessionContext(),
      ),
      throwsStateError,
    );

    expect(await conversations.getConversationContext('missing'), isNull);
  });

  test('deletes the stored context with its conversation', () async {
    final now = DateTime.utc(2026, 9, 5);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await conversations.saveConversationContext(
      'conversation',
      const AiChatSessionContext(sessionRules: 'rules'),
    );

    await conversations.deleteConversation('conversation');

    expect(await conversations.getConversationContext('conversation'), isNull);
  });
}
