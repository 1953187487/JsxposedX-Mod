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

  Future<UpdateDto> getUpdateInfo() async {
    // Get latest release from GitHub
    final response = await _httpService.get(
      'https://api.github.com/repos/${_githubOwner}/${_githubRepo}/releases/latest',
    );

    final data = response.data as Map<String, dynamic>;
    final assets = data['assets'] as List<dynamic>? ?? [];
    final apkUrl = assets.isNotEmpty
        ? (assets[0]['browser_download_url'] as String?) ?? ''
        : '';

    final versionCode = data['tag_name'] ?? 'v1.0.0';
    final versionNum = versionCode.replaceAll('v', '');

    return UpdateDto(
      code: 500,
      msg: UpdateMsgDto(
        version: versionNum,
        url: apkUrl,
        content: (data['body'] as String?) ?? 'Release update available',
        mustUpdate: '0',
      ),
      check: 'github',
    );
  }

  Future<NoticeDto> getNoticeInfo() async {
    // Get latest release notes as notice
    final response = await _httpService.get(
      'https://api.github.com/repos/${_githubOwner}/${_githubRepo}/releases/latest',
    );

    final data = response.data as Map<String, dynamic>;

    return NoticeDto(
      code: 500,
      msg: MsgDto(content: (data['body'] as String?) ?? 'No notice available'),
      check: 'github',
    );
  }
}
