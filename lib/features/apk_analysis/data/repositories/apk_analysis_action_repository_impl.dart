import 'package:JsxposedX/features/apk_analysis/data/datasources/apk_analysis_action_datasource.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_action_repository.dart';

class ApkAnalysisActionRepositoryImpl implements ApkAnalysisActionRepository {
  final ApkAnalysisActionDatasource _dataSource;

  ApkAnalysisActionRepositoryImpl({required ApkAnalysisActionDatasource dataSource})
      : _dataSource = dataSource;

  @override
  Future<String> openApkSession(String packageName) =>
      _dataSource.openApkSession(packageName);

  @override
  Future<void> closeApkSession(String sessionId) =>
      _dataSource.closeApkSession(sessionId);
}
