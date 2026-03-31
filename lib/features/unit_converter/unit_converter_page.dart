import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
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
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: ref.read(unitConverterProvider).input.toString());
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unitConverterProvider);
    final notifier = ref.read(unitConverterProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('单位换算')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInput(
                    label: '输入值',
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        notifier.setInput(parsed);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<LengthUnit>(
                    value: state.from,
                    decoration: const InputDecoration(labelText: '从'),
                    items: LengthUnit.values
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(_label(unit))))
                        .toList(),
                    onChanged: (unit) {
                      if (unit != null) notifier.setFrom(unit);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<LengthUnit>(
                    value: state.to,
                    decoration: const InputDecoration(labelText: '到'),
                    items: LengthUnit.values
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(_label(unit))))
                        .toList(),
                    onChanged: (unit) {
                      if (unit != null) notifier.setTo(unit);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '交换单位', onPressed: notifier.swapUnits, isPrimary: false),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Text(
                '结果：${state.output.toStringAsFixed(4)} ${_label(state.to)}',
                style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(LengthUnit unit) {
    switch (unit) {
      case LengthUnit.meter:
        return '米';
      case LengthUnit.kilometer:
        return '千米';
      case LengthUnit.centimeter:
        return '厘米';
      case LengthUnit.inch:
        return '英寸';
      case LengthUnit.foot:
        return '英尺';
    }
  }
}
