import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/unicode_codec.dart';

class UnicodeCodecState {
  final String input;
  final String output;
  final String? error;

  const UnicodeCodecState({
    this.input = '',
    this.output = '',
    this.error,
  });

  UnicodeCodecState copyWith({String? input, String? output, String? error}) {
    return UnicodeCodecState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error,
    );
  }
}

class UnicodeCodecNotifier extends StateNotifier<UnicodeCodecState> {
  UnicodeCodecNotifier() : super(const UnicodeCodecState());

  final _codec = const UnicodeCodecTool();

  void setInput(String value) {
    state = state.copyWith(input: value, error: null);
  }

  void encode() {
    final result = _codec.encode(state.input);
    state = state.copyWith(output: result.output ?? '', error: result.error);
  }

  void decode() {
    final result = _codec.decode(state.input);
    state = state.copyWith(output: result.output ?? '', error: result.error);
  }
}

final unicodeCodecProvider = StateNotifierProvider<UnicodeCodecNotifier, UnicodeCodecState>(
  (ref) => UnicodeCodecNotifier(),
);
