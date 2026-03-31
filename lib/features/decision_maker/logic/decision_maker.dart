import 'dart:math';

class DecisionMaker {
  final Random _random;

  DecisionMaker([Random? random]) : _random = random ?? Random();

  String? pick(List<String> options) {
    final clean = options.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (clean.isEmpty) return null;
    return clean[_random.nextInt(clean.length)];
  }
}
