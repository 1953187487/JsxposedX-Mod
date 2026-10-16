import 'package:JsxposedX/features/home/domain/models/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_state.freezed.dart';

@freezed
abstract class PostState with _$PostState {
  const factory PostState({
    @Default([]) List<Post> rows,
    @Default(0) int currentPage,
    @Default(false) bool isLoading,
    @Default(true) bool hasMore,
  }) = _PostState;
}
