import 'package:JsxposedX/core/models/notice.dart';
import 'package:JsxposedX/core/models/update.dart';
import 'package:JsxposedX/features/home/data/datasources/check_query_datasource.dart';
import 'package:JsxposedX/features/home/domain/repositories/check_query_repository.dart';

/// AI 对话查询仓储实现（负责 DTO -> Entity 显式映射）
class CheckQueryRepositoryImpl implements CheckQueryRepository {
  final CheckQueryDatasource dataSource;

  CheckQueryRepositoryImpl({required this.dataSource});

  @override
  Future<Notice> getNoticeInfo() async {
    final result = await dataSource.getNoticeInfo();
    return result.toEntity();
  }

  @override
  Future<Update> getUpdateInfo() async {
    final result = await dataSource.getUpdateInfo();
    return result.toEntity();
  }
}
