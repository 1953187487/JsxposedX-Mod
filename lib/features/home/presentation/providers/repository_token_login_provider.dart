import 'package:JsxposedX/core/services/app_storage.dart';
import 'package:JsxposedX/features/home/data/datasources/repository_query_datasource.dart';
import 'package:JsxposedX/features/home/domain/models/user_detail.dart';
import 'package:JsxposedX/features/home/presentation/providers/repository_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_token_login_provider.g.dart';

const repositoryLoginTokenStorageKey = 'repository_login_token';

@Riverpod(keepAlive: true)
class RepositoryTokenLogin extends _$RepositoryTokenLogin {
  @override
  Future<UserDetail?> build() async {
    await ref.read(sharedPreferencesProvider.future);
    final storage = ref.read(appStorageProvider.notifier);
    final token =
        storage.getString(repositoryLoginTokenStorageKey)?.trim() ?? '';

    if (token.isEmpty) {
      return null;
    }

    try {
      return await _validateToken(token);
    } on RepositoryLoginStatusException {
      await storage.remove(repositoryLoginTokenStorageKey);
      return null;
    }
  }

  Future<UserDetail> loginWithToken(String token) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Token cannot be empty');
    }

    await ref.read(sharedPreferencesProvider.future);
    final previousUser = state.value;
    state = const AsyncLoading();

    try {
      final user = await _validateToken(normalizedToken);
      await ref
          .read(appStorageProvider.notifier)
          .setString(repositoryLoginTokenStorageKey, normalizedToken);
      state = AsyncData(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncData(previousUser);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<UserDetail> replaceToken(String token) async {
    return loginWithToken(token);
  }

  Future<UserDetail> _validateToken(String token) {
    return ref.read(getMyUserDetailProvider(token: token).future);
  }
}
