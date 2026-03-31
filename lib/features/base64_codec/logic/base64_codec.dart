import 'dart:convert';

class Base64CodecResult {
  final String? output;
  final String? error;

  const Base64CodecResult({this.output, this.error});
}

class TextBase64Codec {
  const TextBase64Codec();

  Base64CodecResult encode(String input) {
    try {
      final output = base64Encode(utf8.encode(input));
      return Base64CodecResult(output: output);
    } catch (_) {
      return const Base64CodecResult(error: 'Base64 编码失败');
    }
  }

  Base64CodecResult decode(String input) {
    try {
      final output = utf8.decode(base64Decode(input.trim()));
      return Base64CodecResult(output: output);
    } catch (_) {
      return const Base64CodecResult(error: 'Base64 解码失败，请检查输入');
    }
  }
}
