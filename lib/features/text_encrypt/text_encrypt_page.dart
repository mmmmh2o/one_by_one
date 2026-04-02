import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/text_encrypt.dart';
import 'providers.dart';

class TextEncryptPage extends ConsumerStatefulWidget {
  const TextEncryptPage({super.key});

  @override
  ConsumerState<TextEncryptPage> createState() => _TextEncryptPageState();
}

class _TextEncryptPageState extends ConsumerState<TextEncryptPage> {
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
    final state = ref.watch(textEncryptProvider);
    final notifier = ref.read(textEncryptProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ToolScaffold(
      toolId: 'text_encrypt',
      children: [
        // 算法选择
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '加密算法',
                style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: CipherType.values.map((type) {
                  final selected = state.cipherType == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: selected,
                    onSelected: (_) => notifier.setCipherType(type),
                  );
                }).toList(),
              ),
              // 凯撒密码偏移量滑块
              if (state.cipherType == CipherType.caesar) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      '偏移量: ${state.caesarShift}',
                      style: scaledTextStyle(textTheme.bodyMedium, ui.textScaleFactor),
                    ),
                    Expanded(
                      child: Slider(
                        value: state.caesarShift.toDouble(),
                        min: 1,
                        max: 25,
                        divisions: 24,
                        onChanged: (v) => notifier.setCaesarShift(v.toInt()),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 输入区
        AppCard(
          child: TextField(
            controller: _inputController,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '输入要加密或解密的文字',
              border: InputBorder.none,
            ),
            onChanged: notifier.setInput,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 操作按钮
        Row(
          children: [
            Expanded(child: AppButton(label: '🔒 加密', onPressed: notifier.encrypt)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: AppButton(label: '🔓 解密', onPressed: notifier.decrypt, isPrimary: false)),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // 交换按钮
        Center(
          child: IconButton(
            icon: Icon(Icons.swap_vert, color: cs.primary),
            tooltip: '交换输入与输出',
            onPressed: () {
              notifier.swap();
              _inputController.text = ref.read(textEncryptProvider).input;
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

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
                state.output.isEmpty ? '等待加密/解密结果' : state.output,
                style: scaledTextStyle(
                  state.output.isEmpty
                      ? textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant)
                      : textTheme.bodyLarge,
                  ui.textScaleFactor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
