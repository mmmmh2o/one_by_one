import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/ruler_measurement.dart';

class RulerState {
  final double lengthCm;
  final RulerMeasurement measurement;

  RulerState({required this.lengthCm}) : measurement = RulerMeasurement(lengthCm);

  RulerState copyWith({double? lengthCm}) => RulerState(lengthCm: lengthCm ?? this.lengthCm);
}

class RulerNotifier extends StateNotifier<RulerState> {
  RulerNotifier() : super(RulerState(lengthCm: 10.0));

  void updateLength(double cm) {
    state = state.copyWith(lengthCm: cm);
  }
}

final rulerProvider = StateNotifierProvider<RulerNotifier, RulerState>((ref) => RulerNotifier());
