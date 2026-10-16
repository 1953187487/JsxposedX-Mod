import 'package:flutter/foundation.dart';

/// AI 向用户提出的单个选项。
@immutable
class AiQuestionOption {
  const AiQuestionOption({required this.label, this.detail});

  /// 选项正文，也是用户作答时回传的内容。
  final String label;

  /// 可选的补充说明。
  final String? detail;

  @override
  bool operator ==(Object other) =>
      other is AiQuestionOption &&
      other.label == label &&
      other.detail == detail;

  @override
  int get hashCode => Object.hash(label, detail);

  @override
  String toString() => 'AiQuestionOption($label)';
}

/// AI 在问答模式下抛给用户的问题。
///
/// [multiple] 由 AI 在协议里声明：为 true 时用户可勾选多项后一起提交，
/// 否则为单选，点选即作答。[options] 为空表示这是一道纯开放题，用户直接
/// 用输入框文字作答。
@immutable
class AiQuestion {
  const AiQuestion({
    required this.prompt,
    this.options = const [],
    this.multiple = false,
  });

  final String prompt;
  final List<AiQuestionOption> options;
  final bool multiple;

  bool get isOpenEnded => options.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is AiQuestion &&
      other.prompt == prompt &&
      other.multiple == multiple &&
      listEquals(other.options, options);

  @override
  int get hashCode => Object.hash(prompt, multiple, Object.hashAll(options));

  @override
  String toString() => 'AiQuestion($prompt, options=${options.length})';
}
