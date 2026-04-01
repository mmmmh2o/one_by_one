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

class TaxCalculatorPage extends ConsumerStatefulWidget {
  const TaxCalculatorPage({super.key});

  @override
  ConsumerState<TaxCalculatorPage> createState() => _TaxCalculatorPageState();
}

class _TaxCalculatorPageState extends ConsumerState<TaxCalculatorPage> {
  late final TextEditingController _salaryController;
  late final TextEditingController _specialController;
  late final TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController(text: '10000');
    _specialController = TextEditingController(text: '0');
    _otherController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _specialController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taxProvider);
    final notifier = ref.read(taxProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'tax_calculator',
      scrollable: true,
      children: [
        // 输入区
        AppCard(
          child: Column(
            children: [
              AppInput(
                label: '月工资收入（元）',
                controller: _salaryController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    notifier.setSalary(double.tryParse(v) ?? 10000),
              ),
              const SizedBox(height: AppSpacing.md),
              AppInput(
                label: '专项附加扣除（元/年）',
                controller: _specialController,
                hint: '子女教育、房贷利息、房租等',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    notifier.setSpecialDeduction(double.tryParse(v) ?? 0),
              ),
              const SizedBox(height: AppSpacing.md),
              AppInput(
                label: '其他扣除（元/年）',
                controller: _otherController,
                hint: '五险一金个人部分等',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) =>
                    notifier.setOtherDeduction(double.tryParse(v) ?? 0),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(label: '计算', onPressed: notifier.calculate),
        const SizedBox(height: AppSpacing.lg),

        // 结果区
        if (state.annualTax != null)
          AppCard(
            child: Column(
              children: [
                _ResultRow(
                  label: '每月税后收入',
                  value: '¥ ${state.monthlyAfterTax!.toStringAsFixed(2)}',
                  highlight: true,
                ),
                Divider(color: scheme.outlineVariant),
                _ResultRow(
                  label: '年应纳税额',
                  value: '¥ ${state.annualTax!.toStringAsFixed(2)}',
                ),
                Divider(color: scheme.outlineVariant),
                _ResultRow(
                  label: '每月个税',
                  value:
                      '¥ ${(state.annualTax! / 12).toStringAsFixed(2)}',
                ),
                Divider(color: scheme.outlineVariant),
                _ResultRow(
                  label: '适用税率',
                  value: '${state.effectiveRate!.toStringAsFixed(0)}%',
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
