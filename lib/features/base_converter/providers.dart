import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/base_converter.dart';

class BaseConverterState {
  final String input;
  final int fromBase;
  final int toBase;
  final String output;
  final String? error;

  const BaseConverterState({
    this.input = '',
    this.fromBase = 10,
    this.toBase = 2,
    this.output = '',
    this.error,
  });

  BaseConverterState copyWith({
    String? input,
    int? fromBase,
    int? toBase,
    String? output,
    String? error,
  }) {
    return BaseConverterState(
      input: input ?? this.input,
      fromBase: fromBase ?? this.fromBase,
      toBase: toBase ?? this.toBase,
      output: output ?? this.output,
      error: error,
    );
  }
}

class BaseConverterNotifier extends StateNotifier<BaseConverterState> {
  BaseConverterNotifier() : super(const BaseConverterState());

  final _converter = const BaseConverter();

  void updateInput(String value) {
    state = state.copyWith(input: value, error: null);
  }

  void setFromBase(int value) {
    state = state.copyWith(fromBase: value, error: null);
  }

  void setToBase(int value) {
    state = state.copyWith(toBase: value, error: null);
  }

  void swapBase() {
    state = state.copyWith(
      fromBase: state.toBase,
      toBase: state.fromBase,
      error: null,
    );
  }

  void convert() {
    final result = _converter.convert(
      input: state.input,
      fromBase: state.fromBase,
      toBase: state.toBase,
    );
    state = state.copyWith(
      output: result.output ?? '',
      error: result.error,
    );
  }
}

final baseConverterProvider = StateNotifierProvider<BaseConverterNotifier, BaseConverterState>(
  (ref) => BaseConverterNotifier(),
);
