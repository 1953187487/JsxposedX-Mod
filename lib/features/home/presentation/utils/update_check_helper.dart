import 'package:JsxposedX/core/models/update.dart';

bool shouldShowUpdateDialog({
  required Update update,
  required int localBuildNumber,
}) {
  final remoteBuildNumber = int.tryParse(update.msg.version.trim());
  if (remoteBuildNumber == null) {
    return false;
  }

  if (update.msg.url.trim().isEmpty) {
    return false;
  }

  return remoteBuildNumber > localBuildNumber;
}
