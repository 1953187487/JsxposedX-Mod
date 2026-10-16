import 'package:JsxposedX/core/models/notice.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_dto.freezed.dart';

part 'notice_dto.g.dart';

@freezed
abstract class NoticeDto with _$NoticeDto {
  const NoticeDto._(); // 私有构造函数，用于添加自定义方法

  const factory NoticeDto({
    @Default(500) int code,
    @Default(MsgDto()) MsgDto msg,
    @Default('') String check,
  }) = _NoticeDto;

  factory NoticeDto.fromJson(Map<String, dynamic> json) =>
      _$NoticeDtoFromJson(json);

  Notice toEntity() {
    return Notice(code: code, msg: msg.toEntity(), check: check);
  }
}

@freezed
abstract class MsgDto with _$MsgDto {
  const MsgDto._(); // 私有构造函数，用于添加自定义方法

  const factory MsgDto({@JsonKey(name: "app_gg") @Default('') String content}) =
      _MsgDto;

  factory MsgDto.fromJson(Map<String, dynamic> json) => _$MsgDtoFromJson(json);

  Msg toEntity() {
    return Msg(content: content);
  }
}
