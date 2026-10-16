import 'package:JsxposedX/features/home/data/datasources/repository_action_datasource.dart';
import 'package:JsxposedX/features/home/domain/repositories/repository_action_repository.dart';

class RepositoryActionRepositoryImpl implements RepositoryActionRepository {
  final RepositoryActionDatasource dataSource;

  RepositoryActionRepositoryImpl({required this.dataSource});
}
