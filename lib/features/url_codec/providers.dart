import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/url_codec.dart';

class UrlCodecState {
  final String input;
  final String output;
  final String? error;

  const UrlCodecState({
    this.input = '',
    this.output = '',
    this.error,
  });

  UrlCodecState copyWith({String? input, String? output, String? error}) {
    return UrlCodecState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error,
    );
  }
}

class UrlCodecNotifier extends StateNotifier<UrlCodecState> {
  UrlCodecNotifier() : super(const UrlCodecState());

  final _codec = const UrlCodecTool();

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

final urlCodecProvider = StateNotifierProvider<UrlCodecNotifier, UrlCodecState>(
  (ref) => UrlCodecNotifier(),
);
