import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/led_banner_logic.dart';
import 'providers.dart';

class LedBannerPage extends ConsumerStatefulWidget {
  const LedBannerPage({super.key});

  @override
  ConsumerState<LedBannerPage> createState() => _LedBannerPageState();
}

class _LedBannerPageState extends ConsumerState<LedBannerPage> {
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
    final state = ref.watch(ledBannerProvider);
    final notifier = ref.read(ledBannerProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'led_banner',
      children: [
        // 输入区
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('弹幕文字', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '输入要显示的文字',
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: notifier.setText,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 控制区
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('速度', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: LedSpeed.values.map((s) {
                  final label = switch (s) {
                    LedSpeed.slow => '慢',
                    LedSpeed.medium => '中',
                    LedSpeed.fast => '快',
                  };
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: state.speed == s,
                      onSelected: (_) => notifier.setSpeed(s),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('字号', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: LedFontSize.values.map((f) {
                  final label = switch (f) {
                    LedFontSize.small => '小',
                    LedFontSize.medium => '中',
                    LedFontSize.large => '大',
                  };
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: state.fontSize == f,
                      onSelected: (_) => notifier.setFontSize(f),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 滚动预览区
        SizedBox(
          height: 120,
          child: AppCard(
            child: ClipRect(
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 16),
                    left: state.scrolling
                        ? -state.scrollOffset % (_textWidth(state.text) + 320)
                        : 0,
                    child: Center(
                      child: Text(
                        state.text.isEmpty ? '在此输入弹幕文字' : state.text,
                        style: TextStyle(
                          fontSize: notifier.fontSizePx,
                          fontWeight: FontWeight.bold,
                          color: state.text.isEmpty
                              ? scheme.onSurfaceVariant.withOpacity(0.4)
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(
          label: state.scrolling ? '停止' : '开始滚动',
          onPressed: notifier.toggleScrolling,
        ),
      ],
    );
  }

  double _textWidth(String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}
