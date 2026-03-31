import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class RandomPage extends ConsumerStatefulWidget {
  const RandomPage({super.key});

  @override
  ConsumerState<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends ConsumerState<RandomPage> {
  late final TextEditingController _countController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(randomProvider).settings;
    _countController = TextEditingController(text: settings.count.toString());
    _minController = TextEditingController(text: settings.min.toString());
    _maxController = TextEditingController(text: settings.max.toString());
  }

  @override
  void dispose() {
    _countController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _updateCount(String value) {
    final state = ref.read(randomProvider);
    final parsed = int.tryParse(value) ?? state.settings.count;
    ref.read(randomProvider.notifier).updateSettings(state.settings.copyWith(count: parsed));
  }

  void _updateMin(String value) {
    final state = ref.read(randomProvider);
    final parsed = int.tryParse(value) ?? state.settings.min;
    ref.read(randomProvider.notifier).updateSettings(state.settings.copyWith(min: parsed));
  }

  void _updateMax(String value) {
    final state = ref.read(randomProvider);
    final parsed = int.tryParse(value) ?? state.settings.max;
    ref.read(randomProvider.notifier).updateSettings(state.settings.copyWith(max: parsed));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(randomProvider);
    final notifier = ref.read(randomProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('随机数')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                children: [
                  AppInput(
                    label: '数量',
                    controller: _countController,
                    keyboardType: TextInputType.number,
                    onChanged: _updateCount,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    label: '最小值',
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    onChanged: _updateMin,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    label: '最大值',
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    onChanged: _updateMax,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '生成', onPressed: notifier.generate),
            const SizedBox(height: AppSpacing.lg),
            if (state.values.isEmpty)
              Text(
                '点击生成以查看结果',
                style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor),
              )
            else
              Text(
                state.values.join(', '),
                style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
