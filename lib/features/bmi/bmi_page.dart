import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'logic/bmi_calculator.dart';
import 'providers.dart';

class BmiPage extends ConsumerStatefulWidget {
  const BmiPage({super.key});

  @override
  ConsumerState<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends ConsumerState<BmiPage> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: '170');
    _weightController = TextEditingController(text: '60');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bmiProvider);
    final notifier = ref.read(bmiProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'bmi',
      children: [
        AppCard(child: Column(children: [
          AppInput(label: '身高 (cm)', controller: _heightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (v) => notifier.setHeight(double.tryParse(v) ?? 0)),
          const SizedBox(height: AppSpacing.md),
          AppInput(label: '体重 (kg)', controller: _weightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (v) => notifier.setWeight(double.tryParse(v) ?? 0)),
        ])),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '计算 BMI', onPressed: notifier.calculate),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: state.result == null
            ? Text('输入参数后点击计算', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('BMI：${state.result!.value.toStringAsFixed(2)}', style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor)),
                const SizedBox(height: AppSpacing.sm),
                Text('分级：${_label(state.result!.category)}', style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor)),
              ])),
      ],
    );
  }

  String _label(BmiCategory c) => switch (c) { BmiCategory.underweight => '偏瘦', BmiCategory.normal => '正常', BmiCategory.overweight => '超重', BmiCategory.obese => '肥胖' };
}
