import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/dice_roller.dart';

class DiceState {
  final int count;
  final int sides;
  final DiceRollResult? result;

  const DiceState({
    this.count = 1,
    this.sides = 6,
    this.result,
  });

  DiceState copyWith({int? count, int? sides, DiceRollResult? result}) {
    return DiceState(
      count: count ?? this.count,
      sides: sides ?? this.sides,
      result: result ?? this.result,
    );
  }
}

class DiceNotifier extends StateNotifier<DiceState> {
  DiceNotifier() : super(const DiceState());

  void setCount(int value) {
    state = state.copyWith(count: value < 1 ? 1 : value);
  }

  void setSides(int value) {
    state = state.copyWith(sides: value < 2 ? 2 : value);
  }

  void roll() {
    final roller = DiceRoller();
    final result = roller.roll(count: state.count, sides: state.sides);
    state = state.copyWith(result: result);
  }
}

final diceProvider = StateNotifierProvider<DiceNotifier, DiceState>(
  (ref) => DiceNotifier(),
);
