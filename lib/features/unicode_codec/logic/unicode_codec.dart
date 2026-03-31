class UnicodeCodecResult {
  final String? output;
  final String? error;

  const UnicodeCodecResult({this.output, this.error});
}

class UnicodeCodecTool {
  const UnicodeCodecTool();

  UnicodeCodecResult encode(String input) {
    try {
      final output = input.runes
          .map((r) => '\\u{${r.toRadixString(16).toUpperCase()}}')
          .join();
      return UnicodeCodecResult(output: output);
    } catch (_) {
      return const UnicodeCodecResult(error: 'Unicode 编码失败');
    }
  }

  UnicodeCodecResult decode(String input) {
    try {
      var output = input;

      final bracePattern = RegExp(r'\\u\{([0-9a-fA-F]{1,6})\}');
      output = output.replaceAllMapped(bracePattern, (m) {
        final code = int.parse(m.group(1)!, radix: 16);
        if (code < 0 || code > 0x10FFFF) {
          throw const FormatException('invalid code point');
        }
        return String.fromCharCode(code);
      });

      final plainPattern = RegExp(r'\\u([0-9a-fA-F]{4})');
      output = output.replaceAllMapped(plainPattern, (m) {
        final code = int.parse(m.group(1)!, radix: 16);
        return String.fromCharCode(code);
      });

      return UnicodeCodecResult(output: output);
    } catch (_) {
      return const UnicodeCodecResult(error: 'Unicode 解码失败，请检查输入');
    }
  }
}
