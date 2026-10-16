import 'package:JsxposedX/features/home/domain/models/common_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_detail.freezed.dart';

@freezed
abstract class UserDetail with _$UserDetail {
  const UserDetail._();

  const factory UserDetail({
    required int id,
    required String mxid,
    required String nickname,
    required String avatarUrl,
    required String description,
    required String cover,
    required bool isVip,
    required int vipEndTime,
    required bool isCert,
    required int exp,
    required int gender,
    required String email,
    required bool isOnline,
    required bool isFollowing,
    required List<int> group,
  }) = _UserDetail;

  CommonUser toCommonUser() {
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
