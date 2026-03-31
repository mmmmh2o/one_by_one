import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/calculator_engine.dart';

class CalculatorState {
  final double left;
  final double right;
  final CalcOperator operator;
  final String output;
  final String? error;

  const CalculatorState({
    this.left = 0,
    this.right = 0,
    this.operator = CalcOperator.add,
    this.output = '0',
    this.error,
  });

  CalculatorState copyWith({
    double? left,
    double? right,
    CalcOperator? operator,
    String? output,
    String? error,
  }) {
    return CalculatorState(
      left: left ?? this.left,
      right: right ?? this.right,
      operator: operator ?? this.operator,
      output: output ?? this.output,
      error: error,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(const CalculatorState());

  final _engine = const CalculatorEngine();

  void setLeft(double value) {
    state = state.copyWith(left: value, error: null);
  }

  void setRight(double value) {
    state = state.copyWith(right: value, error: null);
  }

  void setOperator(CalcOperator value) {
    state = state.copyWith(operator: value, error: null);
  }

  void compute() {
    final result = _engine.calculate(
      left: state.left,
      right: state.right,
      operator: state.operator,
    );

    state = state.copyWith(
      output: result.value?.toString() ?? state.output,
      error: result.error,
    );
  }
}

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>(
  (ref) => CalculatorNotifier(),
);
