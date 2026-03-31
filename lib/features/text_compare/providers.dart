import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/text_compare.dart';

class TextCompareState {
  final String left;
  final String right;
  final TextCompareResult? result;

  const TextCompareState({this.left = '', this.right = '', this.result});

  TextCompareState copyWith({String? left, String? right, TextCompareResult? result}) {
    return TextCompareState(
      left: left ?? this.left,
      right: right ?? this.right,
      result: result ?? this.result,
    );
  }
}

class TextCompareNotifier extends StateNotifier<TextCompareState> {
  TextCompareNotifier() : super(const TextCompareState());

  final _compare = const TextCompare();

  void setLeft(String value) {
    state = state.copyWith(left: value);
  }

  void setRight(String value) {
    state = state.copyWith(right: value);
  }

  void run() {
    state = state.copyWith(result: _compare.compare(state.left, state.right));
  }
}

final textCompareProvider = StateNotifierProvider<TextCompareNotifier, TextCompareState>(
  (ref) => TextCompareNotifier(),
);
