import 'package:pigeon/pigeon.dart';

/// shell 命令执行结果
class ShellResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  ShellResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });
}

@HostApi()
abstract class ShellNative {
  /// 执行 shell 命令。
  ///
  /// [command] 完整 shell 命令（如 "pm list packages"）。
  /// [useSu] 是否通过 `su -c` 以 root 权限执行。
  /// [timeoutSeconds] 超时秒数（默认 30），超时后强制终止进程。
  @async
  ShellResult executeShell(
    String command,
    bool useSu,
    int timeoutSeconds,
  );
}