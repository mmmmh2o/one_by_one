import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class TextStatsPage extends ConsumerStatefulWidget {
  const TextStatsPage({super.key});

  @override
  ConsumerState<TextStatsPage> createState() => _TextStatsPageState();
}

class _TextStatsPageState extends ConsumerState<TextStatsPage> {
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
    final state = ref.watch(textStatsProvider);
    final notifier = ref.read(textStatsProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('字数统计')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: TextField(
                controller: _controller,
                minLines: 6,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '输入或粘贴文本',
                  border: InputBorder.none,
                ),
                onChanged: notifier.setInput,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(context, ui, '字符数', state.result.chars.toString()),
                  _row(context, ui, '不含空白字符', state.result.charsNoSpaces.toString()),
                  _row(context, ui, '单词数', state.result.words.toString()),
                  _row(context, ui, '行数', state.result.lines.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, SettingsState ui, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor),
            ),
          ),
          Text(
            value,
            style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor),
          ),
        ],
      ),
    );
  }
}
