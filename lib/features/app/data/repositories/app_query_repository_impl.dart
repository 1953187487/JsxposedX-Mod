import 'dart:typed_data';

import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/app/data/datasources/app_query_datasource.dart';
import 'package:JsxposedX/features/app/data/models/app_info_dto.dart';
import 'package:JsxposedX/features/app/domain/repositories/app_query_repository.dart';

class AppQueryRepositoryImpl implements AppQueryRepository {
  final AppQueryDatasource _dataSource;

  AppQueryRepositoryImpl({required AppQueryDatasource dataSource})
      : _dataSource = dataSource;

  @override
  Future<int> getAppCount({bool includeSystemApps = false, String query = ""}) async {
    return await _dataSource.getAppCount(
      includeSystemApps: includeSystemApps,
      query: query,
    );
  }

  @override
  Future<List<AppInfoDto>> getInstalledApps({
    bool includeSystemApps = false,
    int offset = 0,
    int limit = 50,
    String query = "",
  }) async {
    final pigeonList = await _dataSource.getInstalledApps(
      includeSystemApps: includeSystemApps,
      offset: offset,
      limit: limit,
      query: query,
    );

    return pigeonList.map((p) {
      return AppInfoDto(
        name: p.name,
        packageName: p.packageName,
        versionName: p.versionName,
        versionCode: p.versionCode,
        isSystemApp: p.isSystemApp,
        icon: p.icon,
      );
    }).toList();
  }

  @override
  Future<AppInfo?> getAppByPackageName({required String packageName}) async {
    final result = await _dataSource.getAppByPackageName(packageName);
    if (result == null) return null;
    
    return AppInfo(
      name: result.name,
      packageName: result.packageName,
      versionName: result.versionName,
      versionCode: result.versionCode,
      isSystemApp: result.isSystemApp,
      icon: result.icon ?? Uint8List(0),
    );
  }
}
