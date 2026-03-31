class TextStatsResult {
  final int chars;
  final int charsNoSpaces;
  final int words;
  final int lines;

  const TextStatsResult({
    required this.chars,
    required this.charsNoSpaces,
    required this.words,
    required this.lines,
  });
}

class TextStats {
  const TextStats();

  TextStatsResult analyze(String input) {
    final trimmed = input.trim();
    final words = trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
    final lines = input.isEmpty ? 0 : input.split('\n').length;
    final chars = input.length;
    final charsNoSpaces = input.replaceAll(RegExp(r'\s+'), '').length;
    return TextStatsResult(
      chars: chars,
      charsNoSpaces: charsNoSpaces,
      words: words,
      lines: lines,
    );
  }
}
