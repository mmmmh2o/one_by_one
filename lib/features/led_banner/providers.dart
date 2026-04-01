import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/led_banner_logic.dart';

class LedBannerState {
  final String text;
  final LedSpeed speed;
  final LedFontSize fontSize;
  final bool scrolling;
  final double scrollOffset;

  const LedBannerState({
    this.text = '',
    this.speed = LedSpeed.medium,
    this.fontSize = LedFontSize.medium,
    this.scrolling = false,
    this.scrollOffset = 0,
  });

  LedBannerState copyWith({
    String? text,
    LedSpeed? speed,
    LedFontSize? fontSize,
    bool? scrolling,
    double? scrollOffset,
  }) {
    return LedBannerState(
      text: text ?? this.text,
      speed: speed ?? this.speed,
      fontSize: fontSize ?? this.fontSize,
      scrolling: scrolling ?? this.scrolling,
      scrollOffset: scrollOffset ?? this.scrollOffset,
    );
  }
}

class LedBannerNotifier extends StateNotifier<LedBannerState> {
  LedBannerNotifier() : super(const LedBannerState());

  final _logic = const LedBannerLogic();
  Timer? _timer;

  void setText(String text) {
    state = state.copyWith(text: _logic.normalize(text));
  }

  void setSpeed(LedSpeed speed) => state = state.copyWith(speed: speed);

  void setFontSize(LedFontSize size) =>
      state = state.copyWith(fontSize: size);

  double get fontSizePx =>
      LedBannerLogic.fontSizes[state.fontSize] ?? 48;

  void toggleScrolling() {
    if (state.scrolling) {
      _stop();
    } else {
      _start();
    }
  }

  void _start() {
    if (!_logic.canStart(state.text)) return;
    state = state.copyWith(scrolling: true, scrollOffset: 0);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final speed = LedBannerLogic.speeds[state.speed] ?? 1.5;
      state = state.copyWith(scrollOffset: state.scrollOffset + speed);
    });
  }

  void _stop() {
    _timer?.cancel();
    state = state.copyWith(scrolling: false, scrollOffset: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final ledBannerProvider =
    StateNotifierProvider<LedBannerNotifier, LedBannerState>(
  (ref) => LedBannerNotifier(),
);
