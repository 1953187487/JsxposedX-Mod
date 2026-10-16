import 'package:JsxposedX/core/models/dialog_keyword.dart';

abstract class QuickFunctionsConfigActionRepository {
  /// 设置快捷功能开关状态
  Future<void> setQuickFunctionStatus({
    required String packageName,
    required String name,
    required bool status,
  });

  /// 设置弹窗关键词列表（完整覆盖）
  Future<void> setDialogKeywords({
    required String packageName,
    required String name,
    required List<DialogKeyword> keywords,
  });

  /// 添加一个关键词
  Future<void> addDialogKeyword({
    required String packageName,
    required String name,
    required DialogKeyword keyword,
  });

  /// 删除一个关键词
  Future<void> removeDialogKeyword({
    required String packageName,
    required String name,
    required String keyword,
  });

  /// 更新关键词选中状态
  Future<void> updateDialogKeywordCheck({
    required String packageName,
    required String name,
    required String keyword,
    required bool isCheck,
  });

  /// 清空关键词列表
  Future<void> clearDialogKeywords({
    required String packageName,
    required String name,
  });
}

