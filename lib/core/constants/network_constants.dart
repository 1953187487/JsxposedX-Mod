import 'package:JsxposedX/core/constants/app_constants.dart';

/// 网络请求相关常量配置
class NetworkConstants {
  NetworkConstants._();

  /// 默认基础路径设为空，允许直接在请求中传入完整路径
  static const String baseUrl = "";

  /// 连接超时
  static const Duration connectTimeout = AppConstants.requestTimeout;

  /// 发送超时
  static const Duration sendTimeout = AppConstants.requestTimeout;

  /// 接收超时
  static const Duration receiveTimeout = AppConstants.requestTimeout;

  /// 请求头相关
}

class NetworkHeaders {
  static const String contentType = "Content-Type";
  static const String accept = "Accept";
  static const String json = "application/json";
  static const String userAgent = "User-Agent";
}
