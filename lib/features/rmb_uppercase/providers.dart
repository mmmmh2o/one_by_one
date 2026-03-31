import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/rmb_uppercase_converter.dart';

class RmbUppercaseState {
  final double amount;
  final String output;

  const RmbUppercaseState({
    this.amount = 0,
    this.output = '',
  });

  RmbUppercaseState copyWith({double? amount, String? output}) {
    return RmbUppercaseState(
      amount: amount ?? this.amount,
      output: output ?? this.output,
    );
  }
}

class RmbUppercaseNotifier extends StateNotifier<RmbUppercaseState> {
  RmbUppercaseNotifier() : super(const RmbUppercaseState());

  final _converter = const RmbUppercaseConverter();

  void setAmount(double value) {
    state = state.copyWith(amount: value);
  }

  void convert() {
    state = state.copyWith(output: _converter.convert(state.amount));
  }
}

final rmbUppercaseProvider = StateNotifierProvider<RmbUppercaseNotifier, RmbUppercaseState>(
  (ref) => RmbUppercaseNotifier(),
);
