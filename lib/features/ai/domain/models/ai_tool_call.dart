import 'dart:convert';

typedef AiToolProgressCallback = void Function(String content);

/// 工具结果状态
enum AiToolStatus { ok, partial, error }

/// 标准错误码（封装标准 §4.1）
class AiToolErrorCode {
  AiToolErrorCode._();

  /// 参数缺失/格式非法
  static const eParam = 'E_PARAM';

  /// 目标（类/文件/so/应用）不存在
  static const eNotFound = 'E_NOT_FOUND';

  /// 需覆盖确认（同名文件等）
  static const eConflict = 'E_CONFLICT';

  /// 权限/审批拒绝/保留名
  static const eDenied = 'E_DENIED';

  /// 超时
  static const eTimeout = 'E_TIMEOUT';

  /// native 层异常（原样透传）
  static const eNative = 'E_NATIVE';

  /// 未预期内部错误
  static const eInternal = 'E_INTERNAL';
}

/// 工具执行元信息（封装标准 §1.2 meta）
class AiToolResultMeta {
  const AiToolResultMeta({
    this.truncated = false,
    this.totalSize = 0,
    this.nextPageToken,
    this.durationMs = 0,
    this.retryCount = 0,
    this.note,
  });

  /// 结果是否被截断
  final bool truncated;

  /// 原始结果字符数
  final int totalSize;

  /// 截断后的续读游标（truncated 时必填）
  final String? nextPageToken;

  /// 执行耗时（毫秒）
  final int durationMs;

  /// 自动重试次数
  final int retryCount;

  /// 降级提示等附加信息
  final String? note;

  Map<String, dynamic> toMap() => {
    'truncated': truncated,
    'totalSize': totalSize,
    if (nextPageToken != null) 'nextPageToken': nextPageToken,
    'durationMs': durationMs,
    'retryCount': retryCount,
    if (note != null) 'note': note,
  };
}

/// AI 发起的工具调用请求
class AiToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const AiToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });

  factory AiToolCall.fromJson(Map<String, dynamic> json) => AiToolCall(
    id: json['id'] as String? ?? '',
    name: json['function']?['name'] as String? ?? json['name'] as String? ?? '',
    arguments: _parseArguments(json),
  );

  static Map<String, dynamic> _parseArguments(Map<String, dynamic> json) {
    final args = json['function']?['arguments'] ?? json['arguments'];
    if (args is String) {
      try {
        return Map<String, dynamic>.from(jsonDecode(args) as Map);
      } catch (_) {
        return {};
      }
    }
    if (args is Map) return Map<String, dynamic>.from(args);
    return {};
  }

  /// 取参数值的便捷方法
  String getString(String key, [String defaultValue = '']) =>
      arguments[key]?.toString() ?? defaultValue;

  int getInt(String key, [int defaultValue = 0]) =>
      int.tryParse(arguments[key]?.toString() ?? '') ?? defaultValue;

  bool getBool(String key, [bool defaultValue = false]) =>
      arguments[key] == true || arguments[key]?.toString() == 'true';

  List<String> getStringList(String key) {
    final val = arguments[key];
    if (val is List) return val.map((e) => e.toString()).toList();
    return [];
  }
}

/// 工具执行结果（结构化信封，封装标准 §1.2）
class AiToolResult {
  final String toolCallId;
  final String toolName;
  final bool success;
  final String content;

  /// 结果状态：ok / partial（截断或部分成功）/ error
  final AiToolStatus status;

  /// 错误码（仅 error 时），取值见 [AiToolErrorCode]
  final String? errorCode;

  /// 结构化结果数据（LLM 可精确引用字段；旧工具为 null）
  final Map<String, dynamic>? data;

  /// 执行元信息（耗时/重试/截断等）
  final AiToolResultMeta meta;

  const AiToolResult({
    required this.toolCallId,
    required this.toolName,
    required this.success,
    required this.content,
    this.status = AiToolStatus.ok,
    this.errorCode,
    this.data,
    this.meta = const AiToolResultMeta(),
  });

  /// 成功结果
  factory AiToolResult.ok(String toolCallId, String toolName, String content) =>
      AiToolResult(
        toolCallId: toolCallId,
        toolName: toolName,
        success: true,
        content: content,
      );

  /// 截断的部分成功结果
  factory AiToolResult.partial(
    String toolCallId,
    String toolName, {
    required String truncatedContent,
    required int totalSize,
    required String nextPageToken,
  }) => AiToolResult(
    toolCallId: toolCallId,
    toolName: toolName,
    success: true,
    content: truncatedContent,
    status: AiToolStatus.partial,
    meta: AiToolResultMeta(
      truncated: true,
      totalSize: totalSize,
      nextPageToken: nextPageToken,
    ),
  );

  /// 失败结果（带标准错误码）
  factory AiToolResult.error(
    String toolCallId,
    String toolName,
    String error, {
    String errorCode = AiToolErrorCode.eInternal,
  }) => AiToolResult(
    toolCallId: toolCallId,
    toolName: toolName,
    success: false,
    content: error,
    status: AiToolStatus.error,
    errorCode: errorCode,
  );

  /// 错误内容视图：`[E_XXX] message`，便于桥接层透传给模型
  String get errorContent => errorCode == null || errorCode!.isEmpty
      ? content
      : '[$errorCode] $content';

  /// 转为 OpenAI tool message 格式
  Map<String, dynamic> toMessageJson() => {
    'role': 'tool',
    'tool_call_id': toolCallId,
    'content': success ? content : errorContent,
  };
}
