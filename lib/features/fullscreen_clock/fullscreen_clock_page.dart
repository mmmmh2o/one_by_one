import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/clock_formatter.dart';
import 'providers.dart';

class FullscreenClockPage extends ConsumerWidget {
  const FullscreenClockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fullscreenClockProvider);
    final notifier = ref.read(fullscreenClockProvider.notifier);
    final ui = ref.watch(settingsProvider);
    const formatter = ClockFormatter();

    final hour = state.now.hour;
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final mm = state.now.minute.toString().padLeft(2, '0');
    final ss = state.now.second.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    final timeText = state.is24Hour
        ? (state.showSeconds ? formatter.format(state.now) : '${hour.toString().padLeft(2, '0')}:$mm')
        : (state.showSeconds ? '${h12.toString().padLeft(2, '0')}:$mm:$ss $period' : '${h12.toString().padLeft(2, '0')}:$mm $period');

    return ToolScaffold(
      toolId: 'fullscreen_clock',
      expandBody: true,
      children: [
        Expanded(child: AppCard(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(timeText, style: scaledTextStyle(Theme.of(context).textTheme.displayMedium, ui.textScaleFactor)),
          const SizedBox(height: AppSpacing.sm),
          Text(formatter.formatDate(state.now), style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor)),
        ])))),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: Column(children: [
          SwitchListTile.adaptive(title: const Text('24 小时制'), value: state.is24Hour, onChanged: notifier.set24Hour),
          SwitchListTile.adaptive(title: const Text('显示秒钟'), value: state.showSeconds, onChanged: notifier.setShowSeconds),
        ])),
      ],
    );
  }
}
