import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/generated/shell.g.dart';

class ShellExecToolHandler implements AiChatToolHandler {
  const ShellExecToolHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  @override
  String get toolName => 'shell_exec';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final command = call.getString('command');
    final useSu = call.getBool('useSu');
    final timeout = call.getInt('timeoutSeconds', 15);

    if (command.isEmpty) {
      throw ArgumentError('command 不能为空 / command is required');
    }

    final native = ShellNative();
    final result = await native.executeShell(
      command,
      useSu,
      timeout.clamp(1, 60),
    );

    final buf = StringBuffer();
    if (result.exitCode == 0) {
      buf.writeln('exit: 0');
      if (result.stdout.isNotEmpty) buf.writeln(result.stdout);
    } else {
      buf.writeln('exit: ${result.exitCode}');
      if (result.stderr.isNotEmpty) buf.writeln(result.stderr);
      if (result.stdout.isNotEmpty) buf.writeln(result.stdout);
    }

    final output = buf.toString().trim();
    return output.isEmpty ? 'exit: 0 (no output)' : output;
  }
}