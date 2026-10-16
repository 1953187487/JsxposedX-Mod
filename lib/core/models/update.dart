import 'package:freezed_annotation/freezed_annotation.dart';

part 'update.freezed.dart';

@freezed
abstract class Update with _$Update {
  const Update._(); // 私有构造函数，用于添加自定义方法

  const factory Update({
    required int code,
    required UpdateMsg msg,
    required String check,
  }) = _Update;
}

@freezed
abstract class UpdateMsg with _$UpdateMsg {
  const UpdateMsg._(); // 私有构造函数，用于添加自定义方法

  const factory UpdateMsg({
    required String version,
    required String url,
    required String content,
    required String mustUpdate,
  }) = _UpdateMsg;
}
