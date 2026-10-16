import 'dart:async';

import 'package:riverpod/legacy.dart';

class MemoryAiPendingInteractionOption {
  const MemoryAiPendingInteractionOption({
    required this.id,
    required this.label,
    this.description,
  });

  final String id;
  final String label;
  final String? description;
}

class MemoryAiPendingInteractionState {
  const MemoryAiPendingInteractionState({
    required this.toolName,
    required this.title,
    required this.description,
    required this.options,
    this.cancelLabel,
  });

  final String toolName;
  final String title;
  final String description;
  final List<MemoryAiPendingInteractionOption> options;
  final String? cancelLabel;
}

class MemoryAiPendingInteractionCancelled implements Exception {
  const MemoryAiPendingInteractionCancelled([this.message = '用户取消了当前操作。']);

  final String message;

  @override
  String toString() => message;
}

class MemoryAiPendingInteractionController
    extends StateNotifier<MemoryAiPendingInteractionState?> {
  MemoryAiPendingInteractionController() : super(null);

  Completer<String>? _pendingCompleter;

  Future<String> requestSingleChoice({
    required String toolName,
    required String title,
    required String description,
    required List<MemoryAiPendingInteractionOption> options,
    String? cancelLabel,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('options 不能为空');
    }

    _cancelActiveRequest(
      const MemoryAiPendingInteractionCancelled('新的待确认操作替换了当前操作。'),
    );

    final completer = Completer<String>();
    _pendingCompleter = completer;
    state = MemoryAiPendingInteractionState(
      toolName: toolName,
      title: title,
      description: description,
      options: List<MemoryAiPendingInteractionOption>.unmodifiable(options),
      cancelLabel: cancelLabel,
    );

    return completer.future.whenComplete(() {
      if (identical(_pendingCompleter, completer)) {
        _pendingCompleter = null;
        state = null;
      }
    });
  }

  void resolve(String optionId) {
    final completer = _pendingCompleter;
    if (completer == null || completer.isCompleted) {
      return;
    }
    completer.complete(optionId);
    _pendingCompleter = null;
    state = null;
  }

  void cancel([String? message]) {
    _cancelActiveRequest(
      MemoryAiPendingInteractionCancelled(message ?? '用户取消了当前操作。'),
    );
  }

  void _cancelActiveRequest(MemoryAiPendingInteractionCancelled error) {
    final completer = _pendingCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    }
    _pendingCompleter = null;
    state = null;
  }

  @override
  void dispose() {
    _cancelActiveRequest(
      const MemoryAiPendingInteractionCancelled('待确认操作已被关闭。'),
    );
    super.dispose();
  }
}

final memoryAiPendingInteractionProvider =
    StateNotifierProvider.family<
      MemoryAiPendingInteractionController,
      MemoryAiPendingInteractionState?,
      String
    >((ref, scopeId) {
      return MemoryAiPendingInteractionController();
    });
