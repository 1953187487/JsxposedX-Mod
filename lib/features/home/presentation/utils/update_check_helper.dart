import 'package:JsxposedX/core/models/update.dart';

/// 比较两个应用版本号，远程比本地新返回正数。
///
/// 支持 `1.2.3`、`v1.2.3`、`1.2.3-beta.2` 等格式。
/// 同主版本下正式版（无预发布后缀）大于预发布版本。
/// 任一侧无法解析时返回 0（视为无更新）。
int compareAppVersion(String remote, String local) {
  final r = _Version.tryParse(remote);
  final l = _Version.tryParse(local);
  if (r == null || l == null) {
    return 0;
  }
  return r.compareTo(l);
}

/// 是否需要提示更新。
///
/// [localVersionName] 为本地 versionName（如 `1.0.2-beta.1`），
/// 远程版本来自 GitHub Release 的 tag（如 `1.0.2-beta.2`）。
bool shouldShowUpdateDialog({
  required Update update,
  required String localVersionName,
}) {
  final remoteVersion = update.msg.version.trim();
  if (remoteVersion.isEmpty) {
    return false;
  }
  if (update.msg.url.trim().isEmpty) {
    return false;
  }

  try {
    return compareAppVersion(remoteVersion, localVersionName) > 0;
  } catch (_) {
    return false;
  }
}

class _Version implements Comparable<_Version> {
  const _Version(this.major, this.minor, this.patch, this.preNumber);

  final int major;
  final int minor;
  final int patch;

  /// 预发布序号；`null` 表示正式版（release）。
  final int? preNumber;

  static _Version? tryParse(String raw) {
    var value = raw.trim();
    if (value.startsWith('v') || value.startsWith('V')) {
      value = value.substring(1);
    }

    String? preToken;
    final dash = value.indexOf('-');
    if (dash >= 0) {
      preToken = value.substring(dash + 1);
      value = value.substring(0, dash);
    }

    final parts = value.split('.');
    final major = int.tryParse(parts.first);
    if (major == null) return null;
    final minor =
        parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    final patch =
        parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;

    int? preNumber;
    if (preToken != null && preToken.trim().isNotEmpty) {
      final segs = preToken.split('.');
      preNumber = int.tryParse(segs.last);
    }

    return _Version(major, minor, patch, preNumber);
  }

  @override
  int compareTo(_Version other) {
    final core = _compare3(major, other.major);
    if (core != 0) return core;
    final minorCmp = _compare3(minor, other.minor);
    if (minorCmp != 0) return minorCmp;
    final patchCmp = _compare3(patch, other.patch);
    if (patchCmp != 0) return patchCmp;

    // 正式版 > 预发布版
    if (preNumber != null && other.preNumber == null) return -1;
    if (preNumber == null && other.preNumber != null) return 1;
    if (preNumber == null) return 0;
    return preNumber! - other.preNumber!;
  }

  static int _compare3(int a, int b) => a == b ? 0 : (a > b ? 1 : -1);
}
