import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/base64_codec.dart';

class Base64CodecState {
  final String input;
  final String output;
  final String? error;

  const Base64CodecState({
    this.input = '',
    this.output = '',
    this.error,
  });

  Base64CodecState copyWith({String? input, String? output, String? error}) {
    return Base64CodecState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error,
    );
  }
}

class Base64CodecNotifier extends StateNotifier<Base64CodecState> {
  Base64CodecNotifier() : super(const Base64CodecState());

  final _codec = const TextBase64Codec();

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

final base64CodecProvider = StateNotifierProvider<Base64CodecNotifier, Base64CodecState>(
  (ref) => Base64CodecNotifier(),
);
