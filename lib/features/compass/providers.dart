import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'logic/compass_logic.dart';

class CompassState {
  final double heading;
  final String direction;
  final bool needsCalibration;

  const CompassState({
    this.heading = 0,
    this.direction = '北',
    this.needsCalibration = false,
  });

  CompassState copyWith({
    double? heading,
    String? direction,
    bool? needsCalibration,
  }) {
    return CompassState(
      heading: heading ?? this.heading,
      direction: direction ?? this.direction,
      needsCalibration: needsCalibration ?? this.needsCalibration,
    );
  }
}

class CompassNotifier extends StateNotifier<CompassState> {
  CompassNotifier() : super(const CompassState()) {
    _listen();
  }

  final _logic = const CompassLogic();
  StreamSubscription? _subscription;

  void _listen() {
    _subscription = magnetometerEventStream().listen((event) {
      final heading = _logic.headingFromXY(event.x, event.y);
      final direction = _logic.directionLabel(heading);
      final calibration = _logic.needsCalibration(event.x, event.y);
      state = state.copyWith(
        heading: heading,
        direction: direction,
        needsCalibration: calibration,
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final compassProvider =
    StateNotifierProvider<CompassNotifier, CompassState>(
  (ref) => CompassNotifier(),
);
