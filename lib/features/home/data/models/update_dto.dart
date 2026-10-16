import 'package:JsxposedX/core/models/update.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_dto.freezed.dart';

part 'update_dto.g.dart';

@freezed
abstract class UpdateDto with _$UpdateDto {
  const UpdateDto._(); // 私有构造函数，用于添加自定义方法

  const factory UpdateDto({
    @Default(500) int code,
    @Default(UpdateMsgDto()) UpdateMsgDto msg,
    @Default('') String check,
  }) = _UpdateDto;

  factory UpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateDtoFromJson(json);

  Update toEntity() => Update(code: code, msg: msg.toEntity(), check: check);
}

@freezed
abstract class UpdateMsgDto with _$UpdateMsgDto {
  const UpdateMsgDto._(); // 私有构造函数，用于添加自定义方法

  const factory UpdateMsgDto({
    @Default('-1') String version,
    @JsonKey(name: "app_update_url") @Default('') String url,
    @JsonKey(name: "app_update_show") @Default('') String content,
    @JsonKey(name: "app_update_must") @Default('') String mustUpdate,
  }) = _UpdateMsgDto;

  factory UpdateMsgDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMsgDtoFromJson(json);

  UpdateMsg toEntity() => UpdateMsg(
    version: version,
    url: url,
    content: content,
    mustUpdate: mustUpdate,
  );
}
