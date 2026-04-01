import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/flashlight_logic.dart';

// 条件导入：Web 端用 stub，移动端用 torch_light
import 'providers_stub.dart'
    if (dart.library.io) 'providers_mobile.dart'
    if (dart.library.html) 'providers_stub.dart';

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

  Future<void> _checkSupport() async {
    final supported = await platformIsTorchAvailable();
    if (!supported) {
      state = state.copyWith(status: FlashlightStatus.unsupported);
    }
  }

  Future<void> toggle() async {
    if (state.status == FlashlightStatus.unsupported) return;

    try {
      if (state.status == FlashlightStatus.off) {
        await platformEnableTorch();
        state = state.copyWith(status: FlashlightStatus.on);
      } else {
        await platformDisableTorch();
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
