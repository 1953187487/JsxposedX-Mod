abstract interface class ScriptLogRepository {
  Future<void> recoverInterruptedRuns();

  Future<ScriptRunRecord?> getRun(String runId);

  Future<void> startRun({
    required String runId,
    required String conversationId,
    required String source,
    required String scriptName,
    required DateTime startedAt,
  });

  Future<void> finishRun(
    String runId, {
    required String status,
    required DateTime finishedAt,
  });

  Future<void> appendLogs(List<ScriptLogRecord> logs);

  Future<List<ScriptLogRecord>> getLogs({
    required String conversationId,
    String? runId,
    String? scriptName,
    String? source,
    String? level,
    DateTime? before,
    int? beforeId,
    int limit = 100,
  });

  Future<List<ScriptLogRecord>> getStandaloneLogs({
    required String packageName,
    String? runId,
    String? scriptName,
    String? source,
    String? level,
    DateTime? before,
    int? beforeId,
    int limit = 100,
  });

  Future<void> trimLogs({required DateTime olderThan, int maxRows = 50000});

  Future<void> deleteConversationLogs(String conversationId);
}

class ScriptRunRecord {
  const ScriptRunRecord({
    required this.runId,
    required this.conversationId,
    required this.source,
    required this.scriptName,
    required this.startedAt,
    required this.finishedAt,
    required this.status,
  });

  final String runId;
  final String conversationId;
  final String source;
  final String scriptName;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status;
}

class ScriptLogRecord {
  const ScriptLogRecord({
    required this.id,
    required this.runId,
    required this.conversationId,
    required this.source,
    required this.scriptName,
    required this.level,
    required this.message,
    required this.stackTrace,
    required this.timestamp,
  });

  final int id;
  final String runId;
  final String conversationId;
  final String source;
  final String scriptName;
  final String level;
  final String message;
  final String stackTrace;
  final DateTime timestamp;
}
