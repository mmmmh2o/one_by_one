enum CalcOperator { add, subtract, multiply, divide }

class CalcResult {
  final double? value;
  final String? error;

  const CalcResult({this.value, this.error});

  bool get isValid => error == null;
}

class CalculatorEngine {
  const CalculatorEngine();

  CalcResult calculate({
    required double left,
    required double right,
    required CalcOperator operator,
  }) {
    switch (operator) {
      case CalcOperator.add:
        return CalcResult(value: left + right);
      case CalcOperator.subtract:
        return CalcResult(value: left - right);
      case CalcOperator.multiply:
        return CalcResult(value: left * right);
      case CalcOperator.divide:
        if (right == 0) {
          return const CalcResult(error: '除数不能为 0');
        }
        return CalcResult(value: left / right);
    }
  }
}
