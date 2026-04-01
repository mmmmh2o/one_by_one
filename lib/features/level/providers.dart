import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'logic/level_logic.dart';

class LevelState {
  final double tiltAngle;
  final double offsetX;
  final bool isLevel;

  const LevelState({
    this.tiltAngle = 0,
    this.offsetX = 0,
    this.isLevel = true,
  });

  LevelState copyWith({
    double? tiltAngle,
    double? offsetX,
    bool? isLevel,
  }) {
    return LevelState(
      tiltAngle: tiltAngle ?? this.tiltAngle,
      offsetX: offsetX ?? this.offsetX,
      isLevel: isLevel ?? this.isLevel,
    );
  }
}

class LevelNotifier extends StateNotifier<LevelState> {
  LevelNotifier() : super(const LevelState()) {
    _listen();
  }

  final _logic = const LevelLogic();
  StreamSubscription? _subscription;

  void _listen() {
    _subscription = accelerometerEventStream().listen((event) {
      state = state.copyWith(
        tiltAngle: _logic.tiltAngle(event.x, event.y),
        offsetX: _logic.offsetX(event.x, event.y),
        isLevel: _logic.isLevel(event.x, event.y),
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final levelProvider =
    StateNotifierProvider<LevelNotifier, LevelState>(
  (ref) => LevelNotifier(),
);
