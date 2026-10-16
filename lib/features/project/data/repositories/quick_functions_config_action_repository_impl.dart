import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:JsxposedX/features/project/data/datasources/quick_functions_config_action_datasource.dart';
import 'package:JsxposedX/features/project/data/models/dialog_keyword_dto.dart';
import 'package:JsxposedX/features/project/domain/repositories/quick_functions_config_action_repository.dart';
import 'package:JsxposedX/features/project/domain/repositories/quick_functions_config_query_repository.dart';

class QuickFunctionsConfigActionRepositoryImpl
    implements QuickFunctionsConfigActionRepository {
  final QuickFunctionsConfigActionDataSource _dataSource;
  final QuickFunctionsConfigQueryRepository _queryRepository;

  QuickFunctionsConfigActionRepositoryImpl({
    required QuickFunctionsConfigActionDataSource dataSource,
    required QuickFunctionsConfigQueryRepository queryRepository,
  })  : _dataSource = dataSource,
        _queryRepository = queryRepository;

  @override
  Future<void> setQuickFunctionStatus({
    required String packageName,
    required String name,
    required bool status,
  }) async {
    await _dataSource.setQuickFunctionStatus(
      packageName: packageName,
      name: name,
      status: status,
    );
  }

  @override
  Future<void> setDialogKeywords({
    required String packageName,
    required String name,
    required List<DialogKeyword> keywords,
  }) async {
    final dtos = keywords
        .map((e) => DialogKeywordDto(keyword: e.keyword, isCheck: e.isCheck))
        .toList();
    await _dataSource.setDialogKeywords(
      packageName: packageName,
      name: name,
      keywords: dtos,
    );
  }

  @override
  Future<void> addDialogKeyword({
    required String packageName,
    required String name,
    required DialogKeyword keyword,
  }) async {
    final currentKeywords = await _queryRepository.getDialogKeywords(
      packageName: packageName,
      name: name,
    );
    if (!currentKeywords.any((e) => e.keyword == keyword.keyword)) {
      await setDialogKeywords(
        packageName: packageName,
        name: name,
        keywords: [...currentKeywords, keyword],
      );
    }
  }

  @override
  Future<void> removeDialogKeyword({
    required String packageName,
    required String name,
    required String keyword,
  }) async {
    final currentKeywords = await _queryRepository.getDialogKeywords(
      packageName: packageName,
      name: name,
    );
    final updated = currentKeywords.where((e) => e.keyword != keyword).toList();
    await setDialogKeywords(
      packageName: packageName,
      name: name,
      keywords: updated,
    );
  }

  @override
  Future<void> updateDialogKeywordCheck({
    required String packageName,
    required String name,
    required String keyword,
    required bool isCheck,
  }) async {
    final currentKeywords = await _queryRepository.getDialogKeywords(
      packageName: packageName,
      name: name,
    );
    final updated = currentKeywords.map((e) {
      if (e.keyword == keyword) {
        return e.copyWith(isCheck: isCheck);
      }
      return e;
    }).toList();
    await setDialogKeywords(
      packageName: packageName,
      name: name,
      keywords: updated,
    );
  }

  @override
  Future<void> clearDialogKeywords({
    required String packageName,
    required String name,
  }) async {
    await _dataSource.setDialogKeywords(
      packageName: packageName,
      name: name,
      keywords: [],
    );
  }
}
