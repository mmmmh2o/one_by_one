import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/bmi_calculator.dart';

class BmiState {
  final double heightCm;
  final double weightKg;
  final BmiResult? result;

  const BmiState({
    this.heightCm = 170,
    this.weightKg = 60,
    this.result,
  });

  BmiState copyWith({double? heightCm, double? weightKg, BmiResult? result}) {
    return BmiState(
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      result: result ?? this.result,
    );
  }
}

class BmiNotifier extends StateNotifier<BmiState> {
  BmiNotifier() : super(const BmiState());

  final _calculator = const BmiCalculator();

  void setHeight(double value) {
    state = state.copyWith(heightCm: value, result: null);
  }

  void setWeight(double value) {
    state = state.copyWith(weightKg: value, result: null);
  }

  void calculate() {
    final result = _calculator.calculate(
      heightCm: state.heightCm,
      weightKg: state.weightKg,
    );
    state = state.copyWith(result: result);
  }
}

final bmiProvider = StateNotifierProvider<BmiNotifier, BmiState>(
  (ref) => BmiNotifier(),
);
