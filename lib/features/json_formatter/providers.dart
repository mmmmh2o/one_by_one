import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/json_formatter.dart';

class JsonFormatterState {
  final String input;
  final String output;
  final String? error;

  const JsonFormatterState({
    this.input = '',
    this.output = '',
    this.error,
  });

  JsonFormatterState copyWith({
    String? input,
    String? output,
    String? error,
  }) {
    return JsonFormatterState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error,
    );
  }
}

class JsonFormatterNotifier extends StateNotifier<JsonFormatterState> {
  JsonFormatterNotifier() : super(const JsonFormatterState());

  final _formatter = const JsonFormatter();

  void setInput(String value) {
    state = state.copyWith(input: value, error: null);
  }

  void pretty() {
    final result = _formatter.pretty(state.input);
    state = state.copyWith(
      output: result.output ?? '',
      error: result.error,
    );
  }

  void minify() {
    final result = _formatter.minify(state.input);
    state = state.copyWith(
      output: result.output ?? '',
      error: result.error,
    );
  }
}

final jsonFormatterProvider = StateNotifierProvider<JsonFormatterNotifier, JsonFormatterState>(
  (ref) => JsonFormatterNotifier(),
);
