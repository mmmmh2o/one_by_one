// Web / desktop stub: no torch support
Future<bool> platformIsTorchAvailable() async => false;
Future<void> platformEnableTorch() async => throw UnsupportedError('Torch not supported on this platform');
Future<void> platformDisableTorch() async => throw UnsupportedError('Torch not supported on this platform');
