import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class PiniaNative {
  void setString({
    String space = "pinia",
    required String key,
    required String value,
    int type = 2,
  });

  void setInt({
    String space = "pinia",
    required String key,
    required int value,
    int type = 2,
  });

  void setBool({
    String space = "pinia",
    required String key,
    required bool value,
    int type = 2,
  });

  void setDouble({
    String space = "pinia",
    required String key,
    required double value,
    int type = 2,
  });

  void setLong({
    String space = "pinia",
    required String key,
    required int value,
    int type = 2,
  });

  String getString({
    String space = "pinia",
    required String key,
    required String defaultValue,
    int type = 2,
  });

  int getInt({
    String space = "pinia",
    required String key,
    required int defaultValue,
    int type = 2,
  });

  bool getBool({
    String space = "pinia",
    required String key,
    required bool defaultValue,
    int type = 2,
  });

  double getDouble({
    String space = "pinia",
    required String key,
    required double defaultValue,
    int type = 2,
  });

  int getLong({
    String space = "pinia",
    required String key,
    required int defaultValue,
    int type = 2,
  });

  bool contains({
    String space = "pinia",
    required String key,
    int type = 2,
  });

  void remove({
    String space = "pinia",
    required String key,
    int type = 2,
  });

  void clear({
    String space = "pinia",
    int type = 2,
  });
}
