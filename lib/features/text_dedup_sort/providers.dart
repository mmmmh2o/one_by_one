import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/text_dedup_sorter.dart';

class TextDedupSortState {
  final String input;
  final String output;
  final bool ascending;
  final bool ignoreCase;
  final int totalLines;
  final int uniqueLines;

  const TextDedupSortState({
    this.input = '',
    this.output = '',
    this.ascending = true,
    this.ignoreCase = false,
    this.totalLines = 0,
    this.uniqueLines = 0,
  });

  TextDedupSortState copyWith({
    String? input,
    String? output,
    bool? ascending,
    bool? ignoreCase,
    int? totalLines,
    int? uniqueLines,
  }) {
    return TextDedupSortState(
      input: input ?? this.input,
      output: output ?? this.output,
      ascending: ascending ?? this.ascending,
      ignoreCase: ignoreCase ?? this.ignoreCase,
      totalLines: totalLines ?? this.totalLines,
      uniqueLines: uniqueLines ?? this.uniqueLines,
    );
  }
}

class TextDedupSortNotifier extends StateNotifier<TextDedupSortState> {
  TextDedupSortNotifier() : super(const TextDedupSortState());

  final _sorter = const TextDedupSorter();

  void setInput(String value) {
    state = state.copyWith(input: value);
  }

  void setAscending(bool value) {
    state = state.copyWith(ascending: value);
  }

  void setIgnoreCase(bool value) {
    state = state.copyWith(ignoreCase: value);
  }

  void process() {
    final result = _sorter.process(
      state.input,
      ascending: state.ascending,
      ignoreCase: state.ignoreCase,
    );
    state = state.copyWith(
      output: result.output,
      totalLines: result.totalLines,
      uniqueLines: result.uniqueLines,
    );
  }
}

final textDedupSortProvider = StateNotifierProvider<TextDedupSortNotifier, TextDedupSortState>(
  (ref) => TextDedupSortNotifier(),
);
