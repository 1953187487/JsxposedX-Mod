import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/features/home/data/datasources/repository_action_datasource.dart';
import 'package:JsxposedX/features/home/data/repositories/repository_action_repository_impl.dart';
import 'package:JsxposedX/features/home/domain/repositories/repository_action_repository.dart';

part 'repository_action_provider.g.dart';

@riverpod
RepositoryActionRepository repositoryActionRepository(Ref ref) {
  final httpService = ref.watch(httpServiceProvider);
  final dataSource = RepositoryActionDatasource(httpService: httpService);
  return RepositoryActionRepositoryImpl(dataSource: dataSource);
}
