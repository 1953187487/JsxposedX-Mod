import 'dart:convert';

import 'package:JsxposedX/features/project/domain/models/crypto_rule.dart';
import 'package:flutter/foundation.dart';

class CryptoJsGenerator {
  static const _ruleStart = '/* === CRYPTO_RULES ===';
  static const _ruleEnd = '=== END_CRYPTO_RULES === */';

  static List<CryptoRule> parseRules(String jsCode) {
    if (!jsCode.contains(_ruleStart)) return [];
    try {
      final startIndex = jsCode.indexOf(_ruleStart) + _ruleStart.length;
      final endIndex = jsCode.indexOf(_ruleEnd);
      if (startIndex >= 0 && endIndex > startIndex) {
        final jsonStr = jsCode.substring(startIndex, endIndex).trim();
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((e) => CryptoRule.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint("Failed to parse visual rules: \$e");
    }
    return [];
  }

  static String generateJsCode(List<CryptoRule> rules, String currentCode) {
    // 1. Update the JSON Config block at the top
    final rulesJson = jsonEncode(rules.map((e) => e.toJson()).toList());
    
    String updatedCode = currentCode;
    
    final jsonStart = '  $_ruleStart\n  $rulesJson\n  $_ruleEnd';
    
    if (updatedCode.contains(_ruleStart) && updatedCode.contains(_ruleEnd)) {
        final startIndex = updatedCode.indexOf(_ruleStart);
        final endIndex = updatedCode.indexOf(_ruleEnd) + _ruleEnd.length;
        if (startIndex >= 0 && endIndex > startIndex) {
            final before = updatedCode.substring(0, startIndex);
            final after = updatedCode.substring(endIndex);
            updatedCode = '$before  $_ruleStart\n  $rulesJson\n  $_ruleEnd$after';
        }
    } else {
        // Find onIntercept to inject at the start
        final functionRegex = RegExp(r'function\s+onIntercept\s*\([^)]*\)\s*\{');
        final match = functionRegex.firstMatch(updatedCode);
        if (match != null) {
          final insertIndex = match.end;
          final before = updatedCode.substring(0, insertIndex);
          final after = updatedCode.substring(insertIndex);
          updatedCode = '$before\n$jsonStart\n$after';
        } else {
          // Empty template
          updatedCode = '''function onIntercept(dataHex, isInput, context) {
$jsonStart

  // 👇 --- 全局自定义逻辑区/Global custom logic area --- 👇
  // (在这里写不会被覆盖的代码/Write code here that won't be overwritten)
  // return null;
}
''';
        }
    }

    // 1.5 Find and remove deleted rules from the code
    final activeRuleIds = rules.map((r) => r.id).toSet();
    final ruleIdRegex = RegExp(r'// --- RULE START: (\d+) ---');
    final matches = ruleIdRegex.allMatches(updatedCode).toList();

    // Go in reverse so removing text doesn't mess up indices
    for (var i = matches.length - 1; i >= 0; i--) {
        final match = matches[i];
        final id = match.group(1);
        if (id != null && !activeRuleIds.contains(id)) {
            // Rule was deleted from UI! Remove its block
            final startMarker = '// --- RULE START: $id ---';
            final endMarker = '// --- RULE END: $id ---';
            final startIndex = updatedCode.indexOf(startMarker);
            final endIndex = updatedCode.indexOf(endMarker);
            if (startIndex >= 0 && endIndex >= 0) {
               updatedCode = updatedCode.replaceRange(startIndex, endIndex + endMarker.length + 1, '');
            }
        }
    }

    // 2. Process each rule's visual Javascript block independently
    for (var rule in rules) {
      final ruleStartMarker = '// --- RULE START: ${rule.id} ---';
      final ruleEndMarker = '// --- RULE END: ${rule.id} ---';
      final visualReplaceStart = '// VISUAL_REPLACE_START';
      final visualReplaceEnd = '// VISUAL_REPLACE_END';
      
      final rawBlock = rule.generateJavascriptBlock();

      if (updatedCode.contains(ruleStartMarker) && updatedCode.contains(ruleEndMarker)) {
        // The rule exists in the file.
        final ruleStartIndex = updatedCode.indexOf(ruleStartMarker);
        final ruleEndIndex = updatedCode.indexOf(ruleEndMarker) + ruleEndMarker.length;
        
        if (ruleStartIndex >= 0 && ruleEndIndex > ruleStartIndex) {
          final ruleBody = updatedCode.substring(ruleStartIndex, ruleEndIndex);
          
          if (ruleBody.contains(visualReplaceStart) && ruleBody.contains(visualReplaceEnd)) {
            final newBlockMatch = RegExp(r'// VISUAL_REPLACE_START[\s\S]*?// VISUAL_REPLACE_END').firstMatch(rawBlock);
            if (newBlockMatch != null) {
              final newVisualBody = newBlockMatch.group(0)!;
              final oldBlockMatch = RegExp(r'// VISUAL_REPLACE_START[\s\S]*?// VISUAL_REPLACE_END').firstMatch(ruleBody);
              if (oldBlockMatch != null) {
                final replacedRuleBody = ruleBody.replaceRange(oldBlockMatch.start, oldBlockMatch.end, newVisualBody);
                updatedCode = updatedCode.replaceRange(ruleStartIndex, ruleEndIndex, replacedRuleBody);
              }
            }
          }
        }
      } else {
        // The rule does not exist in the file. Inject it at the end of the onIntercept method.
        final lastReturnIndex = updatedCode.lastIndexOf('return ');
        if (lastReturnIndex > 0 && lastReturnIndex > updatedCode.indexOf('onIntercept')) {
            final before = updatedCode.substring(0, lastReturnIndex);
            final after = updatedCode.substring(lastReturnIndex);
            updatedCode = '$before\n$rawBlock\n  $after';
        } else {
            final lastBraceIndex = updatedCode.lastIndexOf('}');
            if (lastBraceIndex > 0) {
              final before = updatedCode.substring(0, lastBraceIndex);
              final after = updatedCode.substring(lastBraceIndex);
              updatedCode = '$before\n$rawBlock\n$after';
            } else {
              updatedCode += '\n$rawBlock';
            }
        }
      }
    }
    
    return updatedCode;
  }
}
