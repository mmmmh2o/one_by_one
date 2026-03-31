import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class PaletteGeneratorPage extends ConsumerStatefulWidget {
  const PaletteGeneratorPage({super.key});
  @override
  ConsumerState<PaletteGeneratorPage> createState() => _PaletteGeneratorPageState();
}

class _PaletteGeneratorPageState extends ConsumerState<PaletteGeneratorPage> {
  late final TextEditingController _seedController;
  @override
  void initState() { super.initState(); _seedController = TextEditingController(text: 'toolbox'); }
  @override
  void dispose() { _seedController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paletteGeneratorProvider);
    final notifier = ref.read(paletteGeneratorProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'palette_generator',
      children: [
        AppCard(child: Column(children: [
          AppInput(label: '种子词', controller: _seedController, hint: '例如 brand / spring / sunset', onChanged: notifier.setSeed),
          const SizedBox(height: AppSpacing.md),
          Row(children: [Expanded(child: Text('颜色数量：${state.count}', style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium, ui.textScaleFactor)))]),
          Slider(min: 3, max: 10, divisions: 7, value: state.count.toDouble(), onChanged: (v) => notifier.setCount(v.round())),
        ])),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: '生成配色', onPressed: notifier.regenerate),
        const SizedBox(height: AppSpacing.lg),
        Expanded(child: ListView.separated(itemCount: state.colors.length, separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm), itemBuilder: (context, index) {
          final color = state.colors[index];
          final hex = state.hexValues[index];
          return AppCard(onTap: () async { await Clipboard.setData(ClipboardData(text: hex)); if (!context.mounted) return; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('已复制 $hex'))); }, child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(hex, style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor))),
            const Icon(Icons.copy, size: 18),
          ]));
        })),
      ],
    );
  }
}
