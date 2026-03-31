import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/core/providers/settings_provider.dart';
import 'package:toolbox/features/home/tool_entry_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    if (allTools.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('工具正在建设中…')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.16),
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.12),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('工具箱', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '轻量、离线优先、可扩展的多工具集合',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Text('已接入 ${allTools.length} 个工具', style: Theme.of(context).textTheme.bodySmall),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              showDragHandle: true,
                              builder: (sheetContext) {
                                return SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSpacing.md),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('UI 自定义', style: Theme.of(context).textTheme.headlineSmall),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          '预设方案（当前：${_presetLabel(settings.currentPreset)}）',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Wrap(
                                          spacing: AppSpacing.sm,
                                          runSpacing: AppSpacing.sm,
                                          children: [
                                            ChoiceChip(
                                              selected: settings.currentPreset == UiPreset.compactEfficiency,
                                              onSelected: (_) => notifier.applyPreset(UiPreset.compactEfficiency),
                                              label: const Text('紧凑效率'),
                                            ),
                                            ChoiceChip(
                                              selected: settings.currentPreset == UiPreset.largeTextReading,
                                              onSelected: (_) => notifier.applyPreset(UiPreset.largeTextReading),
                                              label: const Text('大字阅读'),
                                            ),
                                            ChoiceChip(
                                              selected: settings.currentPreset == UiPreset.minimalCards,
                                              onSelected: (_) => notifier.applyPreset(UiPreset.minimalCards),
                                              label: const Text('极简卡片'),
                                            ),
                                            ChoiceChip(
                                              selected: settings.currentPreset == UiPreset.accessibilityHighContrast,
                                              onSelected: (_) => notifier.applyPreset(UiPreset.accessibilityHighContrast),
                                              label: const Text('高对比无障碍'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        DropdownButtonFormField<ThemeMode>(
                                          value: settings.themeMode,
                                          decoration: const InputDecoration(labelText: '主题模式'),
                                          items: const [
                                            DropdownMenuItem(value: ThemeMode.system, child: Text('跟随系统')),
                                            DropdownMenuItem(value: ThemeMode.light, child: Text('浅色')),
                                            DropdownMenuItem(value: ThemeMode.dark, child: Text('深色')),
                                          ],
                                          onChanged: (mode) {
                                            if (mode != null) notifier.setThemeMode(mode);
                                          },
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        DropdownButtonFormField<UiDensity>(
                                          value: settings.density,
                                          decoration: const InputDecoration(labelText: '界面密度'),
                                          items: const [
                                            DropdownMenuItem(value: UiDensity.comfortable, child: Text('舒适')),
                                            DropdownMenuItem(value: UiDensity.compact, child: Text('紧凑')),
                                          ],
                                          onChanged: (density) {
                                            if (density != null) notifier.setDensity(density);
                                          },
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        DropdownButtonFormField<UiAccent>(
                                          value: settings.accent,
                                          decoration: const InputDecoration(labelText: '强调色'),
                                          items: const [
                                            DropdownMenuItem(value: UiAccent.green, child: Text('森林绿')),
                                            DropdownMenuItem(value: UiAccent.ocean, child: Text('海洋蓝')),
                                            DropdownMenuItem(value: UiAccent.amber, child: Text('琥珀橙')),
                                          ],
                                          onChanged: (accent) {
                                            if (accent != null) notifier.setAccent(accent);
                                          },
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Text('卡片圆角 ${settings.cardRadius.toStringAsFixed(0)}'),
                                        Slider(
                                          min: 8,
                                          max: 24,
                                          divisions: 8,
                                          value: settings.cardRadius,
                                          onChanged: notifier.setCardRadius,
                                        ),
                                        SwitchListTile(
                                          value: settings.enableAnimations,
                                          onChanged: notifier.setAnimations,
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('启用动画'),
                                        ),
                                        SwitchListTile(
                                          value: settings.showToolDescription,
                                          onChanged: notifier.setShowToolDescription,
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('显示工具描述'),
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        DropdownButtonFormField<UiCardStyle>(
                                          value: settings.cardStyle,
                                          decoration: const InputDecoration(labelText: '卡片风格'),
                                          items: const [
                                            DropdownMenuItem(value: UiCardStyle.soft, child: Text('柔和渐变')),
                                            DropdownMenuItem(value: UiCardStyle.flat, child: Text('纯色扁平')),
                                          ],
                                          onChanged: (style) {
                                            if (style != null) notifier.setCardStyle(style);
                                          },
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Text('文字缩放 ${settings.textScaleFactor.toStringAsFixed(2)}'),
                                        Slider(
                                          min: 0.9,
                                          max: 1.2,
                                          divisions: 6,
                                          value: settings.textScaleFactor,
                                          onChanged: notifier.setTextScaleFactor,
                                        ),
                                        Text('图标缩放 ${settings.iconScaleFactor.toStringAsFixed(2)}'),
                                        Slider(
                                          min: 0.85,
                                          max: 1.3,
                                          divisions: 9,
                                          value: settings.iconScaleFactor,
                                          onChanged: notifier.setIconScaleFactor,
                                        ),
                                        DropdownButtonFormField<int>(
                                          value: settings.preferredColumns,
                                          decoration: const InputDecoration(labelText: '网格列数'),
                                          items: const [
                                            DropdownMenuItem(value: 0, child: Text('自动')),
                                            DropdownMenuItem(value: 2, child: Text('2 列')),
                                            DropdownMenuItem(value: 3, child: Text('3 列')),
                                            DropdownMenuItem(value: 4, child: Text('4 列')),
                                          ],
                                          onChanged: (columns) {
                                            if (columns != null) notifier.setPreferredColumns(columns);
                                          },
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        DropdownButtonFormField<UiShadowLevel>(
                                          value: settings.shadowLevel,
                                          decoration: const InputDecoration(labelText: '阴影强度'),
                                          items: const [
                                            DropdownMenuItem(value: UiShadowLevel.off, child: Text('关闭')),
                                            DropdownMenuItem(value: UiShadowLevel.soft, child: Text('柔和')),
                                            DropdownMenuItem(value: UiShadowLevel.strong, child: Text('明显')),
                                          ],
                                          onChanged: (level) {
                                            if (level != null) notifier.setShadowLevel(level);
                                          },
                                        ),
                                        SwitchListTile(
                                          value: settings.highContrast,
                                          onChanged: notifier.setHighContrast,
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text('高对比模式'),
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: OutlinedButton.icon(
                                            onPressed: notifier.resetAppearance,
                                            icon: const Icon(Icons.restore),
                                            label: const Text('恢复默认'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.tune),
                          label: const Text('自定义'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ToolEntryList(
                tools: allTools,
                onTap: (tool) => context.push('/tool/${tool.id}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(UiPreset preset) {
    switch (preset) {
      case UiPreset.compactEfficiency:
        return '紧凑效率';
      case UiPreset.largeTextReading:
        return '大字阅读';
      case UiPreset.minimalCards:
        return '极简卡片';
      case UiPreset.accessibilityHighContrast:
        return '高对比无障碍';
      case UiPreset.custom:
      default:
        return '自定义';
    }
  }
}
