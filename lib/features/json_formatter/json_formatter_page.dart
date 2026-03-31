import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class JsonFormatterPage extends ConsumerStatefulWidget {
  const JsonFormatterPage({super.key});
  @override
  ConsumerState<JsonFormatterPage> createState() => _JsonFormatterPageState();
}

class _JsonFormatterPageState extends ConsumerState<JsonFormatterPage> {
  late final TextEditingController _controller;
  final _sampleJson = '{"name":"toolbox","version":1,"tags":["flutter","riverpod"]}';
  @override
  void initState() { super.initState(); _controller = TextEditingController(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jsonFormatterProvider);
    final notifier = ref.read(jsonFormatterProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'json_formatter',
      children: [
        AppCard(child: TextField(controller: _controller, minLines: 8, maxLines: 12, decoration: const InputDecoration(hintText: '粘贴 JSON 文本', border: InputBorder.none), onChanged: notifier.setInput)),
        const SizedBox(height: AppSpacing.md),
        Row(children: [Expanded(child: AppButton(label: '格式化', onPressed: notifier.pretty)), const SizedBox(width: AppSpacing.sm), Expanded(child: AppButton(label: '压缩', onPressed: notifier.minify, isPrimary: false))]),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          ActionChip(label: const Text('填充示例'), onPressed: () { _controller.text = _sampleJson; notifier.setInput(_sampleJson); }),
          ActionChip(label: const Text('清空'), onPressed: () { _controller.clear(); notifier.setInput(''); }),
        ]),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: state.error != null
            ? Text(state.error!, style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error), ui.textScaleFactor))
            : SelectableText(state.output.isEmpty ? '等待处理结果' : state.output, style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor))),
      ],
    );
  }
}
