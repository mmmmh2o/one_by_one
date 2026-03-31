import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/coin_flipper.dart';
import 'providers.dart';

class CoinPage extends ConsumerWidget {
  const CoinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coinProvider);
    final notifier = ref.read(coinProvider.notifier);
    final ui = ref.watch(settingsProvider);

    final sideText = switch (state.lastResult?.side) {
      CoinSide.heads => '正面',
      CoinSide.tails => '反面',
      null => '点击下方按钮开始抛硬币',
    };

    final icon = switch (state.lastResult?.side) {
      CoinSide.heads => Icons.face,
      CoinSide.tails => Icons.change_history,
      null => Icons.casino,
    };

    return ToolScaffold(
      toolId: 'coin',
      children: [
        AppCard(
          child: Column(
            children: [
              Icon(
                icon,
                size: 52 * ui.iconScaleFactor,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                sideText,
                textAlign: TextAlign.center,
                style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('统计', style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor)),
              const SizedBox(height: AppSpacing.sm),
              Text('正面：${state.headsCount} 次', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
              Text('反面：${state.tailsCount} 次', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '抛一次', onPressed: notifier.flip),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(onPressed: notifier.resetStats, child: const Text('重置统计')),
      ],
    );
  }
}
