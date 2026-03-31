import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/date_calculator.dart';

class DateCalculatorState {
  final DateTime from;
  final DateTime to;
  final DateDiffResult? result;

  const DateCalculatorState({
    required this.from,
    required this.to,
    this.result,
  });

  DateCalculatorState copyWith({
    DateTime? from,
    DateTime? to,
    DateDiffResult? result,
  }) {
    return DateCalculatorState(
      from: from ?? this.from,
      to: to ?? this.to,
      result: result ?? this.result,
    );
  }
}

class DateCalculatorNotifier extends StateNotifier<DateCalculatorState> {
  DateCalculatorNotifier()
    : super(
        DateCalculatorState(
          from: DateTime.now(),
          to: DateTime.now(),
        ),
      );

  final _calculator = const DateCalculator();

  void setFrom(DateTime value) {
    state = state.copyWith(from: value, result: null);
  }

  void setTo(DateTime value) {
    state = state.copyWith(to: value, result: null);
  }

  void calculate() {
    final result = _calculator.diff(state.from, state.to);
    state = state.copyWith(result: result);
  }
}

final dateCalculatorProvider = StateNotifierProvider<DateCalculatorNotifier, DateCalculatorState>(
  (ref) => DateCalculatorNotifier(),
);
