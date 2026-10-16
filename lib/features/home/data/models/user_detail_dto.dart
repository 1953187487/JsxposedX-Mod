import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/user_detail.dart';

part 'user_detail_dto.freezed.dart';
part 'user_detail_dto.g.dart';

@freezed
abstract class UserDetailDto with _$UserDetailDto {
  const UserDetailDto._();

  const factory UserDetailDto({
    @Default(0) int id,
    @Default("") String mxid,
    @Default("") String nickname,
    @Default("") String avatarUrl,
    @Default("") String description,
    @Default("") String cover,
    @Default(false) bool isVip,
    @Default(0) int vipEndTime,
    @Default(false) bool isCert,
    @Default(0) int exp,
    @Default(0) int gender,
    @Default("") String email,
    @Default(false) bool isOnline,
    @Default(false) bool isFollowing,
    @Default([]) List<int> group,
  }) = _UserDetailDto;

  factory UserDetailDto.fromJson(Map<String, dynamic> json) =>
      _$UserDetailDtoFromJson(json);

  UserDetail toEntity() {
    return UserDetail(
      id: id,
      mxid: mxid,
      nickname: nickname,
      avatarUrl: avatarUrl,
      description: description,
      cover: cover,
      isVip: isVip,
      vipEndTime: vipEndTime,
      isCert: isCert,
      exp: exp,
      gender: gender,
      email: email,
      isOnline: isOnline,
      isFollowing: isFollowing,
      group: group,
    );
  }
}
