import 'package:JsxposedX/core/models/dialog_keyword.dart';

abstract class QuickFunctionsConfigQueryRepository {
  /// 获取快捷功能开关状态
  Future<bool> getQuickFunctionStatus({
    required String packageName,
    required String name,
  });

  /// 获取弹窗关键词列表
  Future<List<DialogKeyword>> getDialogKeywords({
    required String packageName,
    required String name,
  });
}
