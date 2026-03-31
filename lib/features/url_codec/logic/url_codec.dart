class UrlCodecResult {
  final String? output;
  final String? error;

  const UrlCodecResult({this.output, this.error});
}

class UrlCodecTool {
  const UrlCodecTool();

  UrlCodecResult encode(String input) {
    try {
      return UrlCodecResult(output: Uri.encodeComponent(input));
    } catch (_) {
      return const UrlCodecResult(error: 'URL 编码失败');
    }
  }

  UrlCodecResult decode(String input) {
    try {
      return UrlCodecResult(output: Uri.decodeComponent(input));
    } catch (_) {
      return const UrlCodecResult(error: 'URL 解码失败，请检查输入');
    }
  }
}
