import 'package:JsxposedX/features/apk_analysis/data/datasources/apk_analysis_query_datasource.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_query_repository.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';

class ApkAnalysisQueryRepositoryImpl implements ApkAnalysisQueryRepository {
  final ApkAnalysisQueryDatasource _dataSource;

  ApkAnalysisQueryRepositoryImpl({required ApkAnalysisQueryDatasource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<ApkAsset>> getApkAssets(String sessionId) async =>
      await _dataSource.getApkAssets(sessionId);

  @override
  Future<List<ApkAsset>> getApkAssetsAt(String sessionId, String path) async =>
      await _dataSource.getApkAssetsAt(sessionId, path);

  @override
  Future<ApkManifest> parseManifest(String sessionId) async =>
      await _dataSource.parseManifest(sessionId);

  @override
  Future<List<String>> getDexPackages(
          String sessionId, List<String> dexPaths, String packagePrefix) async =>
      await _dataSource.getDexPackages(sessionId, dexPaths, packagePrefix);

  @override
  Future<List<DexClass>> getDexClasses(
          String sessionId, List<String> dexPaths, String packageName) async =>
      await _dataSource.getDexClasses(sessionId, dexPaths, packageName);

  @override
  Future<String> getClassSmali(
          String sessionId, List<String> dexPaths, String className) async =>
      await _dataSource.getClassSmali(sessionId, dexPaths, className);

  @override
  Future<String> decompileClass(
          String sessionId, List<String> dexPaths, String className) async =>
      await _dataSource.decompileClass(sessionId, dexPaths, className);

  @override
  Future<List<String>> searchDexClasses(
          String sessionId, List<String> dexPaths, String keyword) async =>
      await _dataSource.searchDexClasses(sessionId, dexPaths, keyword);
}
