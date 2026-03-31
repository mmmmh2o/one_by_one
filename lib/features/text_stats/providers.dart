import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/text_stats.dart';

class TextStatsState {
  final String input;
  final TextStatsResult result;

  const TextStatsState({
    this.input = '',
    this.result = const TextStatsResult(chars: 0, charsNoSpaces: 0, words: 0, lines: 0),
  });

  TextStatsState copyWith({String? input, TextStatsResult? result}) {
    return TextStatsState(
      input: input ?? this.input,
      result: result ?? this.result,
    );
  }
}

class TextStatsNotifier extends StateNotifier<TextStatsState> {
  TextStatsNotifier() : super(const TextStatsState());

  final _stats = const TextStats();

  void setInput(String value) {
    state = state.copyWith(
      input: value,
      result: _stats.analyze(value),
    );
  }
}

final textStatsProvider = StateNotifierProvider<TextStatsNotifier, TextStatsState>(
  (ref) => TextStatsNotifier(),
);
