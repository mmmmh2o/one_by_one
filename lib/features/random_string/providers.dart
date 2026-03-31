import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/random_string_generator.dart';

class RandomStringState {
  final int length;
  final bool useLower;
  final bool useUpper;
  final bool useDigits;
  final bool useSymbols;
  final String output;
  final String? error;

  const RandomStringState({
    this.length = 16,
    this.useLower = true,
    this.useUpper = true,
    this.useDigits = true,
    this.useSymbols = false,
    this.output = '',
    this.error,
  });

  RandomStringState copyWith({
    int? length,
    bool? useLower,
    bool? useUpper,
    bool? useDigits,
    bool? useSymbols,
    String? output,
    String? error,
  }) {
    return RandomStringState(
      length: length ?? this.length,
      useLower: useLower ?? this.useLower,
      useUpper: useUpper ?? this.useUpper,
      useDigits: useDigits ?? this.useDigits,
      useSymbols: useSymbols ?? this.useSymbols,
      output: output ?? this.output,
      error: error,
    );
  }
}

class RandomStringNotifier extends StateNotifier<RandomStringState> {
  RandomStringNotifier() : super(const RandomStringState());

  final _generator = RandomStringGenerator();

  void setLength(int value) {
    state = state.copyWith(length: value.clamp(1, 256), error: null);
  }

  void setUseLower(bool value) => state = state.copyWith(useLower: value, error: null);
  void setUseUpper(bool value) => state = state.copyWith(useUpper: value, error: null);
  void setUseDigits(bool value) => state = state.copyWith(useDigits: value, error: null);
  void setUseSymbols(bool value) => state = state.copyWith(useSymbols: value, error: null);

  void generate() {
    if (!(state.useLower || state.useUpper || state.useDigits || state.useSymbols)) {
      state = state.copyWith(error: '请至少选择一种字符集', output: '');
      return;
    }

    final output = _generator.generate(
      length: state.length,
      useLower: state.useLower,
      useUpper: state.useUpper,
      useDigits: state.useDigits,
      useSymbols: state.useSymbols,
    );

    state = state.copyWith(output: output, error: null);
  }
}

final randomStringProvider = StateNotifierProvider<RandomStringNotifier, RandomStringState>(
  (ref) => RandomStringNotifier(),
);
