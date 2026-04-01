/// 个税计算逻辑层（纯 Dart）
///
/// 基于中国个人所得税（综合所得）七级超额累进税率
class TaxCalculatorLogic {
  const TaxCalculatorLogic();

  /// 税率级距
  static const _brackets = <_TaxBracket>[
    _TaxBracket(0, 36000, 0.03, 0),
    _TaxBracket(36000, 144000, 0.10, 2520),
    _TaxBracket(144000, 300000, 0.20, 16920),
    _TaxBracket(300000, 420000, 0.25, 31920),
    _TaxBracket(420000, 660000, 0.30, 52920),
    _TaxBracket(660000, 960000, 0.35, 85920),
    _TaxBracket(960000, double.infinity, 0.45, 181920),
  ];

  /// 专项附加扣除项
  static const defaultDeduction = 5000.0; // 基础减除费用（每月）

  /// 计算年度应纳税所得额
  double taxableIncome({
    required double annualSalary,
    double specialDeduction = 0,
    double otherDeduction = 0,
  }) {
    final totalDeduction = defaultDeduction * 12 + specialDeduction + otherDeduction;
    return (annualSalary - totalDeduction).clamp(0, double.infinity);
  }

  /// 计算年度应纳税额
  double annualTax({
    required double annualSalary,
    double specialDeduction = 0,
    double otherDeduction = 0,
  }) {
    final taxable = taxableIncome(
      annualSalary: annualSalary,
      specialDeduction: specialDeduction,
      otherDeduction: otherDeduction,
    );

    for (final bracket in _brackets) {
      if (taxable <= bracket.upper) {
        return taxable * bracket.rate - bracket.quickDeduction;
      }
    }
    return 0;
  }

  /// 计算税后月收入
  double monthlyAfterTax({
    required double monthlySalary,
    double specialDeduction = 0,
    double otherDeduction = 0,
  }) {
    final annualTax = this.annualTax(
      annualSalary: monthlySalary * 12,
      specialDeduction: specialDeduction,
      otherDeduction: otherDeduction,
    );
    return monthlySalary - annualTax / 12;
  }

  /// 适用税率
  double effectiveRate({
    required double annualSalary,
    double specialDeduction = 0,
    double otherDeduction = 0,
  }) {
    final taxable = taxableIncome(
      annualSalary: annualSalary,
      specialDeduction: specialDeduction,
      otherDeduction: otherDeduction,
    );
    for (final bracket in _brackets) {
      if (taxable <= bracket.upper) return bracket.rate * 100;
    }
    return 45;
  }
}

class _TaxBracket {
  final double lower;
  final double upper;
  final double rate;
  final double quickDeduction;

  const _TaxBracket(this.lower, this.upper, this.rate, this.quickDeduction);
}
