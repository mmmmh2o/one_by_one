import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class RmbUppercasePage extends ConsumerStatefulWidget {
  const RmbUppercasePage({super.key});

  @override
  ConsumerState<RmbUppercasePage> createState() => _RmbUppercasePageState();
}

class _RmbUppercasePageState extends ConsumerState<RmbUppercasePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rmbUppercaseProvider);
    final notifier = ref.read(rmbUppercaseProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'rmb_uppercase',
      children: [
        AppCard(
          child: AppInput(
            label: '金额',
            hint: '例如 1234.56',
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => notifier.setAmount(double.tryParse(value) ?? 0),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '转换为大写金额', onPressed: notifier.convert),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: SelectableText(
            state.output.isEmpty ? '等待转换结果' : state.output,
            style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
          ),
        ),
      ],
    );
  }
}
