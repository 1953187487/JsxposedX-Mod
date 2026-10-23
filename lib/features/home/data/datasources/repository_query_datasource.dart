import 'package:dio/dio.dart';
import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/core/services/app_storage.dart';
import 'package:JsxposedX/features/home/data/models/common_user_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_detail_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_stats_dto.dart';
import 'package:JsxposedX/features/home/data/models/user_detail_dto.dart';
import 'package:JsxposedX/features/home/domain/models/page_result_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 仓库数据源
///
/// 原论坛 API（apiv2.muxue.pro）已下线，现调整为：
/// - Token 登录：迁移到 Muxue 新平台 `muxueai.pro/api/v1`（Bearer 校验）
/// - 脚本列表：改拉本 Mod 仓库的 GitHub Releases
class RepositoryQueryDatasource {
  final HttpService _httpService;
  final AppStorage _appStorage;
  final Future<SharedPreferences> _storageReady;

  static const String _repositoryLoginTokenStorageKey = 'repository_login_token';

  static const String _myUserDetailApi = 'https://muxueai.pro/api/v1/auth/me';

  static const String _githubApiBase = 'https://api.github.com';
  static const String _repoOwner = '1953187487';
  static const String _repoName = 'JsxposedX-Mod';

  static String get _releasesApi =>
      '$_githubApiBase/repos/$_repoOwner/$_repoName/releases';

  static String get _repoAvatarUrl => 'https://github.com/$_repoOwner.png';

  RepositoryQueryDatasource({
    required HttpService httpService,
    required AppStorage appStorage,
    required Future<SharedPreferences> storageReady,
  }) : _httpService = httpService,
       _appStorage = appStorage,
       _storageReady = storageReady;

  Future<PageResultDto<PostDto>> getScriptPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final releases = await _fetchReleases(limit: limit, offset: offset);
      final rows = releases.map(_releaseToPostDto).toList();
      return PageResultDto<PostDto>(
        total: rows.length,
        rows: rows,
        code: 200,
        msg: 'ok',
        hasMore: false,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  /// 原论坛收藏接口随旧站一并下线，这里回落到同一发布列表
  Future<PageResultDto<PostDto>> getScriptFavoritePosts({
    required int limit,
    required int offset,
  }) {
    return getScriptPosts(limit: limit, offset: offset);
  }

  Future<PostDetailDto> getScriptDetail({required int id}) async {
    try {
      final releases = await _fetchReleases(limit: 100, offset: 0);
      Map<String, dynamic>? match;
      for (final release in releases) {
        if (release['id'] == id) {
          match = release;
          break;
        }
      }
      if (match == null) {
        throw const FormatException('Release not found');
      }

      final body = _text(match['body']);
      return PostDetailDto(
        id: id,
        title: _titleOf(match),
        description: _summaryOf(body),
        publishTime: _epochOf(match['published_at'] ?? match['created_at']),
        uploader: CommonUserDto(
          nickname: _repoOwner,
          avatarUrl: _repoAvatarUrl,
        ),
        content: body,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserDetailDto> getMyUserDetail({required String token}) async {
    final result = await _httpService.get(
      _myUserDetailApi,
      options: await _authorizedOptions(token: token),
    );
    if (result.statusCode != null && result.statusCode != 200) {
      throw RepositoryLoginStatusException(result.statusCode);
    }

    final user = _extractUserMap(result.data);
    if (user == null) {
      throw RepositoryLoginStatusException(result.statusCode ?? -1);
    }

    final nickname =
        _firstText(
          user,
          keys: const ['display_name', 'username', 'nickname', 'name'],
        ) ??
        '';
    final mxid =
        _firstText(user, keys: const ['mxid', 'username']) ??
        (_idOf(user['id']).toString());

    return UserDetailDto(
      id: _idOf(user['id']),
      mxid: mxid,
      nickname: nickname,
      avatarUrl:
          _firstText(user, keys: const ['avatar_url', 'avatarUrl', 'avatar']) ??
          '',
      isVip: user['is_vip'] == true || user['isVip'] == true,
    );
  }

  // ==================== 内部实现 ====================

  Future<List<Map<String, dynamic>>> _fetchReleases({
    required int limit,
    required int offset,
  }) async {
    final perPage = limit <= 0 ? 20 : limit.clamp(1, 30);
    final page = limit <= 0 ? 1 : (offset ~/ limit) + 1;

    final result = await _httpService.get(
      _releasesApi,
      queryParameters: {'per_page': perPage, 'page': page},
    );

    final body = result.data;
    if (body is! List) {
      return const [];
    }
    return body.whereType<Map<String, dynamic>>().toList();
  }

  PostDto _releaseToPostDto(Map<String, dynamic> release) {
    return PostDto(
      id: _idOf(release['id']),
      title: _titleOf(release),
      description: _summaryOf(_text(release['body'])),
      cover: _repoAvatarUrl,
      publishTime: _epochOf(release['published_at'] ?? release['created_at']),
      uploader: CommonUserDto(
        nickname: _repoOwner,
        avatarUrl: _repoAvatarUrl,
      ),
      postStats: PostStatsDto(viewCount: _assetDownloadsOf(release)),
      badges: const [],
    );
  }

  int _assetDownloadsOf(Map<String, dynamic> release) {
    final assets = release['assets'];
    if (assets is! List) {
      return 0;
    }
    var total = 0;
    for (final asset in assets) {
      if (asset is Map) {
        final count = asset['download_count'];
        if (count is int) {
          total += count;
        }
      }
    }
    return total;
  }

  static Map<String, dynamic>? _extractUserMap(Object? payload) {
    if (payload is! Map<String, dynamic>) {
      return null;
    }
    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (payload.containsKey('display_name') ||
        payload.containsKey('username') ||
        payload.containsKey('nickname')) {
      return payload;
    }
    return null;
  }

  static String? _firstText(
    Map<String, dynamic> map, {
    required List<String> keys,
  }) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static int _idOf(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static String _text(Object? value) {
    if (value is String) {
      return value;
    }
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static String _titleOf(Map<String, dynamic> release) {
    final name = _text(release['name']).trim();
    return name.isEmpty ? 'Release #${_idOf(release['id'])}' : name;
  }

  static String _summaryOf(String text) {
    final normalized = text
        .replaceAll(RegExp(r'```.*?```'), ' ')
        .replaceAll(RegExp(r'\r?\n+'), ' ')
        .replaceAll(RegExp(r'\[([^\]]*)\]\([^)]*\)'), r'$1')
        .replaceAll(RegExp(r'[#*_`>|]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.isEmpty) {
      return '';
    }
    return normalized.length > 140
        ? '${normalized.substring(0, 140)}…'
        : normalized;
  }

  static int _epochOf(Object? value) {
    if (value == null) {
      return 0;
    }
    final date = DateTime.tryParse(_text(value));
    return date == null ? 0 : date.millisecondsSinceEpoch ~/ 1000;
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
