import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_user.freezed.dart';

@freezed
abstract class CommonUser with _$CommonUser {
  const CommonUser._();

  const factory CommonUser({
    required int id,
    required String mxid,
    required String nickname,
    required String avatarUrl,
    required String description,
    required int gender,
    required int exp,
    required bool isVip,
    required bool isCert,
    required bool isOnline,
    required List<int> group,
  }) = _CommonUser;
}
