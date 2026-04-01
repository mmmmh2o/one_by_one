import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class LoanCalculatorPage extends ConsumerStatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  ConsumerState<LoanCalculatorPage> createState() =>
      _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends ConsumerState<LoanCalculatorPage> {
  late final TextEditingController _principalController;
  late final TextEditingController _rateController;
  late final TextEditingController _yearsController;

  @override
  void initState() {
    super.initState();
    _principalController = TextEditingController(text: '100');
    _rateController = TextEditingController(text: '3.5');
    _yearsController = TextEditingController(text: '30');
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loanProvider);
    final notifier = ref.read(loanProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'loan_calculator',
      scrollable: true,
      children: [
        // 输入区
        AppCard(
          child: Column(
            children: [
              AppInput(
                label: '贷款总额（万元）',
                controller: _principalController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    notifier.setPrincipal(double.tryParse(v) ?? 100),
              ),
              const SizedBox(height: AppSpacing.md),
              AppInput(
                label: '年利率（%）',
                controller: _rateController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    notifier.setRate(double.tryParse(v) ?? 3.5),
              ),
              const SizedBox(height: AppSpacing.md),
              AppInput(
                label: '贷款年限',
                controller: _yearsController,
                keyboardType: TextInputType.number,
                onChanged: (v) => notifier.setYears(int.tryParse(v) ?? 30),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 还款方式
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('还款方式', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('等额本息'),
                      selected:
                          state.method == LoanMethod.equalInstallment,
                      onSelected: (_) =>
                          notifier.setMethod(LoanMethod.equalInstallment),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('等额本金'),
                      selected:
                          state.method == LoanMethod.equalPrincipal,
                      onSelected: (_) =>
                          notifier.setMethod(LoanMethod.equalPrincipal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(label: '计算', onPressed: notifier.calculate),
        const SizedBox(height: AppSpacing.lg),

        // 结果区
        if (state.monthlyPayment != null)
          AppCard(
            child: Column(
              children: [
                _ResultRow(
                  label: '首月月供',
                  value: '¥ ${state.monthlyPayment!.toStringAsFixed(2)}',
                  highlight: true,
                ),
                Divider(color: scheme.outlineVariant),
                _ResultRow(
                  label: '总利息',
                  value: '¥ ${state.totalInterest!.toStringAsFixed(2)}',
                ),
                Divider(color: scheme.outlineVariant),
                _ResultRow(
                  label: '还款总额',
                  value: '¥ ${state.totalPayment!.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: highlight ? scheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
