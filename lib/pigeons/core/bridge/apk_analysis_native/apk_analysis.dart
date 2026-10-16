import 'package:pigeon/pigeon.dart';

class ApkAsset {
  final String path;
  final String name;
  final int size;
  final int compressedSize;
  final bool isDirectory;
  final int lastModified;

  ApkAsset({
    required this.path,
    required this.name,
    required this.size,
    required this.compressedSize,
    required this.isDirectory,
    required this.lastModified,
  });
}

class ApkComponent {
  final String name;
  final bool exported;
  final String? process;
  final List<String?> intentActions;

  ApkComponent({
    required this.name,
    required this.exported,
    this.process,
    required this.intentActions,
  });
}

class ApkManifest {
  final String packageName;
  final String versionName;
  final int versionCode;
  final int minSdk;
  final int targetSdk;
  final List<String?> permissions;
  final List<ApkComponent?> activities;
  final List<ApkComponent?> services;
  final List<ApkComponent?> receivers;
  final List<ApkComponent?> providers;
  final String? applicationLabel;
  final bool debuggable;
  final bool allowBackup;

  ApkManifest({
    required this.packageName,
    required this.versionName,
    required this.versionCode,
    required this.minSdk,
    required this.targetSdk,
    required this.permissions,
    required this.activities,
    required this.services,
    required this.receivers,
    required this.providers,
    this.applicationLabel,
    required this.debuggable,
    required this.allowBackup,
  });
}

class DexClass {
  final String className;
  final String? superClass;
  final List<String?> interfaces;
  final int methodCount;
  final int fieldCount;
  final bool isAbstract;
  final bool isInterface;
  final bool isEnum;

  DexClass({
    required this.className,
    this.superClass,
    required this.interfaces,
    required this.methodCount,
    required this.fieldCount,
    required this.isAbstract,
    required this.isInterface,
    required this.isEnum,
  });
}

@HostApi()
abstract class ApkAnalysisNative {
  @async
  String openApkSession(String packageName);

  @async
  void closeApkSession(String sessionId);

  @async
  List<ApkAsset> getApkAssets(String sessionId);

  @async
  List<ApkAsset> getApkAssetsAt(String sessionId, String path);

  @async
  ApkManifest parseManifest(String sessionId);

  @async
  List<String> getDexPackages(String sessionId, List<String> dexPaths, String packagePrefix);

  @async
  List<DexClass> getDexClasses(String sessionId, List<String> dexPaths, String packageName);

  @async
  String getClassSmali(String sessionId, List<String> dexPaths, String className);

  @async
  String decompileClass(String sessionId, List<String> dexPaths, String className);

  @async
  List<String> searchDexClasses(String sessionId, List<String> dexPaths, String keyword);
}
