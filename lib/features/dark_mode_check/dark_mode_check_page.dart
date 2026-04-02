import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class DarkModeCheckPage extends ConsumerStatefulWidget {
  const DarkModeCheckPage({super.key});

  @override
  ConsumerState<DarkModeCheckPage> createState() => _DarkModeCheckPageState();
}

class _DarkModeCheckPageState extends ConsumerState<DarkModeCheckPage> {
  late final TextEditingController _bgController;
  late final TextEditingController _fgController;

  @override
  void initState() {
    super.initState();
    _bgController = TextEditingController(text: '#1A1A2E');
    _fgController = TextEditingController(text: '#FFFFFF');
  }

  @override
  void dispose() {
    _bgController.dispose();
    _fgController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('ff$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(darkModeProvider);
    final notifier = ref.read(darkModeProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ToolScaffold(
      toolId: 'dark_mode_check',
      children: [
        // 颜色输入
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('背景色', style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _hexToColor(state.bgColorHex),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.outline),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _bgController,
                      decoration: const InputDecoration(
                        hintText: '#1A1A2E',
                        isDense: true,
                      ),
                      onSubmitted: notifier.setBgColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('前景色', style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _hexToColor(state.fgColorHex),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.outline),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _fgController,
                      decoration: const InputDecoration(
                        hintText: '#FFFFFF',
                        isDense: true,
                      ),
                      onSubmitted: notifier.setFgColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: '交换颜色',
                      onPressed: () {
                        notifier.swapColors();
                        _bgController.text = ref.read(darkModeProvider).bgColorHex;
                        _fgController.text = ref.read(darkModeProvider).fgColorHex;
                      },
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: '推荐前景色',
                      onPressed: () {
                        notifier.useRecommendedFg();
                        _fgController.text = ref.read(darkModeProvider).fgColorHex;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 实时预览
        AppCard(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: _hexToColor(state.bgColorHex),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '预览文字 · Aa 你好 World',
                  style: TextStyle(
                    color: _hexToColor(state.fgColorHex),
                    fontSize: 18 * ui.textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '这是一段较长的正文内容，用于测试背景色与前景色在实际阅读中的对比度和可读性。',
                  style: TextStyle(
                    color: _hexToColor(state.fgColorHex),
                    fontSize: 14 * ui.textScaleFactor,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 对比度结果
        AppCard(
          child: Column(
            children: [
              _InfoRow(label: '对比度', value: '${state.contrastRatio.toStringAsFixed(2)}:1'),
              _InfoRow(label: 'WCAG 等级', value: state.wcagLevel),
              _InfoRow(label: '背景深浅', value: state.bgIsDark ? '深色 🌑' : '浅色 ☀️'),
              _InfoRow(label: '前景深浅', value: state.fgIsDark ? '深色 🌑' : '浅色 ☀️'),
              _InfoRow(label: '色温', value: state.colorTemp),
              _InfoRow(label: '推荐前景', value: state.recommendedFg),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 快速预设
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('常用预设', style: scaledTextStyle(textTheme.titleSmall, ui.textScaleFactor)),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _PresetChip(
                    label: '深色模式',
                    bg: '#121212', fg: '#FFFFFF',
                    onTap: (bg, fg) {
                      notifier.setBgColor(bg); notifier.setFgColor(fg);
                      _bgController.text = bg; _fgController.text = fg;
                    },
                  ),
                  _PresetChip(
                    label: '浅色模式',
                    bg: '#FFFFFF', fg: '#212121',
                    onTap: (bg, fg) {
                      notifier.setBgColor(bg); notifier.setFgColor(fg);
                      _bgController.text = bg; _fgController.text = fg;
                    },
                  ),
                  _PresetChip(
                    label: '护眼绿',
                    bg: '#1B4332', fg: '#D8F3DC',
                    onTap: (bg, fg) {
                      notifier.setBgColor(bg); notifier.setFgColor(fg);
                      _bgController.text = bg; _fgController.text = fg;
                    },
                  ),
                  _PresetChip(
                    label: '暖白',
                    bg: '#FFF8F0', fg: '#3D2C2E',
                    onTap: (bg, fg) {
                      notifier.setBgColor(bg); notifier.setFgColor(fg);
                      _bgController.text = bg; _fgController.text = fg;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final String bg;
  final String fg;
  final void Function(String bg, String fg) onTap;

  const _PresetChip({required this.label, required this.bg, required this.fg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Color(int.parse('ff${bg.replaceAll('#', '')}', radix: 16)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      label: Text(label),
      onPressed: () => onTap(bg, fg),
    );
  }
}
