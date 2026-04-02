import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/code_formatter.dart';
import 'providers.dart';

class CodeFormatterPage extends ConsumerStatefulWidget {
  const CodeFormatterPage({super.key});

  @override
  ConsumerState<CodeFormatterPage> createState() => _CodeFormatterPageState();
}

class _CodeFormatterPageState extends ConsumerState<CodeFormatterPage> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(codeFormatterProvider);
    final notifier = ref.read(codeFormatterProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final monoStyle = scaledTextStyle(
      textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
      ui.textScaleFactor,
    );

    return ToolScaffold(
      toolId: 'code_formatter',
      children: [
        // 语言选择
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '语言类型',
                style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: CodeFormatType.values.map((type) {
                  final selected = state.formatType == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: selected,
                    onSelected: (_) {
                      notifier.setFormatType(type);
                      _inputController.clear();
                      notifier.setInput('');
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 输入区
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '输入代码',
                      style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor),
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.auto_fix_high, size: 18, color: cs.primary),
                    label: Text('加载示例', style: TextStyle(color: cs.primary)),
                    onPressed: () {
                      notifier.loadExample();
                      _inputController.text = ref.read(codeFormatterProvider).input;
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _inputController,
                minLines: 4,
                maxLines: 12,
                style: monoStyle,
                decoration: const InputDecoration(
                  hintText: '粘贴代码到此处...',
                  border: InputBorder.none,
                ),
                onChanged: notifier.setInput,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 操作按钮
        Row(
          children: [
            Expanded(child: AppButton(label: '✨ 格式化', onPressed: notifier.format)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: AppButton(label: '📦 压缩', onPressed: notifier.compress, isPrimary: false)),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // 输出区
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '结果',
                      style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor),
                    ),
                  ),
                  if (state.output.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.copy, size: 20, color: cs.onSurfaceVariant),
                      tooltip: '复制结果',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: state.output));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('已复制到剪贴板'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              SelectableText(
                state.output.isEmpty ? '格式化/压缩结果将显示在此处' : state.output,
                style: monoStyle.copyWith(
                  color: state.output.isEmpty ? cs.onSurfaceVariant : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
