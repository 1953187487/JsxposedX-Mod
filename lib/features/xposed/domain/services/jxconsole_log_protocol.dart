/// JXCONSOLE 结构化脚本日志协议。
///
/// v1：`JXCONSOLE|v1|<source>|<scriptName>|<level>|<message>`
/// v2：`JXCONSOLE|v2|<source>|<runId>|<scriptName>|<level>|<message>`
///
/// v2 在脚本名之前插入 runId，使每条日志都能归属到一次具体的脚本执行，
/// 从而支持把脚本日志绑定到对应的对话场景。v1 继续兼容解析，此时 runId 为空。
class JxConsoleLogRecord {
  const JxConsoleLogRecord({
    required this.protocolVersion,
    required this.source,
    required this.runId,
    required this.scriptName,
    required this.level,
    required this.message,
    required this.stackTrace,
  });

  final String protocolVersion;
  final String source;
  final String runId;
  final String scriptName;
  final String level;
  final String message;
  final String stackTrace;

  bool get hasRunId => runId.isNotEmpty;

  bool get hasStackTrace => stackTrace.isNotEmpty;
}

class JxConsoleLogProtocol {
  const JxConsoleLogProtocol();

  static const String marker = 'JXCONSOLE';
  static const String prefix = '$marker|';
  static const String stackSeparator = '\n--STACK--\n';

  /// v1 至少 `marker|版本|source|脚本名|级别|消息` 六段，v2 多一段 runId。
  static const int _v1MinParts = 6;
  static const int _v2MinParts = 7;

  /// 解析一行结构化日志；不是本协议或格式不完整时返回 null。
  JxConsoleLogRecord? parse(String message) {
    if (!message.startsWith(prefix)) return null;
    final parts = message.split('|');
    final version = parts.length > 1 ? parts[1] : '';
    switch (version) {
      case 'v1':
        if (parts.length < _v1MinParts) return null;
        return _build(
          version: version,
          source: parts[2],
          runId: '',
          scriptName: _decode(parts[3]),
          level: parts[4],
          payload: parts.sublist(5),
        );
      case 'v2':
        if (parts.length < _v2MinParts) return null;
        return _build(
          version: version,
          source: parts[2],
          runId: _decode(parts[3]),
          scriptName: _decode(parts[4]),
          level: parts[5],
          payload: parts.sublist(6),
        );
      default:
        return null;
    }
  }

  JxConsoleLogRecord _build({
    required String version,
    required String source,
    required String runId,
    required String scriptName,
    required String level,
    required List<String> payload,
  }) {
    final decoded = _decode(payload.join('|'));
    final separator = decoded.indexOf(stackSeparator);
    return JxConsoleLogRecord(
      protocolVersion: version,
      source: source,
      runId: runId,
      scriptName: scriptName,
      level: level.isEmpty ? 'I' : level,
      message: separator < 0
          ? decoded
          : decoded.substring(0, separator),
      stackTrace: separator < 0
          ? ''
          : decoded.substring(separator + stackSeparator.length),
    );
  }

  String _decode(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      return value;
    }
  }
}
