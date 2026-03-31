import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class EatWhatPage extends ConsumerStatefulWidget {
  const EatWhatPage({super.key});

  @override
  ConsumerState<EatWhatPage> createState() => _EatWhatPageState();
}

class _EatWhatPageState extends ConsumerState<EatWhatPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '牛肉面\n盖饭\n沙拉\n饺子\n轻食');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eatWhatProvider);
    final notifier = ref.read(eatWhatProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('今天吃什么')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: TextField(
                controller: _controller,
                minLines: 5,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: '每行一个候选菜品',
                  border: InputBorder.none,
                ),
                onChanged: notifier.setOptions,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '帮我选一道', onPressed: notifier.suggest),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Text(
                state.suggestion,
                style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
