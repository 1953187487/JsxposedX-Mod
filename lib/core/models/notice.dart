import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';

@freezed
abstract class Notice with _$Notice {
  const Notice._(); // 私有构造函数，用于添加自定义方法

  const factory Notice({
    required int code,
    required Msg msg,
    required String check,
  }) = _Notice;
}

@freezed
abstract class Msg with _$Msg {
  const Msg._(); // 私有构造函数，用于添加自定义方法

  const factory Msg({required String content}) = _Msg;
}
