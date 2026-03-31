import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/palette_generator.dart';

class PaletteGeneratorState {
  final String seed;
  final int count;
  final List<Color> colors;

  const PaletteGeneratorState({
    this.seed = 'toolbox',
    this.count = 6,
    this.colors = const [],
  });

  PaletteGeneratorState copyWith({String? seed, int? count, List<Color>? colors}) {
    return PaletteGeneratorState(
      seed: seed ?? this.seed,
      count: count ?? this.count,
      colors: colors ?? this.colors,
    );
  }
}

class PaletteGeneratorNotifier extends StateNotifier<PaletteGeneratorState> {
  PaletteGeneratorNotifier() : super(const PaletteGeneratorState()) {
    regenerate();
  }

  final _generator = const PaletteGenerator();

  void setSeed(String value) {
    state = state.copyWith(seed: value);
  }

  void setCount(int value) {
    state = state.copyWith(count: value.clamp(3, 10));
  }

  void regenerate() {
    final colors = _generator.generate(seed: state.seed, count: state.count);
    state = state.copyWith(colors: colors);
  }

  String toHex(Color color) => _generator.toHex(color);
}

final paletteGeneratorProvider = StateNotifierProvider<PaletteGeneratorNotifier, PaletteGeneratorState>(
  (ref) => PaletteGeneratorNotifier(),
);
