// Mobile platform: uses torch_light
import 'package:torch_light/torch_light.dart';

Future<bool> platformIsTorchAvailable() async {
  try {
    return await TorchLight.isTorchAvailable();
  } catch (_) {
    return false;
  }
}

Future<void> platformEnableTorch() => TorchLight.enableTorch();

Future<void> platformDisableTorch() => TorchLight.disableTorch();
