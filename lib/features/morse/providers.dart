import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/morse_codec.dart';

class MorseState {
  final String input;
  final String output;

  const MorseState({
    this.input = '',
    this.output = '',
  });

  MorseState copyWith({String? input, String? output}) {
    return MorseState(
      input: input ?? this.input,
      output: output ?? this.output,
    );
  }
}

class MorseNotifier extends StateNotifier<MorseState> {
  MorseNotifier() : super(const MorseState());

  final _codec = const MorseCodec();

  void setInput(String value) {
    state = state.copyWith(input: value);
  }

  void encode() {
    state = state.copyWith(output: _codec.encode(state.input));
  }

  void decode() {
    state = state.copyWith(output: _codec.decode(state.input));
  }
}

final morseProvider = StateNotifierProvider<MorseNotifier, MorseState>(
  (ref) => MorseNotifier(),
);
