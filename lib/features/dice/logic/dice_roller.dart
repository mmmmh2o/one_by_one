import 'dart:math';

class DiceRollResult {
  final List<int> values;

  const DiceRollResult(this.values);

  int get total => values.fold(0, (sum, current) => sum + current);
}

class DiceRoller {
  final Random _random;

  DiceRoller([Random? random]) : _random = random ?? Random();

  DiceRollResult roll({int count = 1, int sides = 6}) {
    final safeCount = count < 1 ? 1 : count;
    final safeSides = sides < 2 ? 2 : sides;
    final values = List<int>.generate(
      safeCount,
      (_) => _random.nextInt(safeSides) + 1,
    );
    return DiceRollResult(values);
  }
}
