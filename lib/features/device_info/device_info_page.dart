import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class DeviceInfoPage extends ConsumerWidget {
  const DeviceInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceInfoProvider);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'device_info',
      scrollable: true,
      children: [
        if (state.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: CircularProgressIndicator(),
            ),
          )
        else ...[
          // 顶部设备图标
          Center(
            child: Icon(
              Icons.phone_android_rounded,
              size: 56,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 信息列表
          ...state.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: item.value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已复制：${item.label}')),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.label,
                          style: scaledTextStyle(
                            Theme.of(context).textTheme.bodyMedium,
                            ui.textScaleFactor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          item.value,
                          textAlign: TextAlign.end,
                          style: scaledTextStyle(
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            ui.textScaleFactor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              '点击任意条目可复制',
              style: scaledTextStyle(
                Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                ui.textScaleFactor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
