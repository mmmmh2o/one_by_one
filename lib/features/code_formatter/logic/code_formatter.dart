/// 代码格式化 — 纯 Dart 逻辑层
///
/// 支持 JSON 格式化/压缩、基础 HTML/CSS/JS 格式化
enum CodeFormatType {
  json('JSON'),
  html('HTML'),
  css('CSS'),
  javascript('JavaScript');

  const CodeFormatType(this.label);
  final String label;
}

class CodeFormatterEngine {
  const CodeFormatterEngine();

  /// 格式化
  String format(String input, CodeFormatType type, {int indentSize = 2}) {
    switch (type) {
      case CodeFormatType.json:
        return _formatJson(input, indentSize);
      case CodeFormatType.html:
        return _formatHtml(input, indentSize);
      case CodeFormatType.css:
        return _formatCss(input, indentSize);
      case CodeFormatType.javascript:
        return _formatJs(input, indentSize);
    }
  }

  /// 压缩
  String compress(String input, CodeFormatType type) {
    switch (type) {
      case CodeFormatType.json:
        return _compressJson(input);
      case CodeFormatType.html:
        return _compressHtml(input);
      case CodeFormatType.css:
        return _compressCss(input);
      case CodeFormatType.javascript:
        return _compressJs(input);
    }
  }

  // ── JSON ──────────────────────────────────────────────

  String _formatJson(String input, int indent) {
    try {
      final decoded = _jsonDecode(input);
      final indentStr = ' ' * indent;
      return _encodeJson(decoded, indentStr, 0);
    } catch (e) {
      return 'JSON 解析错误: $e';
    }
  }

  String _compressJson(String input) {
    try {
      final decoded = _jsonDecode(input);
      return _encodeJsonCompact(decoded);
    } catch (e) {
      return 'JSON 解析错误: $e';
    }
  }

  dynamic _jsonDecode(String input) {
    // 简易 JSON 解析器（不依赖 dart:convert）
    final parser = _JsonParser(input);
    return parser.parse();
  }

  String _encodeJson(dynamic value, String indentStr, int depth) {
    final pad = indentStr * depth;
    final innerPad = indentStr * (depth + 1);

    if (value == null) return 'null';
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    if (value is String) return '"${_escapeJsonString(value)}"';

    if (value is List) {
      if (value.isEmpty) return '[]';
      final items = value.map((e) => '$innerPad${_encodeJson(e, indentStr, depth + 1)}');
      return '[\n${items.join(',\n')}\n$pad]';
    }

    if (value is Map) {
      if (value.isEmpty) return '{}';
      final entries = value.entries.map((e) {
        final key = '"${_escapeJsonString(e.key.toString())}"';
        final val = _encodeJson(e.value, indentStr, depth + 1);
        return '$innerPad$key: $val';
      });
      return '{\n${entries.join(',\n')}\n$pad}';
    }

    return value.toString();
  }

  String _encodeJsonCompact(dynamic value) {
    if (value == null) return 'null';
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    if (value is String) return '"${_escapeJsonString(value)}"';
    if (value is List) {
      return '[${value.map(_encodeJsonCompact).join(',')}]';
    }
    if (value is Map) {
      final entries = value.entries
          .map((e) => '"${_escapeJsonString(e.key.toString())}":${_encodeJsonCompact(e.value)}');
      return '{${entries.join(',')}}';
    }
    return value.toString();
  }

  String _escapeJsonString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  // ── HTML ──────────────────────────────────────────────

  String _formatHtml(String input, int indent) {
    final indentStr = ' ' * indent;
    final buf = StringBuffer();
    int depth = 0;
    final selfClosing = {
      'br', 'hr', 'img', 'input', 'meta', 'link', 'area', 'base', 'col',
      'embed', 'source', 'track', 'wbr',
    };

    // 简单的标签分割
    final parts = input.split(RegExp(r'(</?[^>]+>)'));

    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('</')) {
        depth = (depth - 1).clamp(0, 999);
        buf.writeln('${indentStr * depth}$trimmed');
      } else if (trimmed.startsWith('<')) {
        final tagMatch = RegExp(r'^<(\w+)').firstMatch(trimmed);
        final tagName = tagMatch?.group(1)?.toLowerCase() ?? '';
        final isSelfClosing = selfClosing.contains(tagName) ||
            trimmed.endsWith('/>') ||
            trimmed.startsWith('<!');

        buf.write('${indentStr * depth}$trimmed');
        if (!isSelfClosing && !trimmed.startsWith('<!')) {
          buf.writeln();
          depth++;
        } else {
          buf.writeln();
        }
      } else {
        // 文本内容
        buf.writeln('${indentStr * depth}$trimmed');
      }
    }
    return buf.toString().trimRight();
  }

  String _compressHtml(String input) {
    return input
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'>\s+<'), '><')
        .trim();
  }

  // ── CSS ───────────────────────────────────────────────

  String _formatCss(String input, int indent) {
    final indentStr = ' ' * indent;
    final buf = StringBuffer();
    int depth = 0;

    // 先压缩空白再格式化
    final compact = input.replaceAll(RegExp(r'\s+'), ' ').trim();
    int i = 0;

    while (i < compact.length) {
      final ch = compact[i];
      if (ch == '{') {
        buf.write(' {\n');
        depth++;
        buf.write(indentStr * depth);
        i++;
      } else if (ch == '}') {
        buf.write('\n');
        depth = (depth - 1).clamp(0, 999);
        buf.write('${indentStr * depth}}\n');
        if (i + 1 < compact.length) buf.write('\n${indentStr * depth}');
        i++;
      } else if (ch == ';') {
        buf.write(';\n');
        buf.write(indentStr * depth);
        i++;
      } else {
        buf.write(ch);
        i++;
      }
    }
    return buf.toString().trimRight();
  }

  String _compressCss(String input) {
    return input
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\s*\{\s*'), '{')
        .replaceAll(RegExp(r'\s*\}\s*'), '}')
        .replaceAll(RegExp(r'\s*;\s*'), ';')
        .replaceAll(RegExp(r'\s*:\s*'), ':')
        .replaceAll(RegExp(r'\s*,\s*'), ',')
        .trim();
  }

  // ── JavaScript ────────────────────────────────────────

  String _formatJs(String input, int indent) {
    final indentStr = ' ' * indent;
    final buf = StringBuffer();
    int depth = 0;

    // 移除注释
    final noComments = input
        .replaceAll(RegExp(r'//.*$', multiLine: true), '')
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');

    final compact = noComments.replaceAll(RegExp(r'\s+'), ' ').trim();
    int i = 0;

    while (i < compact.length) {
      final ch = compact[i];
      if (ch == '{' || ch == '[' || ch == '(') {
        buf.write('$ch\n');
        depth++;
        buf.write(indentStr * depth);
        i++;
      } else if (ch == '}' || ch == ']' || ch == ')') {
        buf.write('\n');
        depth = (depth - 1).clamp(0, 999);
        buf.write('${indentStr *depth}$ch');
        i++;
        if (i < compact.length && compact[i] == ',') {
          buf.write(',');
          i++;
        }
      } else if (ch == ';') {
        buf.write(';\n');
        if (i + 1 < compact.length && compact[i + 1] != '}' && compact[i + 1] != ']') {
          buf.write(indentStr * depth);
        }
        i++;
      } else if (ch == ',') {
        buf.write(',\n');
        buf.write(indentStr * depth);
        i++;
      } else {
        buf.write(ch);
        i++;
      }
    }
    return buf.toString().trimRight();
  }

  String _compressJs(String input) {
    return input
        .replaceAll(RegExp(r'//.*$', multiLine: true), '')
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\s*([{}()\[\];,])\s*'), r'\1')
        .trim();
  }
}

/// 简易 JSON 解析器（纯 Dart，无外部依赖）
class _JsonParser {
  final String _input;
  int _pos = 0;

  _JsonParser(this._input);

  dynamic parse() {
    _skipWhitespace();
    final result = _parseValue();
    _skipWhitespace();
    return result;
  }

  dynamic _parseValue() {
    _skipWhitespace();
    if (_pos >= _input.length) throw FormatException('意外的输入结束');

    final ch = _input[_pos];
    if (ch == '"') return _parseString();
    if (ch == '{') return _parseObject();
    if (ch == '[') return _parseArray();
    if (ch == 't' || ch == 'f') return _parseBool();
    if (ch == 'n') return _parseNull();
    return _parseNumber();
  }

  String _parseString() {
    _pos++; // skip "
    final buf = StringBuffer();
    while (_pos < _input.length) {
      final ch = _input[_pos];
      if (ch == '\\') {
        _pos++;
        if (_pos >= _input.length) break;
        final esc = _input[_pos];
        switch (esc) {
          case '"': buf.write('"'); break;
          case '\\': buf.write('\\'); break;
          case '/': buf.write('/'); break;
          case 'n': buf.write('\n'); break;
          case 'r': buf.write('\r'); break;
          case 't': buf.write('\t'); break;
          case 'b': buf.write('\b'); break;
          case 'f': buf.write('\f'); break;
          case 'u':
            final hex = _input.substring(_pos + 1, _pos + 5);
            buf.writeCharCode(int.parse(hex, radix: 16));
            _pos += 4;
            break;
          default: buf.write(esc);
        }
      } else if (ch == '"') {
        _pos++;
        return buf.toString();
      } else {
        buf.write(ch);
      }
      _pos++;
    }
    throw FormatException('未闭合的字符串');
  }

  Map<String, dynamic> _parseObject() {
    _pos++; // skip {
    _skipWhitespace();
    final map = <String, dynamic>{};
    if (_pos < _input.length && _input[_pos] == '}') {
      _pos++;
      return map;
    }
    while (true) {
      _skipWhitespace();
      final key = _parseString();
      _skipWhitespace();
      if (_input[_pos] != ':') throw FormatException('期望 :');
      _pos++;
      final value = _parseValue();
      map[key] = value;
      _skipWhitespace();
      if (_input[_pos] == ',') {
        _pos++;
      } else {
        break;
      }
    }
    _skipWhitespace();
    if (_input[_pos] != '}') throw FormatException('期望 }');
    _pos++;
    return map;
  }

  List<dynamic> _parseArray() {
    _pos++; // skip [
    _skipWhitespace();
    final list = <dynamic>[];
    if (_pos < _input.length && _input[_pos] == ']') {
      _pos++;
      return list;
    }
    while (true) {
      list.add(_parseValue());
      _skipWhitespace();
      if (_pos < _input.length && _input[_pos] == ',') {
        _pos++;
      } else {
        break;
      }
    }
    _skipWhitespace();
    if (_pos >= _input.length || _input[_pos] != ']') throw FormatException('期望 ]');
    _pos++;
    return list;
  }

  bool _parseBool() {
    if (_input.startsWith('true', _pos)) {
      _pos += 4;
      return true;
    }
    if (_input.startsWith('false', _pos)) {
      _pos += 5;
      return false;
    }
    throw FormatException('无效的布尔值');
  }

  dynamic _parseNull() {
    if (_input.startsWith('null', _pos)) {
      _pos += 4;
      return null;
    }
    throw FormatException('无效的 null');
  }

  num _parseNumber() {
    final start = _pos;
    if (_input[_pos] == '-') _pos++;
    while (_pos < _input.length && _input[_pos].contains(RegExp(r'[0-9]'))) _pos++;
    if (_pos < _input.length && _input[_pos] == '.') {
      _pos++;
      while (_pos < _input.length && _input[_pos].contains(RegExp(r'[0-9]'))) _pos++;
    }
    if (_pos < _input.length && (_input[_pos] == 'e' || _input[_pos] == 'E')) {
      _pos++;
      if (_pos < _input.length && (_input[_pos] == '+' || _input[_pos] == '-')) _pos++;
      while (_pos < _input.length && _input[_pos].contains(RegExp(r'[0-9]'))) _pos++;
    }
    final str = _input.substring(start, _pos);
    if (str.contains('.')) return double.parse(str);
    return int.parse(str);
  }

  void _skipWhitespace() {
    while (_pos < _input.length && _input[_pos].trim().isEmpty) _pos++;
  }
}
