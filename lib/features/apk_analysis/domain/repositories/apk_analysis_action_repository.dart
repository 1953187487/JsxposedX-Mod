abstract class ApkAnalysisActionRepository {
  Future<String> openApkSession(String packageName);
  Future<void> closeApkSession(String sessionId);
}
