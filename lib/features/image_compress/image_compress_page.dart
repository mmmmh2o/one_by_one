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

class ImageCompressPage extends ConsumerWidget {
  const ImageCompressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageCompressProvider);
    final notifier = ref.read(imageCompressProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'image_compress',
      scrollable: true,
      children: [
        // 选择图片
        AppButton(label: '选择图片', onPressed: notifier.pickImage),

        if (state.originalBytes != null) ...[
          const SizedBox(height: AppSpacing.lg),

          // 对比卡片
          AppCard(
            child: Column(
              children: [
                _SizeRow(
                  label: '原始大小',
                  value: notifier.formatSize(state.originalSize),
                  icon: Icons.image_outlined,
                ),
                Divider(color: scheme.outlineVariant),
                _SizeRow(
                  label: '压缩后',
                  value: notifier.formatSize(state.compressedSize),
                  icon: Icons.compress,
                ),
                Divider(color: scheme.outlineVariant),
                _SizeRow(
                  label: '压缩率',
                  value: '${notifier.ratio.toStringAsFixed(1)}%',
                  icon: Icons.trending_down,
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 质量滑块
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JPEG 质量：${state.quality}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Slider(
                  value: state.quality.toDouble(),
                  min: 10,
                  max: 100,
                  divisions: 18,
                  label: '${state.quality}',
                  onChanged: (v) => notifier.setQuality(v.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 最大宽度
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最大宽度：${state.maxWidth == 0 ? "原始" : "${state.maxWidth}px"}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Slider(
                  value: state.maxWidth.toDouble(),
                  min: 0,
                  max: 2000,
                  divisions: 20,
                  label: state.maxWidth == 0 ? '原始' : '${state.maxWidth}',
                  onChanged: (v) => notifier.setMaxWidth(v.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (state.compressing)
            const Center(child: CircularProgressIndicator())
          else if (state.compressedBytes != null)
            AppButton(
              label: '复制压缩图片',
              onPressed: () {
                // 压缩后字节无法直接复制到剪贴板为图片
                // 这里提供大小信息作为提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '压缩完成：${notifier.formatSize(state.compressedSize)}',
                    ),
                  ),
                );
              },
            ),

          // 预览
          const SizedBox(height: AppSpacing.lg),
          if (state.compressedBytes != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('压缩预览',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      state.compressedBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _SizeRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  const _SizeRow({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: highlight ? scheme.primary : null),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: highlight ? scheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
