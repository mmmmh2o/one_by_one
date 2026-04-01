import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/tax_calculator_logic.dart';

class TaxState {
  final double monthlySalary; // 月薪（元）
  final double specialDeduction; // 专项附加扣除（元/年）
  final double otherDeduction; // 其他扣除（元/年）
  final double? annualTax;
  final double? monthlyAfterTax;
  final double? effectiveRate;

  const TaxState({
    this.monthlySalary = 10000,
    this.specialDeduction = 0,
    this.otherDeduction = 0,
    this.annualTax,
    this.monthlyAfterTax,
    this.effectiveRate,
  });

  TaxState copyWith({
    double? monthlySalary,
    double? specialDeduction,
    double? otherDeduction,
    double? annualTax,
    double? monthlyAfterTax,
    double? effectiveRate,
  }) {
    return TaxState(
      monthlySalary: monthlySalary ?? this.monthlySalary,
      specialDeduction: specialDeduction ?? this.specialDeduction,
      otherDeduction: otherDeduction ?? this.otherDeduction,
      annualTax: annualTax ?? this.annualTax,
      monthlyAfterTax: monthlyAfterTax ?? this.monthlyAfterTax,
      effectiveRate: effectiveRate ?? this.effectiveRate,
    );
  }
}

class TaxNotifier extends StateNotifier<TaxState> {
  TaxNotifier() : super(const TaxState());

  final _logic = const TaxCalculatorLogic();

  void setSalary(double v) => state = state.copyWith(monthlySalary: v);
  void setSpecialDeduction(double v) =>
      state = state.copyWith(specialDeduction: v);
  void setOtherDeduction(double v) =>
      state = state.copyWith(otherDeduction: v);

  void calculate() {
    final annualSalary = state.monthlySalary * 12;
    final tax = _logic.annualTax(
      annualSalary: annualSalary,
      specialDeduction: state.specialDeduction,
      otherDeduction: state.otherDeduction,
    );
    final afterTax = state.monthlySalary - tax / 12;
    final rate = _logic.effectiveRate(
      annualSalary: annualSalary,
      specialDeduction: state.specialDeduction,
      otherDeduction: state.otherDeduction,
    );

    state = state.copyWith(
      annualTax: tax,
      monthlyAfterTax: afterTax,
      effectiveRate: rate,
    );
  }
}

final taxProvider =
    StateNotifierProvider<TaxNotifier, TaxState>(
  (ref) => TaxNotifier(),
);
