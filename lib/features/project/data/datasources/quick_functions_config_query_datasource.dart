import 'dart:convert';

import 'package:JsxposedX/features/project/data/models/dialog_keyword_dto.dart';
import 'package:JsxposedX/generated/pinia.g.dart';

class QuickFunctionsConfigQueryDataSource {
  final _native = PiniaNative();

  Future<bool> getQuickFunctionStatus({
    required String packageName,
    required String name,
  }) async {
    return await _native.getBool(
      key: "${packageName}_$name",
      defaultValue: false,
    );
  }

  Future<List<DialogKeywordDto>> getDialogKeywords({
    required String packageName,
    required String name,
  }) async {
    final raw = await _native.getString(
      key: "${packageName}_${name}_keywords",
      defaultValue: '[]',
    );
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => DialogKeywordDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
