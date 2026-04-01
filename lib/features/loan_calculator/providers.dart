import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/loan_calculator_logic.dart';

/// 还款方式
enum LoanMethod { equalInstallment, equalPrincipal }

class LoanState {
  final double principal; // 贷款总额（万）
  final double annualRate; // 年利率 %
  final int years; // 贷款年限
  final LoanMethod method;
  final double? monthlyPayment;
  final double? totalInterest;
  final double? totalPayment;

  const LoanState({
    this.principal = 100,
    this.annualRate = 3.5,
    this.years = 30,
    this.method = LoanMethod.equalInstallment,
    this.monthlyPayment,
    this.totalInterest,
    this.totalPayment,
  });

  LoanState copyWith({
    double? principal,
    double? annualRate,
    int? years,
    LoanMethod? method,
    double? monthlyPayment,
    double? totalInterest,
    double? totalPayment,
  }) {
    return LoanState(
      principal: principal ?? this.principal,
      annualRate: annualRate ?? this.annualRate,
      years: years ?? this.years,
      method: method ?? this.method,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      totalInterest: totalInterest ?? this.totalInterest,
      totalPayment: totalPayment ?? this.totalPayment,
    );
  }
}

class LoanNotifier extends StateNotifier<LoanState> {
  LoanNotifier() : super(const LoanState());

  final _logic = const LoanCalculatorLogic();

  void setPrincipal(double v) => state = state.copyWith(principal: v);
  void setRate(double v) => state = state.copyWith(annualRate: v);
  void setYears(int v) => state = state.copyWith(years: v);
  void setMethod(LoanMethod m) {
    state = state.copyWith(method: m);
    calculate();
  }

  void calculate() {
    final principalWan = state.principal * 10000;
    final months = state.years * 12;

    if (state.method == LoanMethod.equalInstallment) {
      final monthly = _logic.equalInstallment(
        principal: principalWan,
        annualRate: state.annualRate,
        months: months,
      );
      final interest = _logic.totalInterestEqualInstallment(
        principal: principalWan,
        annualRate: state.annualRate,
        months: months,
      );
      state = state.copyWith(
        monthlyPayment: monthly,
        totalInterest: interest,
        totalPayment: principalWan + interest,
      );
    } else {
      final monthly = _logic.equalPrincipal(
        principal: principalWan,
        annualRate: state.annualRate,
        months: months,
      );
      final interest = _logic.totalInterestEqualPrincipal(
        principal: principalWan,
        annualRate: state.annualRate,
        months: months,
      );
      state = state.copyWith(
        monthlyPayment: monthly,
        totalInterest: interest,
        totalPayment: principalWan + interest,
      );
    }
  }
}

final loanProvider =
    StateNotifierProvider<LoanNotifier, LoanState>(
  (ref) => LoanNotifier(),
);
