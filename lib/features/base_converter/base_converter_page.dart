import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class BaseConverterPage extends ConsumerStatefulWidget {
  const BaseConverterPage({super.key});
  @override
  ConsumerState<BaseConverterPage> createState() => _BaseConverterPageState();
}

class _BaseConverterPageState extends ConsumerState<BaseConverterPage> {
  late final TextEditingController _inputController;
  @override
  void initState() { super.initState(); _inputController = TextEditingController(); }
  @override
  void dispose() { _inputController.dispose(); super.dispose(); }

  static const _baseItems = [
    DropdownMenuItem(value: 2, child: Text('2 进制 (Binary)')),
    DropdownMenuItem(value: 8, child: Text('8 进制 (Octal)')),
    DropdownMenuItem(value: 10, child: Text('10 进制 (Decimal)')),
    DropdownMenuItem(value: 16, child: Text('16 进制 (Hex)')),
    DropdownMenuItem(value: 32, child: Text('32 进制')),
    DropdownMenuItem(value: 36, child: Text('36 进制')),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(baseConverterProvider);
    final notifier = ref.read(baseConverterProvider.notifier);
    final ui = ref.watch(settingsProvider);

    return ToolScaffold(
      toolId: 'base_converter',
      children: [
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppInput(label: '输入值', hint: '例如 1010 / FF / 255', controller: _inputController, onChanged: notifier.updateInput),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(value: state.fromBase, decoration: const InputDecoration(labelText: '源进制'), items: _baseItems, onChanged: (v) { if (v != null) notifier.setFromBase(v); }),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(value: state.toBase, decoration: const InputDecoration(labelText: '目标进制'), items: _baseItems, onChanged: (v) { if (v != null) notifier.setToBase(v); }),
        ])),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: '转换', onPressed: notifier.convert),
        const SizedBox(height: AppSpacing.sm),
        AppButton(label: '交换进制', onPressed: notifier.swapBase, isPrimary: false),
        const SizedBox(height: AppSpacing.lg),
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('结果', style: scaledTextStyle(Theme.of(context).textTheme.titleMedium, ui.textScaleFactor)),
          const SizedBox(height: AppSpacing.sm),
          if (state.error != null) Text(state.error!, style: scaledTextStyle(Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error), ui.textScaleFactor))
          else SelectableText(state.output.isEmpty ? '等待输入并转换' : state.output, style: scaledTextStyle(Theme.of(context).textTheme.headlineSmall, ui.textScaleFactor)),
        ])),
      ],
    );
  }
}
