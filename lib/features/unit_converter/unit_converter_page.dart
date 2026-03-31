import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'logic/length_converter.dart';
import 'providers.dart';

class UnitConverterPage extends ConsumerStatefulWidget {
  const UnitConverterPage({super.key});
  @override
  ConsumerState<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends ConsumerState<UnitConverterPage> {
  late final TextEditingController _inputController;
  @override
  void initState() { super.initState(); _inputController = TextEditingController(text: ref.read(unitConverterProvider).input.toString()); }
  @override
  void dispose() { _inputController.dispose(); super.dispose(); }

  String _label(LengthUnit u) => switch (u) { LengthUnit.meter => '米', LengthUnit.kilometer => '千米', LengthUnit.centimeter => '厘米', LengthUnit.inch => '英寸', LengthUnit.foot => '英尺' };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unitConverterProvider);
    final notifier = ref.read(unitConverterProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'unit_converter',
      children: [
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppInput(label: '输入值', controller: _inputController, keyboardType: TextInputType.number, onChanged: (v) { final p = double.tryParse(v); if (p != null) notifier.setInput(p); }),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<LengthUnit>(value: state.from, decoration: const InputDecoration(labelText: '从'), items: LengthUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(_label(u)))).toList(), onChanged: (u) { if (u != null) notifier.setFrom(u); }),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<LengthUnit>(value: state.to, decoration: const InputDecoration(labelText: '到'), items: LengthUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(_label(u)))).toList(), onChanged: (u) { if (u != null) notifier.setTo(u); }),
        ])),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '交换单位', onPressed: notifier.swapUnits, isPrimary: false),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: Text('结果：${state.output.toStringAsFixed(4)} ${_label(state.to)}', style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor), textAlign: TextAlign.center)),
      ],
    );
  }
}
