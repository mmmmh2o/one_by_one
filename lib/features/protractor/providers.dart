import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'logic/protractor_logic.dart';

class ProtractorState {
  final double angle;
  final double rawX;
  final double rawY;
  final String? specialName;

  const ProtractorState({
    this.angle = 0,
    this.rawX = 0,
    this.rawY = 0,
    this.specialName,
  });

  ProtractorState copyWith({
    double? angle,
    double? rawX,
    double? rawY,
    String? specialName,
  }) {
    return ProtractorState(
      angle: angle ?? this.angle,
      rawX: rawX ?? this.rawX,
      rawY: rawY ?? this.rawY,
      specialName: specialName,
    );
  }
}

class ProtractorNotifier extends StateNotifier<ProtractorState> {
  ProtractorNotifier() : super(const ProtractorState()) {
    _listen();
  }

  final _engine = const ProtractorEngine();
  StreamSubscription? _subscription;

  void _listen() {
    _subscription = accelerometerEventStream().listen((event) {
      final angle = _engine.tiltFromAccelerometer(event.x, event.y);
      final normalized = angle < 0 ? angle + 360 : angle;
      state = state.copyWith(
        angle: normalized,
        rawX: event.x,
        rawY: event.y,
        specialName: _engine.specialAngleName(normalized),
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final protractorProvider =
    StateNotifierProvider<ProtractorNotifier, ProtractorState>(
  (ref) => ProtractorNotifier(),
);
