import 'dart:convert';
import 'dart:developer' as developer;

import 'package:JsxposedX/core/constants/network_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 应用级 HTTP 拦截器
/// 负责补充通用请求信息，并输出简洁的请求摘要日志
class HttpInterceptor extends Interceptor {
  static const _requestStartTimeKey = 'request_start_time';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_requestStartTimeKey] = DateTime.now().millisecondsSinceEpoch;
    options.headers.putIfAbsent(
      NetworkHeaders.accept,
      () => NetworkHeaders.json,
    );

    final contentType = options.headers[NetworkHeaders.contentType];
    if (contentType == null &&
        options.data != null &&
        options.data is! FormData) {
      options.headers[NetworkHeaders.contentType] = NetworkHeaders.json;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printSummary(
      options: response.requestOptions,
      statusCode: response.statusCode,
      responseData: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _printSummary(
      options: err.requestOptions,
      statusCode: err.response?.statusCode,
      error: err.message,
      responseData: err.response?.data,
    );
    handler.next(err);
  }

  void _printSummary({
    required RequestOptions options,
    int? statusCode,
    Object? error,
    Object? responseData,
  }) {
    if (!kDebugMode) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('[HTTP] ${options.method.toUpperCase()} ${options.uri}');

    final metaParts = <String>[
      if (statusCode != null) 'Status: $statusCode',
      if (_resolveDurationMs(options) case final durationMs?)
        'Duration: ${durationMs}ms',
      if (_hasValue(error)) 'Error: $error',
    ];

    if (metaParts.isNotEmpty) {
      buffer.writeln(metaParts.join(' | '));
    }

    _writeSection(
      buffer,
      label: 'Headers',
      value: _sanitizeValue(options.headers),
    );
    _writeSection(
      buffer,
      label: 'Params',
      value: _sanitizeValue(options.queryParameters),
    );
    _writeSection(
      buffer,
      label: 'Body',
      value: _sanitizeValue(_normalizeRequestData(options.data)),
    );
    _writeSection(
      buffer,
      label: 'Response',
      value: _sanitizeValue(responseData),
    );

    developer.log(buffer.toString().trimRight(), name: 'HttpInterceptor');
  }

  void _writeSection(
    StringBuffer buffer, {
    required String label,
    required Object? value,
  }) {
    if (!_hasValue(value)) {
      return;
    }
    buffer.writeln('$label: ${_formatObject(value)}');
  }

  int? _resolveDurationMs(RequestOptions options) {
    final startTime = options.extra[_requestStartTimeKey];
    if (startTime is! int) {
      return null;
    }
    return DateTime.now().millisecondsSinceEpoch - startTime;
  }

  Object? _normalizeRequestData(Object? data) {
    if (data is! FormData) {
      return data;
    }
    return <String, Object?>{
      'fields': {for (final field in data.fields) field.key: field.value},
      'files': [
        for (final file in data.files)
          {
            'field': file.key,
            'filename': file.value.filename,
            'contentType': file.value.contentType?.toString(),
          },
      ],
    };
  }

  Object? _sanitizeValue(Object? value) {
    if (value is Map) {
      final entries = value.entries
          .map(
            (entry) => MapEntry(
              entry.key,
              _isSensitiveKey(entry.key)
                  ? '[REDACTED]'
                  : _sanitizeValue(entry.value),
            ),
          )
          .where((entry) => _hasValue(entry.value));
      final sanitized = <Object?, Object?>{
        for (final entry in entries) entry.key: entry.value,
      };
      return sanitized.isEmpty ? null : sanitized;
    }

    if (value is Iterable) {
      final sanitized = [
        for (final item in value)
          if (_hasValue(_sanitizeValue(item))) _sanitizeValue(item),
      ];
      return sanitized.isEmpty ? null : sanitized;
    }

    if (value is String && value.isEmpty) {
      return null;
    }

    return value;
  }

  bool _isSensitiveKey(Object? key) {
    final normalized = key?.toString().toLowerCase() ?? '';
    return normalized == 'authorization' ||
        normalized == 'proxy-authorization' ||
        normalized.contains('api-key') ||
        normalized.contains('apikey') ||
        normalized.contains('token') ||
        normalized.contains('secret') ||
        normalized == 'cookie' ||
        normalized == 'set-cookie';
  }

  bool _hasValue(Object? value) {
    if (value == null) {
      return false;
    }
    if (value is String) {
      return value.isNotEmpty;
    }
    if (value is Map) {
      return value.isNotEmpty;
    }
    if (value is Iterable) {
      return value.isNotEmpty;
    }
    return true;
  }

  String _formatObject(Object? value) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    } catch (_) {
      return value.toString();
    }
  }
}
