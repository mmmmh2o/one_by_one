import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
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
  void dispose() { _countController.dispose(); _minController.dispose(); _maxController.dispose(); super.dispose(); }

  void _updateCount(String v) { final s = ref.read(randomProvider); ref.read(randomProvider.notifier).updateSettings(s.settings.copyWith(count: int.tryParse(v) ?? s.settings.count)); }
  void _updateMin(String v) { final s = ref.read(randomProvider); ref.read(randomProvider.notifier).updateSettings(s.settings.copyWith(min: int.tryParse(v) ?? s.settings.min)); }
  void _updateMax(String v) { final s = ref.read(randomProvider); ref.read(randomProvider.notifier).updateSettings(s.settings.copyWith(max: int.tryParse(v) ?? s.settings.max)); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(randomProvider);
    final notifier = ref.read(randomProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'random_number',
      children: [
        AppCard(child: Column(children: [
          AppInput(label: '数量', controller: _countController, keyboardType: TextInputType.number, onChanged: _updateCount),
          const SizedBox(height: AppSpacing.md),
          AppInput(label: '最小值', controller: _minController, keyboardType: TextInputType.number, onChanged: _updateMin),
          const SizedBox(height: AppSpacing.md),
          AppInput(label: '最大值', controller: _maxController, keyboardType: TextInputType.number, onChanged: _updateMax),
        ])),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '生成', onPressed: notifier.generate),
        const SizedBox(height: AppSpacing.lg),
        if (state.values.isEmpty) Text('点击生成以查看结果', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor))
        else Text(state.values.join(', '), style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor), textAlign: TextAlign.center),
      ],
    );
  }
}
