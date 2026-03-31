import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class DicePage extends ConsumerWidget {
  const DicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diceProvider);
    final notifier = ref.read(diceProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('掷骰子')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '骰子数量：${state.count}',
                    style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                  ),
                  Slider(
                    min: 1,
                    max: 6,
                    divisions: 5,
                    value: state.count.toDouble(),
                    onChanged: (value) => notifier.setCount(value.round()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '面数：${state.sides}',
                    style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                  ),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [4, 6, 8, 12, 20]
                        .map(
                          (sides) => ChoiceChip(
                            label: Text('d$sides'),
                            selected: state.sides == sides,
                            onSelected: (_) => notifier.setSides(sides),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '掷一次', onPressed: notifier.roll),
            const SizedBox(height: AppSpacing.lg),
            if (state.result == null)
              Text(
                '点击按钮开始掷骰子',
                textAlign: TextAlign.center,
                style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor),
              )
            else
              AppCard(
                child: Column(
                  children: [
                    Text(
                      '结果：${state.result!.values.join(', ')}',
                      style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '总和：${state.result!.total}',
                      style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
