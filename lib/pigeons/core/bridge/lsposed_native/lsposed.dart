import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class LSPosedNative {
  @async
  bool addModuleScope(String packageName, int userId);

  @async
  bool removeModuleScope(String packageName, int userId);

  @async
  List<String> getModuleScope();

  bool isLSPosedAvailable();
}
