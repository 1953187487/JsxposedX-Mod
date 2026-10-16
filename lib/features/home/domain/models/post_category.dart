import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_category.freezed.dart';

@freezed
abstract class PostCategory with _$PostCategory {
  const PostCategory._();

  const factory PostCategory({
    required int id,
    required String name,
    required String icon,
    required String description,
    required int ranking,
  }) = _PostCategory;
}
