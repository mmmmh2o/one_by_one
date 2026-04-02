import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/text_encrypt.dart';

class TextEncryptState {
  final String input;
  final String output;
  final CipherType cipherType;
  final int caesarShift;

  const TextEncryptState({
    this.input = '',
    this.output = '',
    this.cipherType = CipherType.base64,
    this.caesarShift = 3,
  });

  TextEncryptState copyWith({
    String? input,
    String? output,
    CipherType? cipherType,
    int? caesarShift,
  }) {
    return TextEncryptState(
      input: input ?? this.input,
      output: output ?? this.output,
      cipherType: cipherType ?? this.cipherType,
      caesarShift: caesarShift ?? this.caesarShift,
    );
  }
}

class TextEncryptNotifier extends StateNotifier<TextEncryptState> {
  TextEncryptNotifier() : super(const TextEncryptState());

  final _engine = const TextEncryptEngine();

  void setInput(String value) => state = state.copyWith(input: value);

  void setCipherType(CipherType type) => state = state.copyWith(cipherType: type);

  void setCaesarShift(int shift) => state = state.copyWith(caesarShift: shift);

  void encrypt() {
    final result = _engine.encrypt(
      state.input,
      state.cipherType,
      caesarShift: state.caesarShift,
    );
    state = state.copyWith(output: result);
  }

  void decrypt() {
    final result = _engine.decrypt(
      state.input,
      state.cipherType,
      caesarShift: state.caesarShift,
    );
    state = state.copyWith(output: result);
  }

  void swap() {
    state = state.copyWith(input: state.output, output: state.input);
  }
}

final textEncryptProvider =
    StateNotifierProvider<TextEncryptNotifier, TextEncryptState>(
  (ref) => TextEncryptNotifier(),
);
