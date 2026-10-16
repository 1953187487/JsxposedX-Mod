import 'package:drift/drift.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart';

class DriftScriptLogRepository implements ScriptLogRepository {
  const DriftScriptLogRepository(this._database);

  final AiDatabase _database;

  @override
  Future<void> recoverInterruptedRuns() async {
    await (_database.update(
      _database.scriptRuns,
    )..where((table) => table.status.equals('running'))).write(
      ScriptRunsCompanion(
        finishedAt: Value(DateTime.now().toUtc()),
        status: const Value('interrupted'),
      ),
    );
  }

  @override
  Future<ScriptRunRecord?> getRun(String runId) async {
    final row = await (_database.select(
      _database.scriptRuns,
    )..where((table) => table.runId.equals(runId))).getSingleOrNull();
    if (row == null) return null;
    return ScriptRunRecord(
      runId: row.runId,
      conversationId: row.conversationId,
      source: row.source,
      scriptName: row.scriptName,
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      status: row.status,
    );
  }

  @override
  Future<void> startRun({
    required String runId,
    required String conversationId,
    required String source,
    required String scriptName,
    required DateTime startedAt,
  }) async {
    await _database
        .into(_database.scriptRuns)
        .insertOnConflictUpdate(
          ScriptRunsCompanion.insert(
            runId: runId,
            conversationId: conversationId,
            source: source,
            scriptName: scriptName,
            startedAt: startedAt.toUtc(),
            status: 'running',
          ),
        );
  }

  @override
  Future<void> finishRun(
    String runId, {
    required String status,
    required DateTime finishedAt,
  }) async {
    await (_database.update(
      _database.scriptRuns,
    )..where((table) => table.runId.equals(runId))).write(
      ScriptRunsCompanion(
        finishedAt: Value(finishedAt.toUtc()),
        status: Value(status),
      ),
    );
  }

  @override
  Future<void> appendLogs(List<ScriptLogRecord> logs) async {
    if (logs.isEmpty) return;
    await _database.batch((batch) {
      batch.insertAll(
        _database.scriptLogs,
        logs
            .map(
              (log) => ScriptLogsCompanion.insert(
                runId: log.runId,
                conversationId: log.conversationId,
                source: log.source,
                scriptName: log.scriptName,
                level: log.level,
                message: log.message,
                stackTrace: log.stackTrace,
                timestamp: log.timestamp.toUtc(),
              ),
            )
            .toList(growable: false),
      );
    });
  }

  @override
  Future<List<ScriptLogRecord>> getLogs({
    required String conversationId,
    String? runId,
    String? scriptName,
    String? source,
    String? level,
    DateTime? before,
    int? beforeId,
    int limit = 100,
  }) async {
    final query = _database.select(_database.scriptLogs)
      ..where((table) {
        var predicate = table.conversationId.equals(conversationId);
        if (runId != null) predicate = predicate & table.runId.equals(runId);
        if (scriptName != null) {
          predicate = predicate & table.scriptName.equals(scriptName);
        }
        if (source != null) predicate = predicate & table.source.equals(source);
        if (level != null) predicate = predicate & table.level.equals(level);
        if (before != null) {
          final olderTimestamp = table.timestamp.isSmallerThanValue(
            before.toUtc(),
          );
          predicate = beforeId == null
              ? predicate & olderTimestamp
              : predicate &
                    (olderTimestamp |
                        (table.timestamp.equals(before.toUtc()) &
                            table.id.isSmallerThanValue(beforeId)));
        }
        return predicate;
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.timestamp),
        (row) => OrderingTerm.desc(row.id),
      ])
      ..limit(limit.clamp(1, 500));
    final rows = await query.get();
    return rows.map(_recordFromRow).toList(growable: false);
  }

  @override
  Future<List<ScriptLogRecord>> getStandaloneLogs({
    required String packageName,
    String? runId,
    String? scriptName,
    String? source,
    String? level,
    DateTime? before,
    int? beforeId,
    int limit = 100,
  }) async {
    final query = _database.select(_database.scriptLogs)
      ..where((table) {
        var predicate = table.conversationId.like('standalone:$packageName:%');
        if (runId != null) predicate = predicate & table.runId.equals(runId);
        if (scriptName != null) {
          predicate = predicate & table.scriptName.equals(scriptName);
        }
        if (source != null) predicate = predicate & table.source.equals(source);
        if (level != null) predicate = predicate & table.level.equals(level);
        if (before != null) {
          final olderTimestamp = table.timestamp.isSmallerThanValue(
            before.toUtc(),
          );
          predicate = beforeId == null
              ? predicate & olderTimestamp
              : predicate &
                    (olderTimestamp |
                        (table.timestamp.equals(before.toUtc()) &
                            table.id.isSmallerThanValue(beforeId)));
        }
        return predicate;
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.timestamp),
        (row) => OrderingTerm.desc(row.id),
      ])
      ..limit(limit.clamp(1, 500));
    final rows = await query.get();
    return rows.map(_recordFromRow).toList(growable: false);
  }

  @override
  Future<void> trimLogs({
    required DateTime olderThan,
    int maxRows = 50000,
  }) async {
    await _database.transaction(() async {
      await _database.customStatement(
        'DELETE FROM script_logs WHERE timestamp < ? AND run_id NOT IN '
        '(SELECT run_id FROM script_runs WHERE status = ?)',
        [olderThan.toUtc().millisecondsSinceEpoch ~/ 1000, 'running'],
      );
      await _database.customStatement(
        'DELETE FROM script_logs WHERE run_id NOT IN '
        '(SELECT run_id FROM script_runs WHERE status = ?) AND id NOT IN '
        '(SELECT id FROM script_logs ORDER BY timestamp DESC, id DESC LIMIT ?)',
        ['running', maxRows.clamp(1, 1000000)],
      );
      await _database.customStatement(
        'DELETE FROM script_runs WHERE run_id NOT IN '
        '(SELECT DISTINCT run_id FROM script_logs) AND status != ?',
        ['running'],
      );
    });
  }

  @override
  Future<void> deleteConversationLogs(String conversationId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.scriptLogs,
      )..where((table) => table.conversationId.equals(conversationId))).go();
      await (_database.delete(
        _database.scriptRuns,
      )..where((table) => table.conversationId.equals(conversationId))).go();
    });
  }

  ScriptLogRecord _recordFromRow(ScriptLog row) => ScriptLogRecord(
    id: row.id,
    runId: row.runId,
    conversationId: row.conversationId,
    source: row.source,
    scriptName: row.scriptName,
    level: row.level,
    message: row.message,
    stackTrace: row.stackTrace,
    timestamp: row.timestamp,
  );
}
