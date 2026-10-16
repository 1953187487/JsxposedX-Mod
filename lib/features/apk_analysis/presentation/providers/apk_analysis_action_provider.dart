import 'package:JsxposedX/features/apk_analysis/data/datasources/apk_analysis_action_datasource.dart';
import 'package:JsxposedX/features/apk_analysis/data/repositories/apk_analysis_action_repository_impl.dart';
import 'package:JsxposedX/features/apk_analysis/domain/repositories/apk_analysis_action_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apk_analysis_action_provider.g.dart';

@riverpod
ApkAnalysisActionDatasource apkAnalysisActionDatasource(Ref ref) {
  return ApkAnalysisActionDatasource();
}

@riverpod
ApkAnalysisActionRepository apkAnalysisActionRepository(Ref ref) {
  final dataSource = ref.watch(apkAnalysisActionDatasourceProvider);
  return ApkAnalysisActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<String> openApkSession(Ref ref, {required String packageName}) async =>
    await ref.watch(apkAnalysisActionRepositoryProvider).openApkSession(packageName);

@riverpod
Future<void> closeApkSession(Ref ref, {required String sessionId}) async =>
    await ref.watch(apkAnalysisActionRepositoryProvider).closeApkSession(sessionId);
