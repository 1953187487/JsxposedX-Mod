import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/features/home/data/models/notice_dto.dart';
import 'package:JsxposedX/features/home/data/models/update_dto.dart';

class CheckQueryDatasource {
  final HttpService _httpService;
  final baseUrl = "http://wy.llua.cn/api";

  // final appKey = "ZwAxPqAj635nRxnW";
  final appId = "34173";

  // final apiToken = "a25c1a30d7fa8354decca3af3f05890a";

  CheckQueryDatasource({required HttpService httpService})
    : _httpService = httpService;

  Future<UpdateDto> getUpdateInfo() async {
    final response = await _httpService.get(
      baseUrl,
      queryParameters: {"id": "ini", "app": appId},
    );
    return UpdateDto.fromJson(response.data);
  }

  Future<NoticeDto> getNoticeInfo() async {
    final response = await _httpService.get(
      baseUrl,
      queryParameters: {"id": "notice", "app": appId},
    );
    return NoticeDto.fromJson(response.data);
  }
}
