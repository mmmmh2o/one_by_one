import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/simplified_convert_logic.dart';

enum ConvertDirection { s2t, t2s }

class SimplifiedConvertState {
  final String input;
  final String output;
  final ConvertDirection direction;

  const SimplifiedConvertState({
    this.input = '',
    this.output = '',
    this.direction = ConvertDirection.s2t,
  });

  SimplifiedConvertState copyWith({
    String? input,
    String? output,
    ConvertDirection? direction,
  }) {
    return SimplifiedConvertState(
      input: input ?? this.input,
      output: output ?? this.output,
      direction: direction ?? this.direction,
    );
  }
}

class SimplifiedConvertNotifier
    extends StateNotifier<SimplifiedConvertState> {
  SimplifiedConvertNotifier() : super(const SimplifiedConvertState());

  final _logic = const SimplifiedConvertLogic();

  void setInput(String text) {
    state = state.copyWith(input: text);
    convert();
  }

  void setDirection(ConvertDirection dir) {
    state = state.copyWith(direction: dir);
    if (state.input.isNotEmpty) convert();
  }

  void convert() {
    final result = state.direction == ConvertDirection.s2t
        ? _logic.toTraditional(state.input)
        : _logic.toSimplified(state.input);
    state = state.copyWith(output: result);
  }

  void swap() {
    final newDir = state.direction == ConvertDirection.s2t
        ? ConvertDirection.t2s
        : ConvertDirection.s2t;
    state = SimplifiedConvertState(
      input: state.output,
      output: state.input,
      direction: newDir,
    );
  }
}

final simplifiedConvertProvider =
    StateNotifierProvider<SimplifiedConvertNotifier, SimplifiedConvertState>(
  (ref) => SimplifiedConvertNotifier(),
);
