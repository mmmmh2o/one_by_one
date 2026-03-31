import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/eat_what_picker.dart';

class EatWhatState {
  final List<String> options;
  final String suggestion;

  const EatWhatState({
    this.options = const ['牛肉面', '盖饭', '沙拉', '饺子', '轻食'],
    this.suggestion = '点击按钮开始推荐',
  });

  EatWhatState copyWith({List<String>? options, String? suggestion}) {
    return EatWhatState(
      options: options ?? this.options,
      suggestion: suggestion ?? this.suggestion,
    );
  }
}

class EatWhatNotifier extends StateNotifier<EatWhatState> {
  EatWhatNotifier() : super(const EatWhatState());

  final _picker = EatWhatPicker();

  void setOptions(String raw) {
    final options = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    state = state.copyWith(options: options);
  }

  void suggest() {
    final next = _picker.pick(state.options);
    state = state.copyWith(suggestion: next);
  }
}

final eatWhatProvider = StateNotifierProvider<EatWhatNotifier, EatWhatState>(
  (ref) => EatWhatNotifier(),
);
