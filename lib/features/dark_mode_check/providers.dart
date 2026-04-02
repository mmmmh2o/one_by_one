import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/dark_mode_logic.dart';

class DarkModeState {
  final String bgColorHex;
  final String fgColorHex;
  final double contrastRatio;
  final String wcagLevel;
  final bool bgIsDark;
  final bool fgIsDark;
  final String colorTemp;
  final String recommendedFg;

  const DarkModeState({
    this.bgColorHex = '#1A1A2E',
    this.fgColorHex = '#FFFFFF',
    this.contrastRatio = 12.5,
    this.wcagLevel = 'AAA ✅',
    this.bgIsDark = true,
    this.fgIsDark = false,
    this.colorTemp = '冷色调 ❄️',
    this.recommendedFg = '#FFFFFF',
  });

  DarkModeState copyWith({
    String? bgColorHex,
    String? fgColorHex,
    double? contrastRatio,
    String? wcagLevel,
    bool? bgIsDark,
    bool? fgIsDark,
    String? colorTemp,
    String? recommendedFg,
  }) {
    return DarkModeState(
      bgColorHex: bgColorHex ?? this.bgColorHex,
      fgColorHex: fgColorHex ?? this.fgColorHex,
      contrastRatio: contrastRatio ?? this.contrastRatio,
      wcagLevel: wcagLevel ?? this.wcagLevel,
      bgIsDark: bgIsDark ?? this.bgIsDark,
      fgIsDark: fgIsDark ?? this.fgIsDark,
      colorTemp: colorTemp ?? this.colorTemp,
      recommendedFg: recommendedFg ?? this.recommendedFg,
    );
  }
}

class DarkModeNotifier extends StateNotifier<DarkModeState> {
  DarkModeNotifier() : super(const DarkModeState()) {
    _recalculate();
  }

  final _engine = const DarkModeEngine();

  void setBgColor(String hex) {
    state = state.copyWith(bgColorHex: hex);
    _recalculate();
  }

  void setFgColor(String hex) {
    state = state.copyWith(fgColorHex: hex);
    _recalculate();
  }

  void swapColors() {
    state = state.copyWith(
      bgColorHex: state.fgColorHex,
      fgColorHex: state.bgColorHex,
    );
    _recalculate();
  }

  void useRecommendedFg() {
    state = state.copyWith(fgColorHex: state.recommendedFg);
    _recalculate();
  }

  void _recalculate() {
    final bg = _engine.parseColor(state.bgColorHex);
    final fg = _engine.parseColor(state.fgColorHex);
    final bgLum = _engine.relativeLuminance(bg.r, bg.g, bg.b);
    final fgLum = _engine.relativeLuminance(fg.r, fg.g, fg.b);
    final ratio = _engine.contrastRatio(bgLum, fgLum);
    final rec = _engine.recommendedForeground(bg.r, bg.g, bg.b);

    state = state.copyWith(
      contrastRatio: ratio,
      wcagLevel: _engine.wcagLevel(ratio),
      bgIsDark: _engine.isDarkColor(bg.r, bg.g, bg.b),
      fgIsDark: _engine.isDarkColor(fg.r, fg.g, fg.b),
      colorTemp: _engine.colorTemperature(bg.r, bg.g, bg.b),
      recommendedFg: _engine.toHex(rec.r, rec.g, rec.b),
    );
  }
}

final darkModeProvider =
    StateNotifierProvider<DarkModeNotifier, DarkModeState>(
  (ref) => DarkModeNotifier(),
);
