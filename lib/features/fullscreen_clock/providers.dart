import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullscreenClockState {
  final DateTime now;
  final bool is24Hour;
  final bool showSeconds;

  const FullscreenClockState({
    required this.now,
    this.is24Hour = true,
    this.showSeconds = true,
  });

  FullscreenClockState copyWith({DateTime? now, bool? is24Hour, bool? showSeconds}) {
    return FullscreenClockState(
      now: now ?? this.now,
      is24Hour: is24Hour ?? this.is24Hour,
      showSeconds: showSeconds ?? this.showSeconds,
    );
  }
}

class FullscreenClockNotifier extends StateNotifier<FullscreenClockState> {
  FullscreenClockNotifier()
    : super(FullscreenClockState(now: DateTime.now())) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(now: DateTime.now());
    });
  }

  late final Timer _timer;

  void set24Hour(bool value) {
    state = state.copyWith(is24Hour: value);
  }

  void setShowSeconds(bool value) {
    state = state.copyWith(showSeconds: value);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final fullscreenClockProvider = StateNotifierProvider<FullscreenClockNotifier, FullscreenClockState>(
  (ref) => FullscreenClockNotifier(),
);
