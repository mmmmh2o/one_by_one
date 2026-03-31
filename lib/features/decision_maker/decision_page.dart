import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class DecisionPage extends ConsumerStatefulWidget {
  const DecisionPage({super.key});

  @override
  ConsumerState<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends ConsumerState<DecisionPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '吃饭\n运动\n看书');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(decisionProvider);
    final notifier = ref.read(decisionProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('做个决定')),
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
                  hintText: '每行一个选项',
                  border: InputBorder.none,
                ),
                onChanged: notifier.setOptions,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: '帮我选一个', onPressed: notifier.pick),
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
                  : Text(
                      state.result == null ? '等待抽选结果' : '建议：${state.result!}',
                      style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
