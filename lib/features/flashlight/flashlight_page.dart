import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'logic/flashlight_logic.dart';
import 'providers.dart';

class FlashlightPage extends ConsumerWidget {
  const FlashlightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashlightProvider);
    final notifier = ref.read(flashlightProvider.notifier);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    final isOn = state.status == FlashlightStatus.on;
    final unsupported = state.status == FlashlightStatus.unsupported;

    return ToolScaffold(
      toolId: 'flashlight',
      children: [
        const SizedBox(height: AppSpacing.xxl),

        // 状态指示
        Center(
          child: Text(
            unsupported
                ? '设备不支持手电筒'
                : isOn
                    ? '已开启'
                    : '已关闭',
            style: scaledTextStyle(
              Theme.of(context).textTheme.headlineSmall,
              ui.textScaleFactor,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // 开关按钮
        Center(
          child: GestureDetector(
            onTap: unsupported ? null : notifier.toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unsupported
                    ? scheme.surfaceContainerHighest
                    : isOn
                        ? scheme.primary
                        : scheme.primaryContainer,
                boxShadow: isOn
                    ? [
                        BoxShadow(
                          color: scheme.primary.withOpacity(0.4),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                size: 56,
                color: unsupported
                    ? scheme.onSurfaceVariant
                    : isOn
                        ? scheme.onPrimary
                        : scheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // 提示
        AppCard(
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '点击按钮开关手电筒。长时间使用会消耗电量。',
                  style: scaledTextStyle(
                    Theme.of(context).textTheme.bodySmall,
                    ui.textScaleFactor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
