import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialog_keyword.freezed.dart';

@freezed
abstract class DialogKeyword with _$DialogKeyword {
  const DialogKeyword._();

  const factory DialogKeyword({
    required String keyword,
    required bool isCheck,
  }) = _DialogKeyword;
}
