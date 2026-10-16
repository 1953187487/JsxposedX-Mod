import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:JsxposedX/features/project/data/datasources/quick_functions_config_query_datasource.dart';
import 'package:JsxposedX/features/project/domain/repositories/quick_functions_config_query_repository.dart';

class QuickFunctionsConfigQueryRepositoryImpl
    implements QuickFunctionsConfigQueryRepository {
  final QuickFunctionsConfigQueryDataSource _dataSource;

  QuickFunctionsConfigQueryRepositoryImpl(
      {required QuickFunctionsConfigQueryDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<bool> getQuickFunctionStatus({
    required String packageName,
    required String name,
  }) async {
    return await _dataSource.getQuickFunctionStatus(
      packageName: packageName,
      name: name,
    );
  }

  @override
  Future<List<DialogKeyword>> getDialogKeywords({
    required String packageName,
    required String name,
  }) async {
    final dtos = await _dataSource.getDialogKeywords(
      packageName: packageName,
      name: name,
    );
    return dtos.map((e) => e.toEntity()).toList();
  }
}
