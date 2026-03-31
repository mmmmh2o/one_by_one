import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import 'providers.dart';

class RandomStringPage extends ConsumerStatefulWidget {
  const RandomStringPage({super.key});

  @override
  ConsumerState<RandomStringPage> createState() => _RandomStringPageState();
}

class _RandomStringPageState extends ConsumerState<RandomStringPage> {
  late final TextEditingController _lengthController;

  @override
  void initState() {
    super.initState();
    _lengthController = TextEditingController(text: '16');
  }

  @override
  void dispose() {
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(randomStringProvider);
    final notifier = ref.read(randomStringProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('随机字符串')),
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
                    label: '长度 (1-256)',
                    controller: _lengthController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => notifier.setLength(int.tryParse(value) ?? 16),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      FilterChip(
                        label: const Text('小写'),
                        selected: state.useLower,
                        onSelected: notifier.setUseLower,
                      ),
                      FilterChip(
                        label: const Text('大写'),
                        selected: state.useUpper,
                        onSelected: notifier.setUseUpper,
                      ),
                      FilterChip(
                        label: const Text('数字'),
                        selected: state.useDigits,
                        onSelected: notifier.setUseDigits,
                      ),
                      FilterChip(
                        label: const Text('符号'),
                        selected: state.useSymbols,
                        onSelected: notifier.setUseSymbols,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '生成', onPressed: notifier.generate),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: state.error != null
                  ? Text(
                      state.error!,
                      style: scaledTextStyle(
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        ui.textScaleFactor,
                      ),
                    )
                  : SelectableText(
                      state.output.isEmpty ? '等待生成结果' : state.output,
                      style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
