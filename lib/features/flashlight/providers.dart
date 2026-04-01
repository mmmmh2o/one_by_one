import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torch_light/torch_light.dart';

import 'logic/flashlight_logic.dart';

class FlashlightState {
  final FlashlightStatus status;

  const FlashlightState({this.status = FlashlightStatus.off});

  FlashlightState copyWith({FlashlightStatus? status}) {
    return FlashlightState(status: status ?? this.status);
  }
}

class FlashlightNotifier extends StateNotifier<FlashlightState> {
  FlashlightNotifier() : super(const FlashlightState()) {
    _checkSupport();
  }

  final _logic = const FlashlightLogic();

  Future<void> _checkSupport() async {
    try {
      await TorchLight.isTorchAvailable();
    } catch (_) {
      state = state.copyWith(status: FlashlightStatus.unsupported);
    }
  }

  Future<void> toggle() async {
    if (state.status == FlashlightStatus.unsupported) return;

    try {
      if (state.status == FlashlightStatus.off) {
        await TorchLight.enableTorch();
        state = state.copyWith(status: FlashlightStatus.on);
      } else {
        await TorchLight.disableTorch();
        state = state.copyWith(status: FlashlightStatus.off);
      }
    } catch (_) {
      state = state.copyWith(status: FlashlightStatus.unsupported);
    }
  }
}

final flashlightProvider =
    StateNotifierProvider<FlashlightNotifier, FlashlightState>(
  (ref) => FlashlightNotifier(),
);
