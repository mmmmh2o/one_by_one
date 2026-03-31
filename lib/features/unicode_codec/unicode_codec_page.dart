import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'providers.dart';

class UnicodeCodecPage extends ConsumerStatefulWidget {
  const UnicodeCodecPage({super.key});

  @override
  ConsumerState<UnicodeCodecPage> createState() => _UnicodeCodecPageState();
}

class _UnicodeCodecPageState extends ConsumerState<UnicodeCodecPage> {
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
    final state = ref.watch(unicodeCodecProvider);
    final notifier = ref.read(unicodeCodecProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Unicode 编解码')),
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
                  hintText: '输入普通文本或 \\u4F60\\u597D / \\u{1F44D}',
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
                  : SelectableText(
                      state.output.isEmpty ? '等待处理结果' : state.output,
                      style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '支持 \\uXXXX 与 \\u{1F44D} 两种格式，保持 Material 3 输入体验。',
              style: scaledTextStyle(Theme.of(context).textTheme.bodySmall, ui.textScaleFactor),
            ),
          ],
        ),
      ),
    );
  }
}
