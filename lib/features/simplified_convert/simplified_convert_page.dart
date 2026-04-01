import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/simplified_convert_logic.dart';
import 'providers.dart';

class SimplifiedConvertPage extends ConsumerStatefulWidget {
  const SimplifiedConvertPage({super.key});

  @override
  ConsumerState<SimplifiedConvertPage> createState() =>
      _SimplifiedConvertPageState();
}

class _SimplifiedConvertPageState
    extends ConsumerState<SimplifiedConvertPage> {
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
    final state = ref.watch(simplifiedConvertProvider);
    final notifier = ref.read(simplifiedConvertProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    final isS2T = state.direction == ConvertDirection.s2t;

    return ToolScaffold(
      toolId: 'simplified_convert',
      scrollable: true,
      children: [
        // 方向切换
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: _DirChip(
                  label: '简 → 繁',
                  selected: isS2T,
                  onTap: () => notifier.setDirection(ConvertDirection.s2t),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: IconButton(
                  onPressed: notifier.swap,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: '交换方向',
                ),
              ),
              Expanded(
                child: _DirChip(
                  label: '繁 → 简',
                  selected: !isS2T,
                  onTap: () => notifier.setDirection(ConvertDirection.t2s),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 输入
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isS2T ? '输入简体中文' : '输入繁体中文',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: '在此粘贴或输入文字',
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: notifier.setInput,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 输出
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isS2T ? '繁体结果' : '简体结果',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (state.output.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: state.output));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已复制到剪贴板')),
                        );
                      },
                      tooltip: '复制结果',
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SelectableText(
                state.output.isEmpty ? '转换结果将在此显示' : state.output,
                style: scaledTextStyle(
                  state.output.isEmpty
                      ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant.withOpacity(0.4),
                          )
                      : Theme.of(context).textTheme.bodyLarge,
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

class _DirChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DirChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? scheme.onPrimaryContainer
                  : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
