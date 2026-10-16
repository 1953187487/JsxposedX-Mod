import 'dart:async';
import 'dart:convert';

class AiSseEvent {
  const AiSseEvent({required this.data, this.event, this.id, this.retry});

  final String data;
  final String? event;
  final String? id;
  final int? retry;
}

/// Incremental SSE parser. It never aggregates the whole HTTP response.
class AiSseDecoder {
  const AiSseDecoder({this.maxEventBytes = 1024 * 1024});

  final int maxEventBytes;

  Stream<AiSseEvent> decode(Stream<List<int>> bytes) async* {
    String? event;
    String? id;
    int? retry;
    final dataLines = <String>[];
    var eventBytes = 0;

    void reset() {
      event = null;
      id = null;
      retry = null;
      dataLines.clear();
      eventBytes = 0;
    }

    AiSseEvent? dispatch() {
      if (dataLines.isEmpty) {
        reset();
        return null;
      }
      final result = AiSseEvent(
        data: dataLines.join('\n'),
        event: event,
        id: id,
        retry: retry,
      );
      reset();
      return result;
    }

    await for (final line
        in utf8.decoder.bind(bytes).transform(const LineSplitter())) {
      if (line.isEmpty) {
        final result = dispatch();
        if (result != null) yield result;
        continue;
      }
      if (line.startsWith(':')) continue;

      final separator = line.indexOf(':');
      final field = separator < 0 ? line : line.substring(0, separator);
      var value = separator < 0 ? '' : line.substring(separator + 1);
      if (value.startsWith(' ')) value = value.substring(1);

      switch (field) {
        case 'event':
          event = value;
        case 'id':
          id = value;
        case 'retry':
          retry = int.tryParse(value);
        case 'data':
          eventBytes += utf8.encode(value).length + 1;
          if (eventBytes > maxEventBytes) {
            throw const FormatException('SSE event exceeds configured limit');
          }
          dataLines.add(value);
      }
    }

    final result = dispatch();
    if (result != null) yield result;
  }
}
