import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/common_user.dart';

part 'common_user_dto.freezed.dart';

part 'common_user_dto.g.dart';

@freezed
abstract class CommonUserDto with _$CommonUserDto {
  const CommonUserDto._();

  const factory CommonUserDto({
    @Default(0) int id,
    @Default("") String mxid,
    @Default("") String nickname,
    @Default("") String avatarUrl,
    @Default("") String description,
    @Default(0) int gender,
    @Default(0) int exp,
    @Default(false) bool isVip,
    @Default(false) bool isCert,
    @Default(false) bool isOnline,
    @Default([]) List<int> group,
  }) = _CommonUserDto;

  factory CommonUserDto.fromJson(Map<String, dynamic> json) =>
      _$CommonUserDtoFromJson(json);

  CommonUser toEntity() {
    return CommonUser(
      id: id,
      mxid: mxid,
      nickname: nickname,
      avatarUrl: avatarUrl,
      description: description,
      gender: gender,
      exp: exp,
      isVip: isVip,
      isCert: isCert,
      isOnline: isOnline,
      group: group,
    );
  }
}
