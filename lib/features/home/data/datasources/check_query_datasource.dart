import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/features/home/data/models/notice_dto.dart';
import 'package:JsxposedX/features/home/data/models/update_dto.dart';

class CheckQueryDatasource {
  final HttpService _httpService;

  // GitHub Releases API for current repository
  final _githubOwner = '1953187487';
  final _githubRepo = 'JsxposedX-Mod';

  CheckQueryDatasource({required HttpService httpService})
    : _httpService = httpService;

  /// 拉取最新 release（含 prerelease，按发布时间倒序取第一条）。
  Future<Map<String, dynamic>> _latestRelease() async {
    final response = await _httpService.get(
      'https://api.github.com/repos/${_githubOwner}/${_githubRepo}/releases?per_page=5',
    );

    final list = response.data as List<dynamic>?;
    if (list == null || list.isEmpty) {
      throw Exception('No releases found on GitHub');
    }
    return Map<String, dynamic>.from(list.first as Map);
  }

  /// 在 assets 中挑选 arm64 release APK，回退到任意 APK。
  String _pickApkUrl(Map<String, dynamic> release) {
    final assets = release['assets'] as List<dynamic>? ?? [];
    String? anyApk;

    for (final asset in assets) {
      final map = asset as Map;
      final name = (map['name'] as String?) ?? '';
      final url = (map['browser_download_url'] as String?) ?? '';
      if (url.isEmpty || !name.endsWith('.apk')) continue;
      if (name == 'app-api100-release.apk') return url;
      anyApk ??= url;
    }
    return anyApk ?? '';
  }

  Future<UpdateDto> getUpdateInfo() async {
    final data = await _latestRelease();

    final tagName = (data['tag_name'] ?? 'v1.0.0') as String;
    final versionNum = tagName.replaceFirst(RegExp('^[vV]'), '');

    return UpdateDto(
      code: 500,
      msg: UpdateMsgDto(
        version: versionNum,
        url: _pickApkUrl(data),
        content: (data['body'] as String?) ?? 'Release update available',
        mustUpdate: '0',
      ),
      check: 'github',
    );
  }

  Future<NoticeDto> getNoticeInfo() async {
    final data = await _latestRelease();

    return NoticeDto(
      code: 500,
      msg: MsgDto(content: (data['body'] as String?) ?? 'No notice available'),
      check: 'github',
    );
  }
}
