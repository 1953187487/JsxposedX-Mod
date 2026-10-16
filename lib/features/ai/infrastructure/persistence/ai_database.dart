import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'ai_database.g.dart';

class AiProviderConnections extends Table {
  TextColumn get id => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiModelDefinitions extends Table {
  TextColumn get connectionId => text()();
  TextColumn get modelId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {connectionId, modelId};
}

class AiAssistantProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get connectionId => text()();
  TextColumn get modelId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiConversations extends Table {
  TextColumn get id => text()();
  TextColumn get assistantId => text()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiMessageRecords extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// 对话级上下文快照：一个对话（conversationId）一行，保存该对话内的
/// 上下文状态变量（会话规则、工具执行轨迹、任务状态、组装统计），
/// 使对话关闭或进程重启后重新进入仍能恢复上下文，且不跨对话混淆。
class AiConversationContexts extends Table {
  TextColumn get conversationId => text()();
  IntColumn get contextVersion => integer()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {conversationId};
}

class ScriptRuns extends Table {
  TextColumn get runId => text()();
  TextColumn get conversationId => text()();
  TextColumn get source => text()();
  TextColumn get scriptName => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {runId};
}

class ScriptLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get runId => text()();
  TextColumn get conversationId => text()();
  TextColumn get source => text()();
  TextColumn get scriptName => text()();
  TextColumn get level => text()();
  TextColumn get message => text()();
  TextColumn get stackTrace => text()();
  DateTimeColumn get timestamp => dateTime()();
}

@DriftDatabase(
  tables: [
    AiProviderConnections,
    AiModelDefinitions,
    AiAssistantProfiles,
    AiConversations,
    AiMessageRecords,
    AiConversationContexts,
    ScriptRuns,
    ScriptLogs,
  ],
)
class AiDatabase extends _$AiDatabase {
  AiDatabase() : super(_openConnection());

  AiDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX script_logs_conversation_timestamp_idx '
        'ON script_logs (conversation_id, timestamp)',
      );
      await customStatement(
        'CREATE INDEX script_logs_run_timestamp_idx '
        'ON script_logs (run_id, timestamp)',
      );
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(aiConversationContexts);
      }
      if (from < 3) {
        await migrator.createTable(scriptRuns);
        await migrator.createTable(scriptLogs);
        await customStatement(
          'CREATE INDEX script_logs_conversation_timestamp_idx '
          'ON script_logs (conversation_id, timestamp)',
        );
        await customStatement(
          'CREATE INDEX script_logs_run_timestamp_idx '
          'ON script_logs (run_id, timestamp)',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'jsxposedx_ai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
