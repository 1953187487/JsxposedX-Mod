import 'package:JsxposedX/core/models/notice.dart';
import 'package:JsxposedX/core/models/update.dart';


abstract class CheckQueryRepository {
  Future<Update> getUpdateInfo();
  Future<Notice> getNoticeInfo();
}
