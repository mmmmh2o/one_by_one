import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class TextComparePage extends ConsumerStatefulWidget {
  const TextComparePage({super.key});

  @override
  ConsumerState<TextComparePage> createState() => _TextComparePageState();
}

class _TextComparePageState extends ConsumerState<TextComparePage> {
  late final TextEditingController _leftController;
  late final TextEditingController _rightController;

  @override
  void initState() {
    super.initState();
    _leftController = TextEditingController();
    _rightController = TextEditingController();
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(textCompareProvider);
    final notifier = ref.read(textCompareProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('文本对比')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AppCard(
                child: TextField(
                  controller: _leftController,
                  minLines: 6,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(hintText: '文本 A（每行一条）', border: InputBorder.none),
                  onChanged: notifier.setLeft,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: AppCard(
                child: TextField(
                  controller: _rightController,
                  minLines: 6,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(hintText: '文本 B（每行一条）', border: InputBorder.none),
                  onChanged: notifier.setRight,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(label: '对比', onPressed: notifier.run),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: state.result == null
                  ? Text('等待对比结果', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('仅 A：${state.result!.onlyA.length} 项', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
                        Text('仅 B：${state.result!.onlyB.length} 项', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
                        Text('共同：${state.result!.both.length} 项', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
                        const SizedBox(height: AppSpacing.sm),
                        _PreviewChips(
                          title: '仅 A 预览',
                          values: state.result!.onlyA.toList()..sort(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _PreviewChips(
                          title: '仅 B 预览',
                          values: state.result!.onlyB.toList()..sort(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _PreviewChips(
                          title: '共同项预览',
                          values: state.result!.both.toList()..sort(),
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

class _PreviewChips extends StatelessWidget {
  final String title;
  final List<String> values;

  const _PreviewChips({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    final preview = values.take(8).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        if (preview.isEmpty)
          Text('无', style: Theme.of(context).textTheme.bodySmall)
        else
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final item in preview) InputChip(label: Text(item), onPressed: () {}),
            ],
          ),
      ],
    );
  }
}
