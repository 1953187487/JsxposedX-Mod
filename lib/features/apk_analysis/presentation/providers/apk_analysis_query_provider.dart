import 'package:JsxposedX/features/apk_analysis/data/datasources/apk_analysis_query_datasource.dart';
import 'package:JsxposedX/features/apk_analysis/data/repositories/apk_analysis_query_repository_impl.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_query_repository.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apk_analysis_query_provider.g.dart';

@riverpod
ApkAnalysisQueryDatasource apkAnalysisQueryDatasource(Ref ref) {
  return ApkAnalysisQueryDatasource();
}

@riverpod
ApkAnalysisQueryRepository apkAnalysisQueryRepository(Ref ref) {
  final dataSource = ref.watch(apkAnalysisQueryDatasourceProvider);
  return ApkAnalysisQueryRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<List<ApkAsset>> getApkAssets(Ref ref, {required String sessionId}) async =>
    await ref.watch(apkAnalysisQueryRepositoryProvider).getApkAssets(sessionId);

@riverpod
Future<List<ApkAsset>> getApkAssetsAt(
  Ref ref, {
  required String sessionId,
  required String path,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .getApkAssetsAt(sessionId, path);

@riverpod
Future<ApkManifest> parseManifest(Ref ref, {required String sessionId}) async =>
    await ref.watch(apkAnalysisQueryRepositoryProvider).parseManifest(sessionId);

@riverpod
Future<List<String>> getDexPackages(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String packagePrefix,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .getDexPackages(sessionId, dexPaths, packagePrefix);

@riverpod
Future<List<DexClass>> getDexClasses(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String packageName,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .getDexClasses(sessionId, dexPaths, packageName);

@riverpod
Future<String> getClassSmali(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String className,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .getClassSmali(sessionId, dexPaths, className);

@riverpod
Future<String> decompileClass(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String className,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .decompileClass(sessionId, dexPaths, className);

@riverpod
Future<List<String>> searchDexClasses(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String keyword,
}) async =>
    await ref
        .watch(apkAnalysisQueryRepositoryProvider)
        .searchDexClasses(sessionId, dexPaths, keyword);
