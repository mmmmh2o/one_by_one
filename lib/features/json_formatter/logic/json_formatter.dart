import 'dart:convert';

class JsonFormatResult {
  final String? output;
  final String? error;

  const JsonFormatResult({this.output, this.error});
}

class JsonFormatter {
  const JsonFormatter();

  JsonFormatResult pretty(String input) {
    try {
      final data = jsonDecode(input);
      const encoder = JsonEncoder.withIndent('  ');
      return JsonFormatResult(output: encoder.convert(data));
    } catch (_) {
      return const JsonFormatResult(error: 'JSON 格式无效');
    }
  }

  JsonFormatResult minify(String input) {
    try {
      final data = jsonDecode(input);
      return JsonFormatResult(output: jsonEncode(data));
    } catch (_) {
      return const JsonFormatResult(error: 'JSON 格式无效');
    }
  }
}
