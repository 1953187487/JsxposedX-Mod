import 'dart:math';

/// 高级 JavaScript 代码格式化工具 (增强版)
class JsFormatter {
  static String format(String code, {int indentSize = 2}) {
    if (code.trim().isEmpty) return code;

    final String indentStr = ' ' * indentSize;
    final StringBuffer output = StringBuffer();

    final String source = code;
    final int length = source.length;
    int i = 0;
    int currentIndent = 0;
    int contIndent = 0; // 续行缩进（用户手动换行后 +1）
    final List<int> savedIndents = [];        // { 进入时保存 currentIndent
    final List<int> savedConts = [];          // { 进入时保存 contIndent
    final List<int> bracketSavedIndents = []; // [ 进入时保存 currentIndent
    final List<int> bracketSavedConts = [];   // [ 进入时保存 contIndent

    StringBuffer lineBuffer = StringBuffer();

    void addNewLine() {
      final String line = lineBuffer.toString().trimRight();
      if (line.isNotEmpty) {
        output.write(indentStr * (currentIndent + contIndent));
        output.writeln(line);
      } else if (lineBuffer.isNotEmpty) {
        output.writeln('');
      }
      lineBuffer = StringBuffer();
    }

    /// 判断前一个 token 是否是「值」结尾
    /// 是 → 后续运算符是二元的；否 → 一元前缀
    bool isPrecedingValue() {
      final s = lineBuffer.toString().trimRight();
      if (s.isEmpty) return false;
      final last = s[s.length - 1];
      return last == ')' ||
          last == ']' ||
          last == '"' ||
          last == "'" ||
          last == '`' ||
          _isIdentChar(last.codeUnitAt(0));
    }

    while (i < length) {
      final String char = source[i];

      // ── 1. 注释 ─────────────────────────────────────────
      if (char == '/' && i + 1 < length) {
        if (source[i + 1] == '/') {
          // 单行注释
          int end = source.indexOf('\n', i);
          if (end == -1) end = length;
          lineBuffer.write(source.substring(i, end).trim());
          i = end;
          addNewLine();
          continue;
        } else if (source[i + 1] == '*') {
          // 多行注释
          int end = source.indexOf('*/', i + 2);
          if (end == -1) {
            end = length;
          } else {
            end += 2;
          }
          lineBuffer.write(source.substring(i, end));
          i = end;
          continue;
        }
      }

      // ── 2. 正则表达式字面量 ──────────────────────────────
      if (char == '/' && !isPrecedingValue()) {
        final int start = i;
        i++; // 跳过 /
        bool inCharClass = false;
        while (i < length) {
          if (source[i] == '\\' && i + 1 < length) {
            i += 2;
            continue;
          }
          if (source[i] == '[') inCharClass = true;
          if (source[i] == ']') inCharClass = false;
          if (source[i] == '/' && !inCharClass) {
            i++; // 跳过闭合 /
            // 消费 flags (g, i, m, s, u, y)
            while (i < length && 'gimsuy'.contains(source[i])) {
              i++;
            }
            break;
          }
          i++;
        }
        lineBuffer.write(source.substring(start, i));
        continue;
      }

      // ── 3. 单引号/双引号字符串 ──────────────────────────
      if (char == "'" || char == '"') {
        final int start = i;
        final String quote = char;
        i++;
        while (i < length) {
          if (source[i] == '\\' && i + 1 < length) {
            i += 2;
            continue;
          }
          if (source[i] == quote) {
            i++;
            break;
          }
          i++;
        }
        lineBuffer.write(source.substring(start, i));
        continue;
      }

      // ── 4. 模板字符串 (backtick) ─ 正确处理 ${} 嵌套 ──
      if (char == '`') {
        final int start = i;
        i++;
        int braceDepth = 0;
        while (i < length) {
          if (source[i] == '\\' && i + 1 < length) {
            i += 2;
            continue;
          }
          if (braceDepth == 0 && source[i] == '`') {
            i++;
            break;
          }
          if (source[i] == '\$' && i + 1 < length && source[i + 1] == '{') {
            braceDepth++;
            i += 2;
            continue;
          }
          if (braceDepth > 0 && source[i] == '{') braceDepth++;
          if (braceDepth > 0 && source[i] == '}') braceDepth--;
          i++;
        }
        lineBuffer.write(source.substring(start, i));
        continue;
      }

      // ── 5. 多字符操作符 (长度递减排列) ────────────────────
      String? matchedOp;
      for (final op in _multiCharOperators) {
        if (i + op.length <= length &&
            source.substring(i, i + op.length) == op) {
          matchedOp = op;
          break;
        }
      }
      if (matchedOp != null) {
        if (matchedOp == '++' || matchedOp == '--') {
          // 自增/自减：紧贴操作数，不加空格
          lineBuffer.write(matchedOp);
        } else if (matchedOp == '?.') {
          // 可选链：无空格
          lineBuffer.write('?.');
        } else {
          final String current = lineBuffer.toString();
          if (current.isNotEmpty && !current.endsWith(' ')) {
            lineBuffer.write(' ');
          }
          lineBuffer.write(matchedOp);
          lineBuffer.write(' ');
        }
        i += matchedOp.length;
        continue;
      }

      // ── 6. 单字符处理 ──────────────────────────────────
      switch (char) {
        case '{':
          final String current = lineBuffer.toString();
          if (current.isNotEmpty && !current.endsWith(' ')) {
            lineBuffer.write(' ');
          }
          lineBuffer.write('{');
          addNewLine();
          // 保存当前状态，进入新块
          savedIndents.add(currentIndent);
          savedConts.add(contIndent);
          currentIndent += contIndent + 1;
          contIndent = 0;
          break;

        case '}':
          addNewLine();
          // 恢复 { 之前的缩进状态
          if (savedIndents.isNotEmpty) {
            currentIndent = savedIndents.removeLast();
            contIndent = savedConts.removeLast();
          } else {
            currentIndent = max(0, currentIndent - 1);
          }
          lineBuffer.write('}');
          // 向前看下一个非空白字符，并记录中间是否有用户换行
          bool hasNewline = false;
          int j = i + 1;
          while (j < length && _isWhitespace(source[j])) {
            if (source[j] == '\n') hasNewline = true;
            j++;
          }
          if (_matchesChainKeyword(source, j, length)) {
            // } else / } catch / } finally → 始终同行
            lineBuffer.write(' ');
            i = j - 1;
          } else if (!hasNewline && j < length && _isContinuationAfterBrace(source[j])) {
            // } ) ; , . ] → 用户没换行时才合并
            i = j - 1;
          } else {
            addNewLine();
            // } 后换行遇到闭合符 ) / ] → 重置续行缩进，让闭合符回到外层调用的基线
            if (hasNewline && j < length &&
                (source[j] == ')' || source[j] == ']' || source[j] == ';')) {
              contIndent = 0;
            }
          }
          break;

        case ';':
          lineBuffer.write(';');
          if (!_isInForLoopHeader(source, i)) {
            addNewLine();
            contIndent = 0; // 语句结束，重置续行
          } else {
            lineBuffer.write(' ');
          }
          break;

        case ',':
          lineBuffer.write(', ');
          break;

        case ':':
          lineBuffer.write(': ');
          break;

        case '(':
          lineBuffer.write('(');
          break;
        case ')':
          lineBuffer.write(')');
          break;
        case '[':
          lineBuffer.write('[');
          // 保存状态，把当前有效缩进级别「压平」，等 \n 时 contIndent 自然 +1
          bracketSavedIndents.add(currentIndent);
          bracketSavedConts.add(contIndent);
          currentIndent = currentIndent + contIndent;
          contIndent = 0;
          break;

        case ']':
          // 恢复 [ 之前的状态
          if (bracketSavedIndents.isNotEmpty) {
            currentIndent = bracketSavedIndents.removeLast();
            contIndent = bracketSavedConts.removeLast();
          }
          lineBuffer.write(']');
          break;

        // ── 一元前缀运算符 ──
        case '!':
          if (!isPrecedingValue()) {
            // 逻辑非前缀: !flag → 紧贴
            lineBuffer.write('!');
          } else {
            // 罕见情况 (单独 ! 作为二元不存在，但容错)
            _writeBinaryOp(lineBuffer, '!');
          }
          break;

        case '~':
          // 按位取反，总是一元前缀
          lineBuffer.write('~');
          break;

        case '+':
        case '-':
          if (isPrecedingValue()) {
            // 二元加减: a + b
            _writeBinaryOp(lineBuffer, char);
          } else {
            // 一元正负: -1, +x → 紧贴
            lineBuffer.write(char);
          }
          break;

        // ── 始终二元的运算符 ──
        case '=':
        case '*':
        case '/':
        case '%':
        case '<':
        case '>':
        case '&':
        case '|':
        case '^':
        case '?':
          _writeBinaryOp(lineBuffer, char);
          break;

        // ── 换行符：保留用户手动换行 ──
        case '\n':
          final String nlContent = lineBuffer.toString().trimRight();
          if (nlContent.isNotEmpty) {
            addNewLine();
            // 后续行开启续行缩进
            if (contIndent == 0) contIndent = 1;
          }
          break;

        // ── 其他空白：折叠为单个空格 ──
        case ' ':
        case '\t':
        case '\r':
          final String current = lineBuffer.toString();
          if (current.isNotEmpty &&
              !current.endsWith(' ') &&
              !current.endsWith('(') &&
              !current.endsWith('{') &&
              !current.endsWith(';') &&
              !current.endsWith(',') &&
              !current.endsWith('[')) {
            lineBuffer.write(' ');
          }
          break;

        default:
          lineBuffer.write(char);
      }
      i++;
    }

    addNewLine();
    return output.toString().trim();
  }

  // ── 多字符操作符表（长度递减排列，确保最长匹配优先） ──
  static const _multiCharOperators = [
    '>>>=', '===', '!==', '**=', '>>=', '<<=',
    '>>>', '==', '!=', '+=', '-=', '*=', '/=', '%=',
    '**', '&&', '||', '??', '<=', '>=', '=>', '<<', '>>',
    '?.', '++', '--',
  ];

  /// 写入二元操作符：前后各保证一个空格
  static void _writeBinaryOp(StringBuffer buf, String op) {
    final String current = buf.toString();
    if (current.isNotEmpty && !current.endsWith(' ')) buf.write(' ');
    buf.write(op);
    buf.write(' ');
  }

  /// 字母、数字、_、\$ → 标识符字符
  static bool _isIdentChar(int c) {
    return (c >= 65 && c <= 90) || // A-Z
        (c >= 97 && c <= 122) || // a-z
        (c >= 48 && c <= 57) || // 0-9
        c == 95 || // _
        c == 36; // $
  }

  static bool _isWhitespace(String ch) {
    return ch == ' ' || ch == '\n' || ch == '\t' || ch == '\r';
  }

  /// `}` 后紧跟这些字符时不换行（函数表达式尾部、链式调用等）
  static bool _isContinuationAfterBrace(String ch) {
    return ch == ')' || ch == ']' || ch == ';' || ch == ',' || ch == '.';
  }

  /// 检测 source[j] 开头是否是 else / catch / finally（带单词边界）
  static bool _matchesChainKeyword(String source, int j, int length) {
    for (final kw in const ['else', 'catch', 'finally']) {
      final end = j + kw.length;
      if (end <= length &&
          source.substring(j, end) == kw &&
          (end >= length || !_isIdentChar(source.codeUnitAt(end)))) {
        return true;
      }
    }
    return false;
  }

  /// 判断 index 处的 `;` 是否在 for 循环头部内（考虑嵌套括号）
  static bool _isInForLoopHeader(String source, int index) {
    int openParen = -1;
    int depth = 0;
    for (int k = index; k >= 0; k--) {
      if (source[k] == ')') depth++;
      if (source[k] == '(') {
        if (depth > 0) {
          depth--;
        } else {
          openParen = k;
          break;
        }
      }
    }
    if (openParen == -1) return false;
    int j = openParen - 1;
    while (j >= 0 && _isWhitespace(source[j])) {
      j--;
    }
    return j >= 2 && source.substring(max(0, j - 2), j + 1) == 'for';
  }
}
