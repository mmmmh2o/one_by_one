import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/qrcode_logic.dart';

/// 二维码页面模式
enum QrMode { generate, scan }

class QrcodeState {
  final QrMode mode;
  final String inputText;
  final QrSize qrSize;
  final String? scannedResult;

  const QrcodeState({
    this.mode = QrMode.generate,
    this.inputText = '',
    this.qrSize = QrSize.medium,
    this.scannedResult,
  });

  QrcodeState copyWith({
    QrMode? mode,
    String? inputText,
    QrSize? qrSize,
    String? scannedResult,
  }) {
    return QrcodeState(
      mode: mode ?? this.mode,
      inputText: inputText ?? this.inputText,
      qrSize: qrSize ?? this.qrSize,
      scannedResult: scannedResult ?? this.scannedResult,
    );
  }
}

class QrcodeNotifier extends StateNotifier<QrcodeState> {
  QrcodeNotifier() : super(const QrcodeState());

  final _logic = const QrGenerator();

  void setMode(QrMode mode) => state = state.copyWith(mode: mode);

  void setInputText(String text) => state = state.copyWith(inputText: text);

  void setQrSize(QrSize size) => state = state.copyWith(qrSize: size);

  void setScannedResult(String result) =>
      state = state.copyWith(scannedResult: result);

  bool get canGenerate => _logic.canGenerate(state.inputText);

  double get qrPixelSize => _logic.sizeToPixels(state.qrSize);
}

final qrcodeProvider =
    StateNotifierProvider<QrcodeNotifier, QrcodeState>(
  (ref) => QrcodeNotifier(),
);
