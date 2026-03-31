class TextCompareResult {
  final Set<String> onlyA;
  final Set<String> onlyB;
  final Set<String> both;

  const TextCompareResult({required this.onlyA, required this.onlyB, required this.both});
}

class TextCompare {
  const TextCompare();

  TextCompareResult compare(String a, String b) {
    final setA = a.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
    final setB = b.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
    return TextCompareResult(
      onlyA: setA.difference(setB),
      onlyB: setB.difference(setA),
      both: setA.intersection(setB),
    );
  }
}
