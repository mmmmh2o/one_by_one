import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/decision_maker.dart';

class DecisionState {
  final List<String> options;
  final String? result;
  final String? error;

  const DecisionState({
    this.options = const ['吃饭', '健身', '学习'],
    this.result,
    this.error,
  });

  DecisionState copyWith({
    List<String>? options,
    String? result,
    String? error,
  }) {
    return DecisionState(
      options: options ?? this.options,
      result: result ?? this.result,
      error: error,
    );
  }
}

class DecisionNotifier extends StateNotifier<DecisionState> {
  DecisionNotifier() : super(const DecisionState());

  final _maker = DecisionMaker();

  void setOptions(String raw) {
    final options = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    state = state.copyWith(options: options, error: null);
  }

  void pick() {
    final result = _maker.pick(state.options);
    if (result == null) {
      state = state.copyWith(error: '请至少输入一个选项');
      return;
    }
    state = state.copyWith(result: result, error: null);
  }
}

final decisionProvider = StateNotifierProvider<DecisionNotifier, DecisionState>(
  (ref) => DecisionNotifier(),
);
