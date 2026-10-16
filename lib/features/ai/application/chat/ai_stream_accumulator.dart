import 'dart:async';

import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

/// Converts high-frequency protocol events into bounded-rate UI snapshots.
class AiStreamAccumulator {
  AiStreamAccumulator({
    required this.requestId,
    this.publishInterval = const Duration(milliseconds: 50),
  }) : _snapshot = AiStreamSnapshot(requestId: requestId);

  final String requestId;
  final Duration publishInterval;
  final StreamController<AiStreamSnapshot> _snapshots =
      StreamController<AiStreamSnapshot>.broadcast(sync: true);
  final StringBuffer _text = StringBuffer();
  final StringBuffer _reasoning = StringBuffer();
  final Map<int, _MutableToolCall> _toolCalls = {};
  
  DateTime? _reasoningStartTime;
  Duration? _reasoningDuration;

  late AiStreamSnapshot _snapshot;
  Timer? _publishTimer;
  AiUsage? _usage;
  AiStreamStatus _status = AiStreamStatus.idle;
  AiFinishReason? _finishReason;
  AiFailure? _failure;
  AiTransportTrace? _transportTrace;
  int _sequence = -1;
  bool _dirty = false;
  bool _closed = false;

  Stream<AiStreamSnapshot> get snapshots => _snapshots.stream;

  AiStreamSnapshot get currentSnapshot => _snapshot;

  int get lastSequence => _sequence;

  bool get isTerminal =>
      _status == AiStreamStatus.completed || _status == AiStreamStatus.failed;

  void add(AiStreamEvent event) {
    if (_closed) {
      throw StateError('Cannot add events after the accumulator is closed');
    }
    if (event.requestId != requestId) {
      throw StateError(
        'Stream event belongs to ${event.requestId}, expected $requestId',
      );
    }
    if (isTerminal) {
      throw StateError('Cannot add events after a terminal event');
    }
    if (event.sequence <= _sequence) {
      throw StateError(
        'Stream event sequence ${event.sequence} is not greater than $_sequence',
      );
    }
    _sequence = event.sequence;

    switch (event) {
      case AiResponseStarted():
        _status = AiStreamStatus.streaming;
        _markDirty(immediate: true);
      case AiTextDelta(:final delta):
        if (_reasoningStartTime != null && _reasoningDuration == null) {
          _reasoningDuration = DateTime.now().difference(_reasoningStartTime!);
        }
        _text.write(delta);
        // Publish text immediately. A provider may deliver many SSE events in
        // one HTTP chunk; timer-only coalescing would make the UI appear to
        // render the entire answer at once.
        _markDirty(immediate: true);
      case AiReasoningDelta(:final delta):
        _reasoningStartTime ??= DateTime.now();
        _reasoning.write(delta);
        _markDirty(immediate: true);
      case AiToolCallDelta(
        :final index,
        :final toolCallId,
        :final name,
        :final argumentsDelta,
      ):
        final call = _toolCalls.putIfAbsent(
          index,
          () => _MutableToolCall(index),
        );
        if (call.id == null && toolCallId != null && toolCallId.isNotEmpty) {
          call.id = toolCallId;
        }
        if (name != null && name.isNotEmpty) {
          call.name = name;
        }
        if (argumentsDelta != null && argumentsDelta.isNotEmpty) {
          call.arguments.write(argumentsDelta);
        }
        _markDirty();
      case AiUsageUpdated(:final value):
        _usage = value;
        _markDirty();
      case AiResponseCompleted(:final reason):
        if (_reasoningStartTime != null && _reasoningDuration == null) {
          _reasoningDuration = DateTime.now().difference(_reasoningStartTime!);
        }
        _status = AiStreamStatus.completed;
        _finishReason = reason;
        _markDirty(immediate: true);
      case AiResponseFailed(:final failure):
        if (_reasoningStartTime != null && _reasoningDuration == null) {
          _reasoningDuration = DateTime.now().difference(_reasoningStartTime!);
        }
        _status = AiStreamStatus.failed;
        _failure = failure;
        _markDirty(immediate: true);
    }
  }

  void updateTransportTrace(AiTransportTrace trace) {
    if (_closed) return;
    _transportTrace = trace;
    _markDirty(immediate: true);
  }

  void flush() {
    if (_closed || !_dirty) return;
    _publishTimer?.cancel();
    _publishTimer = null;
    _snapshot = AiStreamSnapshot(
      requestId: requestId,
      sequence: _sequence,
      status: _status,
      text: _text.toString(),
      reasoning: _reasoning.toString(),
      reasoningDuration: _reasoningDuration,
      toolCalls: _toolCalls.values
          .map((call) => call.toSnapshot())
          .toList(growable: false),
      usage: _usage,
      finishReason: _finishReason,
      failure: _failure,
      transportTrace: _transportTrace,
    );
    _dirty = false;
    _snapshots.add(_snapshot);
  }

  Future<void> close() async {
    if (_closed) return;
    flush();
    _closed = true;
    _publishTimer?.cancel();
    _publishTimer = null;
    await _snapshots.close();
  }

  void _markDirty({bool immediate = false}) {
    _dirty = true;
    if (immediate || publishInterval == Duration.zero) {
      flush();
      return;
    }
    _publishTimer ??= Timer(publishInterval, flush);
  }
}

class _MutableToolCall {
  _MutableToolCall(this.index);

  final int index;
  String? id;
  String name = '';
  final StringBuffer arguments = StringBuffer();

  AiToolCallSnapshot toSnapshot() => AiToolCallSnapshot(
    index: index,
    id: id,
    name: name,
    argumentsJson: arguments.toString(),
  );
}
