import 'package:flutter/foundation.dart';

enum AiToolInvocationViewStatus { preparing, running, succeeded, failed, awaitingApproval }

@immutable
class AiToolInvocationView {
  const AiToolInvocationView({
    required this.callId,
    required this.name,
    required this.argumentsJson,
    required this.status,
    this.resultContent,
    this.requestedAt,
    this.completedAt,
  });

  final String callId;
  final String name;
  final String argumentsJson;
  final AiToolInvocationViewStatus status;
  final String? resultContent;
  final DateTime? requestedAt;
  final DateTime? completedAt;

  bool get hasArguments => argumentsJson.trim().isNotEmpty;

  bool get hasResult => resultContent?.trim().isNotEmpty ?? false;

  bool get isRunning =>
      status == AiToolInvocationViewStatus.preparing ||
      status == AiToolInvocationViewStatus.running ||
      status == AiToolInvocationViewStatus.awaitingApproval;

  bool get success => status == AiToolInvocationViewStatus.succeeded;

  Duration? get duration {
    final start = requestedAt;
    final end = completedAt;
    if (start == null || end == null || end.isBefore(start)) return null;
    return end.difference(start);
  }
}
