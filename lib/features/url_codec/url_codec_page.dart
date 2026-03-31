import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class UrlCodecPage extends ConsumerStatefulWidget {
  const UrlCodecPage({super.key});
  @override
  ConsumerState<UrlCodecPage> createState() => _UrlCodecPageState();
}

class _UrlCodecPageState extends ConsumerState<UrlCodecPage> {
  late final TextEditingController _controller;
  @override
  void initState() { super.initState(); _controller = TextEditingController(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(urlCodecProvider);
    final notifier = ref.read(urlCodecProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'url_codec',
      children: [
        AppCard(child: TextField(controller: _controller, minLines: 5, maxLines: 8, decoration: const InputDecoration(hintText: '输入 URL 或参数文本', border: InputBorder.none), onChanged: notifier.setInput)),
        const SizedBox(height: AppSpacing.md),
        Row(children: [Expanded(child: AppButton(label: '编码', onPressed: notifier.encode)), const SizedBox(width: AppSpacing.sm), Expanded(child: AppButton(label: '解码', onPressed: notifier.decode, isPrimary: false))]),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, children: [
          ActionChip(label: const Text('示例'), onPressed: () { const s = 'https://example.com/search?q=flutter riverpod'; _controller.text = s; notifier.setInput(s); }),
          ActionChip(label: const Text('复制结果'), onPressed: state.output.isEmpty ? null : () async { await Clipboard.setData(ClipboardData(text: state.output)); if (!context.mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已复制'))); }),
        ]),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: state.error != null
            ? Text(state.error!, style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error), ui.textScaleFactor))
            : SelectableText(state.output.isEmpty ? '等待处理结果' : state.output, style: scaledTextStyle(Theme.of(context).textTheme.bodyLarge, ui.textScaleFactor))),
      ],
    );
  }
}
