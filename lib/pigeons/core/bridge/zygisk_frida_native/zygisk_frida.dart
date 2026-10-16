import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ZygiskFridaNative {
  bool isModuleInstalled();

  bool isModuleReady();

  bool isTargetEnabled(String packageName);

  int setTargetEnabled(String packageName, bool enabled);
}
