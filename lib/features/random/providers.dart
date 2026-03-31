import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/random_number_generator.dart';

class RandomSettings {
  final int count;
  final int min;
  final int max;

  const RandomSettings({
    this.count = 1,
    this.min = 1,
    this.max = 100,
  });

  RandomSettings copyWith({int? count, int? min, int? max}) {
    return RandomSettings(
      count: count ?? this.count,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}

class RandomState {
  final RandomSettings settings;
  final List<int> values;

  const RandomState({required this.settings, this.values = const []});
}

class RandomNotifier extends StateNotifier<RandomState> {
  RandomNotifier() : super(const RandomState(settings: RandomSettings()));

  void generate() {
    final generator = RandomNumberGenerator();
    final values = generator.generate(
      min: state.settings.min,
      max: state.settings.max,
      count: state.settings.count,
    );
    state = RandomState(settings: state.settings, values: values);
  }

  void updateSettings(RandomSettings settings) {
    state = RandomState(settings: settings, values: state.values);
  }
}

final randomProvider = StateNotifierProvider<RandomNotifier, RandomState>(
  (ref) => RandomNotifier(),
);
