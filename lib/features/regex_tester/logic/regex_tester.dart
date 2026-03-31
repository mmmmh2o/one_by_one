class RegexMatchItem {
  final String value;
  final int start;
  final int end;

  const RegexMatchItem({
    required this.value,
    required this.start,
    required this.end,
  });
}

class RegexTestResult {
  final List<RegexMatchItem> matches;
  final String? error;

  const RegexTestResult({
    this.matches = const [],
    this.error,
  });
}

class RegexTester {
  const RegexTester();

  RegexTestResult test({
    required String pattern,
    required String input,
    required bool caseSensitive,
    required bool multiLine,
    required bool dotAll,
  }) {
    if (pattern.trim().isEmpty) {
      return const RegexTestResult(error: '请输入正则表达式');
    }

    try {
      final regex = RegExp(
        pattern,
        caseSensitive: caseSensitive,
        multiLine: multiLine,
        dotAll: dotAll,
      );

      final matches = regex
          .allMatches(input)
          .map(
            (m) => RegexMatchItem(
              value: m.group(0) ?? '',
              start: m.start,
              end: m.end,
            ),
          )
          .toList();

      return RegexTestResult(matches: matches);
    } catch (_) {
      return const RegexTestResult(error: '正则表达式无效');
    }
  }
}
