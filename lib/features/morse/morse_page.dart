import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class MorsePage extends ConsumerStatefulWidget {
  const MorsePage({super.key});

  @override
  ConsumerState<MorsePage> createState() => _MorsePageState();
}

class _MorsePageState extends ConsumerState<MorsePage> {
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
    final state = ref.watch(morseProvider);
    final notifier = ref.read(morseProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'morse',
      children: [
        AppCard(
          child: TextField(
            controller: _controller,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '输入文本或摩尔斯码（空格分隔，/ 代表空格）',
              border: InputBorder.none,
            ),
            onChanged: notifier.setInput,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: AppButton(label: '编码', onPressed: notifier.encode)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: AppButton(label: '解码', onPressed: notifier.decode, isPrimary: false)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: SelectableText(
            state.output.isEmpty ? '等待转换结果' : state.output,
            style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
          ),
        ),
      ],
    );
  }
}
