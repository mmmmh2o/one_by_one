import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class TextDedupSortPage extends ConsumerStatefulWidget {
  const TextDedupSortPage({super.key});
  @override
  ConsumerState<TextDedupSortPage> createState() => _TextDedupSortPageState();
}

class _TextDedupSortPageState extends ConsumerState<TextDedupSortPage> {
  late final TextEditingController _controller;
  @override
  void initState() { super.initState(); _controller = TextEditingController(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(textDedupSortProvider);
    final notifier = ref.read(textDedupSortProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'text_dedup_sort',
      children: [
        AppCard(child: TextField(controller: _controller, minLines: 6, maxLines: 10, decoration: const InputDecoration(hintText: '每行一条文本', border: InputBorder.none), onChanged: notifier.setInput)),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          FilterChip(label: const Text('升序'), selected: state.ascending, onSelected: (v) => notifier.setAscending(v)),
          FilterChip(label: const Text('忽略大小写'), selected: state.ignoreCase, onSelected: notifier.setIgnoreCase),
        ]),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: '处理文本', onPressed: notifier.process),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('总行数：${state.totalLines}，去重后：${state.uniqueLines}', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(state.output.isEmpty ? '等待处理结果' : state.output, style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)),
        ])),
      ],
    );
  }
}
