import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'logic/calculator_engine.dart';
import 'providers.dart';

class CalculatorPage extends ConsumerStatefulWidget {
  const CalculatorPage({super.key});

  @override
  ConsumerState<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {
  late final TextEditingController _leftController;
  late final TextEditingController _rightController;

  @override
  void initState() {
    super.initState();
    _leftController = TextEditingController(text: '0');
    _rightController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'calculator',
      children: [
        AppCard(
          child: Column(
            children: [
              AppInput(label: '数值 A', controller: _leftController, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (v) => notifier.setLeft(double.tryParse(v) ?? 0)),
              const SizedBox(height: AppSpacing.md),
              AppInput(label: '数值 B', controller: _rightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (v) => notifier.setRight(double.tryParse(v) ?? 0)),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<CalcOperator>(value: state.operator, decoration: const InputDecoration(labelText: '运算符'), items: const [DropdownMenuItem(value: CalcOperator.add, child: Text('加法 (+)')), DropdownMenuItem(value: CalcOperator.subtract, child: Text('减法 (-)')), DropdownMenuItem(value: CalcOperator.multiply, child: Text('乘法 (*)')), DropdownMenuItem(value: CalcOperator.divide, child: Text('除法 (/)'))], onChanged: (v) { if (v != null) notifier.setOperator(v); }),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '计算', onPressed: notifier.compute),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: state.error != null
              ? Text(state.error!, style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error), ui.textScaleFactor))
              : Text('结果：${state.output}', style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor)),
        ),
      ],
    );
  }
}
