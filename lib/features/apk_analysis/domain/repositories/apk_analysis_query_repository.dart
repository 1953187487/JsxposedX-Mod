import 'package:JsxposedX/generated/apk_analysis.g.dart';

abstract class ApkAnalysisQueryRepository {
  Future<List<ApkAsset>> getApkAssets(String sessionId);
  Future<List<ApkAsset>> getApkAssetsAt(String sessionId, String path);
  Future<ApkManifest> parseManifest(String sessionId);
  Future<List<String>> getDexPackages(String sessionId, List<String> dexPaths, String packagePrefix);
  Future<List<DexClass>> getDexClasses(String sessionId, List<String> dexPaths, String packageName);
  Future<String> getClassSmali(String sessionId, List<String> dexPaths, String className);
  Future<String> decompileClass(String sessionId, List<String> dexPaths, String className);
  Future<List<String>> searchDexClasses(String sessionId, List<String> dexPaths, String keyword);
}
