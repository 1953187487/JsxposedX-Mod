import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class StatusManagementNative {
  bool isHook();

  bool isRoot();

  FridaStatusData isFrida();

}

class FridaStatusData {
  bool status;
  int type;

  FridaStatusData({
    required this.status,
    required this.type,
  });
}
