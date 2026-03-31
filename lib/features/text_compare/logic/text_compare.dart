class TextCompareResult {
  final Set<String> onlyA;
  final Set<String> onlyB;
  final Set<String> both;

  const TextCompareResult({required this.onlyA, required this.onlyB, required this.both});
}

import '../../../core/utils/text_lines.dart';

class TextCompare {
  const TextCompare();

  TextCompareResult compare(String a, String b) {
    final setA = a.nonEmptyTrimmedLines.toSet();
    final setB = b.nonEmptyTrimmedLines.toSet();
    return TextCompareResult(
      onlyA: setA.difference(setB),
      onlyB: setB.difference(setA),
      both: setA.intersection(setB),
    );
  }
}
