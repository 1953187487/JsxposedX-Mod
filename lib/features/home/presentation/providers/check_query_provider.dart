import 'package:JsxposedX/core/models/notice.dart';
import 'package:JsxposedX/core/models/update.dart';
import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/features/home/data/datasources/check_query_datasource.dart';
import 'package:JsxposedX/features/home/data/repositories/check_query_repository_impl.dart';
import 'package:JsxposedX/features/home/domain/repositories/check_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_query_provider.g.dart';

@riverpod
CheckQueryDatasource checkQueryDatasource(Ref ref) {
  final httpService = ref.watch(httpServiceProvider);
  return CheckQueryDatasource(httpService: httpService);
}

@riverpod
CheckQueryRepository checkQueryRepository(Ref ref) {
  final dataSource = ref.watch(checkQueryDatasourceProvider);
  return CheckQueryRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<Update> updateInfo(Ref ref) async {
  return await ref.watch(checkQueryRepositoryProvider).getUpdateInfo();
}
@riverpod
Future<Notice> noticeInfo(Ref ref) async {
  return await ref.watch(checkQueryRepositoryProvider).getNoticeInfo();
}
