import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/core/services/app_storage.dart';
import 'package:JsxposedX/features/home/data/models/post_detail_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_dto.dart';
import 'package:JsxposedX/features/home/data/models/user_detail_dto.dart';
import 'package:JsxposedX/features/home/domain/models/page_result_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class RepositoryQueryDatasource {
  final HttpService _httpService;
  final AppStorage _appStorage;
  final Future<SharedPreferences> _storageReady;

  static const String _repositoryLoginTokenStorageKey = 'repository_login_token';

  RepositoryQueryDatasource({
    required HttpService httpService,
    required AppStorage appStorage,
    required Future<SharedPreferences> storageReady,
  }) : _httpService = httpService,
       _appStorage = appStorage,
       _storageReady = storageReady;
  final String _postApi =
      "https://apiv2.muxue.pro/api/public/post/category/tag/470/posts";

  final String _favoritePostApi =
      "https://apiv2.muxue.pro/api/public/post/favorites";

  final String _myUserDetailApi = "https://apiv2.muxue.pro/api/public/user/me";

  String _postDetailApi({required int postId}) =>
      "https://apiv2.muxue.pro/api/public/post/$postId/detail";

  Future<PageResultDto<PostDto>> getScriptPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final result = await _httpService.get(
        _postApi,
        queryParameters: {'limit': limit, 'offset': offset},
        options: await _authorizedOptions(),
      );
      return PageResultDto.fromJson(
        result.data,
        (data) => PostDto.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PageResultDto<PostDto>> getScriptFavoritePosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final result = await _httpService.get(
        _favoritePostApi,
        queryParameters: {'limit': limit, 'offset': offset},
        options: await _authorizedOptions(),
      );
      return PageResultDto.fromJson(
        result.data,
        (data) => PostDto.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PostDetailDto> getScriptDetail({required int id}) async {
    try {
      final result = await _httpService.get(
        _postDetailApi(postId: id),
        options: await _authorizedOptions(),
      );
      return PostDetailDto.fromJson(result.data["data"]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserDetailDto> getMyUserDetail({required String token}) async {
    final result = await _httpService.get(
      _myUserDetailApi,
      options: await _authorizedOptions(token: token),
    );
    if (result.statusCode != 200) {
      throw RepositoryLoginStatusException(result.statusCode);
    }

    final payload = result.data;
    if (payload is! Map<String, dynamic> || payload['data'] is! Map<String, dynamic>) {
      throw const FormatException('Invalid user detail response');
    }

    return UserDetailDto.fromJson(payload['data'] as Map<String, dynamic>);
  }

  Future<Options?> _authorizedOptions({String? token, Options? options}) async {
    final resolvedToken = await _resolveToken(token);
    if (resolvedToken == null) {
      return options;
    }

    final headers = <String, dynamic>{
      ...?options?.headers,
      "Authorization": "Bearer $resolvedToken",
    };

    return (options ?? Options()).copyWith(headers: headers);
  }

  Future<String?> _resolveToken(String? token) async {
    final normalizedToken = token?.trim() ?? '';
    if (normalizedToken.isNotEmpty) {
      return normalizedToken;
    }

    await _storageReady;
    final localToken =
        _appStorage.getString(_repositoryLoginTokenStorageKey)?.trim() ?? '';
    if (localToken.isEmpty) {
      return null;
    }
    return localToken;
  }
}

class RepositoryLoginStatusException implements Exception {
  final int? statusCode;

  const RepositoryLoginStatusException(this.statusCode);

  @override
  String toString() => 'RepositoryLoginStatusException(statusCode: $statusCode)';
}
