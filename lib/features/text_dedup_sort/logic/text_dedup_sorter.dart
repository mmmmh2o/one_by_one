class TextDedupSortResult {
  final String output;
  final int totalLines;
  final int uniqueLines;

  const TextDedupSortResult({
    required this.output,
    required this.totalLines,
    required this.uniqueLines,
  });
}

class TextDedupSorter {
  const TextDedupSorter();

  TextDedupSortResult process(
    String input, {
    bool ascending = true,
    bool ignoreCase = false,
  }) {
    final lines = input
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final map = <String, String>{};
    for (final line in lines) {
      final key = ignoreCase ? line.toLowerCase() : line;
      map.putIfAbsent(key, () => line);
    }

    final unique = map.values.toList();
    unique.sort((a, b) => ignoreCase ? a.toLowerCase().compareTo(b.toLowerCase()) : a.compareTo(b));
    if (!ascending) {
      unique.setAll(0, unique.reversed);
    }

    return TextDedupSortResult(
      output: unique.join('\n'),
      totalLines: lines.length,
      uniqueLines: unique.length,
    );
  }
}
