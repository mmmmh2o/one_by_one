import 'dart:math';

class RandomNumberGenerator {
  final Random _random;

  RandomNumberGenerator([Random? random]) : _random = random ?? Random();

  List<int> generate({
    required int min,
    required int max,
    required int count,
  }) {
    final lower = min <= max ? min : max;
    final upper = min <= max ? max : min;
    if (count <= 0) return [];
    final numberRange = upper - lower + 1;
    final results = <int>[];
    for (var i = 0; i < count; i++) {
      results.add(lower + _random.nextInt(numberRange));
    }
    return results;
  }
}
