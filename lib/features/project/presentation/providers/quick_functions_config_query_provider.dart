import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:JsxposedX/features/project/data/datasources/quick_functions_config_query_datasource.dart';
import 'package:JsxposedX/features/project/data/repositories/quick_functions_config_query_repository_impl.dart';
import 'package:JsxposedX/features/project/domain/repositories/quick_functions_config_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_functions_config_query_provider.g.dart';

@riverpod
QuickFunctionsConfigQueryDataSource quickFunctionsConfigQueryDatasource(
  Ref ref,
) {
  return QuickFunctionsConfigQueryDataSource();
}

@riverpod
QuickFunctionsConfigQueryRepository quickFunctionsConfigQueryRepository(
  Ref ref,
) {
  final dataSource = ref.watch(quickFunctionsConfigQueryDatasourceProvider);
  return QuickFunctionsConfigQueryRepositoryImpl(dataSource: dataSource);
}

/// 获取快捷功能开关状态
@riverpod
Future<bool> getQuickFunctionStatus(
  Ref ref, {
  required String packageName,
  required String name,
}) async {
  return await ref
      .watch(quickFunctionsConfigQueryRepositoryProvider)
      .getQuickFunctionStatus(packageName: packageName, name: name);
}

/// 获取弹窗关键词列表
@riverpod
Future<List<DialogKeyword>> getDialogKeywords(
  Ref ref, {
  required String packageName,
  required String name,
}) async {
  return await ref
      .watch(quickFunctionsConfigQueryRepositoryProvider)
      .getDialogKeywords(packageName: packageName, name: name);
}
