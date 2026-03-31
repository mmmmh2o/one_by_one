class BaseConvertResult {
  final String? output;
  final String? error;

  const BaseConvertResult({this.output, this.error});

  bool get isValid => error == null;
}

class BaseConverter {
  const BaseConverter();

  BaseConvertResult convert({
    required String input,
    required int fromBase,
    required int toBase,
  }) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const BaseConvertResult(error: '请输入要转换的值');
    }

    if (fromBase < 2 || fromBase > 36 || toBase < 2 || toBase > 36) {
      return const BaseConvertResult(error: '进制范围仅支持 2-36');
    }

    try {
      final value = BigInt.parse(trimmed, radix: fromBase);
      final output = value.toRadixString(toBase).toUpperCase();
      return BaseConvertResult(output: output);
    } on FormatException {
      return BaseConvertResult(
        error: '输入值不符合 $fromBase 进制格式',
      );
    }
  }
}
