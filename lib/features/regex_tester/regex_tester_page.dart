import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class RegexTesterPage extends ConsumerStatefulWidget {
  const RegexTesterPage({super.key});
  @override
  ConsumerState<RegexTesterPage> createState() => _RegexTesterPageState();
}

class _RegexTesterPageState extends ConsumerState<RegexTesterPage> {
  late final TextEditingController _patternController;
  late final TextEditingController _inputController;
  @override
  void initState() { super.initState(); _patternController = TextEditingController(text: r'\b\w+@\w+\.\w+\b'); _inputController = TextEditingController(text: 'mail: demo@example.com'); }
  @override
  void dispose() { _patternController.dispose(); _inputController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(regexTesterProvider);
    final notifier = ref.read(regexTesterProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'regex_tester',
      children: [
        AppCard(child: Column(children: [
          TextField(controller: _patternController, decoration: const InputDecoration(labelText: '正则表达式'), onChanged: notifier.setPattern),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _inputController, minLines: 4, maxLines: 6, decoration: const InputDecoration(labelText: '测试文本'), onChanged: notifier.setInput),
          const SizedBox(height: AppSpacing.sm),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            FilterChip(label: const Text('区分大小写'), selected: state.caseSensitive, onSelected: notifier.setCaseSensitive),
            FilterChip(label: const Text('多行模式'), selected: state.multiLine, onSelected: notifier.setMultiLine),
            FilterChip(label: const Text('dotAll'), selected: state.dotAll, onSelected: notifier.setDotAll),
          ]),
        ])),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: '执行匹配', onPressed: notifier.run),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: state.result.error != null
            ? Text(state.result.error!, style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error), ui.textScaleFactor))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('匹配数量：${state.result.matches.length}', style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor)),
                const SizedBox(height: AppSpacing.sm),
                if (state.result.matches.isEmpty) Text('无匹配结果', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor))
                else ...state.result.matches.take(8).map((m) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.xs), child: Text('[${m.start}, ${m.end}) ${m.value}', style: scaledTextStyle(Theme.of(context).textTheme.bodySmall, ui.textScaleFactor)))),
              ])),
      ],
    );
  }
}
