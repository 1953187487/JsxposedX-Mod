import 'dart:async';

import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';

class AiCancellationController implements AiCancellationToken {
  final Completer<void> _completer = Completer<void>();

  @override
  bool get isCancelled => _completer.isCompleted;

  @override
  Future<void> get cancelled => _completer.future;

  void cancel() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}
