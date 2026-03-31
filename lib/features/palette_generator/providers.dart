import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/palette_generator.dart';

/// 将纯 Dart RgbColor 转为 Flutter Color（转换只在 Provider 层发生）
Color _toColor(RgbColor c) => Color.fromARGB(255, c.r, c.g, c.b);

class PaletteGeneratorState {
  final String seed;
  final int count;
  final List<RgbColor> rawColors;

  const PaletteGeneratorState({
    this.seed = 'toolbox',
    this.count = 6,
    this.rawColors = const [],
  });

  /// UI 直接用的 Flutter Color 列表
  List<Color> get colors => rawColors.map(_toColor).toList();

  /// hex 字符串列表
  List<String> get hexValues => rawColors.map((c) => c.toHex()).toList();

  PaletteGeneratorState copyWith({
    String? seed,
    int? count,
    List<RgbColor>? rawColors,
  }) {
    return PaletteGeneratorState(
      seed: seed ?? this.seed,
      count: count ?? this.count,
      rawColors: rawColors ?? this.rawColors,
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
    final rawColors = _generator.generate(seed: state.seed, count: state.count);
    state = state.copyWith(rawColors: rawColors);
  }
}

final paletteGeneratorProvider =
    StateNotifierProvider<PaletteGeneratorNotifier, PaletteGeneratorState>(
  (ref) => PaletteGeneratorNotifier(),
);
