import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:JsxposedX/features/project/data/datasources/quick_functions_config_action_datasource.dart';
import 'package:JsxposedX/features/project/data/repositories/quick_functions_config_action_repository_impl.dart';
import 'package:JsxposedX/features/project/domain/repositories/quick_functions_config_action_repository.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_functions_config_action_provider.g.dart';

@riverpod
QuickFunctionsConfigActionDataSource quickFunctionsConfigActionDatasource(
    Ref ref) {
  return QuickFunctionsConfigActionDataSource();
}

@riverpod
QuickFunctionsConfigActionRepository quickFunctionsConfigActionRepository(
    Ref ref) {
  final dataSource = ref.watch(quickFunctionsConfigActionDatasourceProvider);
  final queryRepository = ref.watch(quickFunctionsConfigQueryRepositoryProvider);
  return QuickFunctionsConfigActionRepositoryImpl(
    dataSource: dataSource,
    queryRepository: queryRepository,
  );
}

/// 设置快捷功能开关状态
@riverpod
Future<void> setQuickFunctionStatus(
  Ref ref, {
  required String packageName,
  required String name,
  required bool status,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .setQuickFunctionStatus(
        packageName: packageName,
        name: name,
        status: status,
      );
}

/// 设置弹窗关键词列表
@riverpod
Future<void> setDialogKeywords(
  Ref ref, {
  required String packageName,
  required String name,
  required List<DialogKeyword> keywords,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .setDialogKeywords(
        packageName: packageName,
        name: name,
        keywords: keywords,
      );
}

/// 添加一个弹窗关键词
@riverpod
Future<void> addDialogKeyword(
  Ref ref, {
  required String packageName,
  required String name,
  required DialogKeyword keyword,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .addDialogKeyword(
        packageName: packageName,
        name: name,
        keyword: keyword,
      );
}

/// 删除一个弹窗关键词
@riverpod
Future<void> removeDialogKeyword(
  Ref ref, {
  required String packageName,
  required String name,
  required String keyword,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .removeDialogKeyword(
        packageName: packageName,
        name: name,
        keyword: keyword,
      );
}

/// 更新关键词选中状态
@riverpod
Future<void> updateDialogKeywordCheck(
  Ref ref, {
  required String packageName,
  required String name,
  required String keyword,
  required bool isCheck,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .updateDialogKeywordCheck(
        packageName: packageName,
        name: name,
        keyword: keyword,
        isCheck: isCheck,
      );
}

/// 清空关键词列表
@riverpod
Future<void> clearDialogKeywords(
  Ref ref, {
  required String packageName,
  required String name,
}) async {
  await ref
      .read(quickFunctionsConfigActionRepositoryProvider)
      .clearDialogKeywords(
        packageName: packageName,
        name: name,
      );
}
