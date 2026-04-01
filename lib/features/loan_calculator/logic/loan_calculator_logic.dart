import 'dart:math';

/// 房贷计算器逻辑层（纯 Dart）
class LoanCalculatorLogic {
  const LoanCalculatorLogic();

  /// 等额本息月供
  ///
  /// [principal] 贷款总额
  /// [annualRate] 年利率（如 3.5 表示 3.5%）
  /// [months] 还款月数
  double equalInstallment({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return 0;
    final monthlyRate = annualRate / 100 / 12;
    if (monthlyRate == 0) return principal / months;
    final factor = pow(1 + monthlyRate, months);
    return principal * monthlyRate * factor / (factor - 1);
  }

  /// 等额本金首月月供
  double equalPrincipal({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return 0;
    final monthlyPrincipal = principal / months;
    final monthlyRate = annualRate / 100 / 12;
    return monthlyPrincipal + principal * monthlyRate;
  }

  /// 等额本金末月月供
  double equalPrincipalLastMonth({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return 0;
    final monthlyPrincipal = principal / months;
    final monthlyRate = annualRate / 100 / 12;
    return monthlyPrincipal + monthlyPrincipal * monthlyRate;
  }

  /// 总利息（等额本息）
  double totalInterestEqualInstallment({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    final monthly = equalInstallment(
        principal: principal, annualRate: annualRate, months: months);
    return monthly * months - principal;
  }

  /// 总利息（等额本金）
  double totalInterestEqualPrincipal({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (months <= 0) return 0;
    final monthlyRate = annualRate / 100 / 12;
    var totalInterest = 0.0;
    for (var i = 0; i < months; i++) {
      totalInterest += (principal - (principal / months) * i) * monthlyRate;
    }
    return totalInterest;
  }

  /// 格式化金额
  String formatMoney(double amount) {
    return amount.toStringAsFixed(2);
  }
}
