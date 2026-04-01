import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolbox/core/providers/settings_provider.dart';

/// 设置页 — 底栏第三个 Tab，Card 分组布局
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    Widget divider() =>
        Divider(height: 1, indent: 16, endIndent: 16, color: cs.outlineVariant);

    Widget sectionTitle(IconData icon, String title) => Row(
          children: [
            Icon(icon, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface)),
          ],
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ═══ 外观 ═══
          sectionTitle(Icons.palette_outlined, '外观'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // 主题模式
                _themeOption(cs, notifier, settings.themeMode,
                    ThemeMode.system, Icons.brightness_auto_rounded, '跟随系统'),
                divider(),
                _themeOption(cs, notifier, settings.themeMode,
                    ThemeMode.light, Icons.light_mode_rounded, '浅色模式'),
                divider(),
                _themeOption(cs, notifier, settings.themeMode,
                    ThemeMode.dark, Icons.dark_mode_rounded, '深色模式'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 强调色
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.color_lens_outlined, size: 20, color: cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('强调色',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text('主题种子色',
                            style: TextStyle(
                                fontSize: 12, color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  SegmentedButton<UiAccent>(
                    segments: const [
                      ButtonSegment(
                          value: UiAccent.green,
                          label: Text('绿'),
                          icon: Icon(Icons.forest_rounded, size: 16)),
                      ButtonSegment(
                          value: UiAccent.ocean,
                          label: Text('蓝'),
                          icon: Icon(Icons.water_rounded, size: 16)),
                      ButtonSegment(
                          value: UiAccent.amber,
                          label: Text('橙'),
                          icon: Icon(Icons.local_fire_department_rounded,
                              size: 16)),
                    ],
                    selected: {settings.accent},
                    onSelectionChanged: (s) => notifier.setAccent(s.first),
                    showSelectedIcon: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 莫奈取色
          Card(
            child: SwitchListTile(
              value: settings.monetEnabled,
              onChanged: notifier.setMonetEnabled,
              secondary: Icon(Icons.wallpaper_rounded, color: cs.primary),
              title: const Text('莫奈取色'),
              subtitle:
                  Text('Android 12+ 壁纸动态取色',
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            ),
          ),
          const SizedBox(height: 24),

          // ═══ 自定义 ═══
          sectionTitle(Icons.tune_rounded, '自定义'),
          const SizedBox(height: 8),

          // 预设方案
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('预设方案',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        selected: settings.currentPreset ==
                            UiPreset.compactEfficiency,
                        onSelected: (_) =>
                            notifier.applyPreset(UiPreset.compactEfficiency),
                        label: const Text('紧凑效率'),
                      ),
                      ChoiceChip(
                        selected: settings.currentPreset ==
                            UiPreset.largeTextReading,
                        onSelected: (_) =>
                            notifier.applyPreset(UiPreset.largeTextReading),
                        label: const Text('大字阅读'),
                      ),
                      ChoiceChip(
                        selected:
                            settings.currentPreset == UiPreset.minimalCards,
                        onSelected: (_) =>
                            notifier.applyPreset(UiPreset.minimalCards),
                        label: const Text('极简卡片'),
                      ),
                      ChoiceChip(
                        selected: settings.currentPreset ==
                            UiPreset.accessibilityHighContrast,
                        onSelected: (_) => notifier
                            .applyPreset(UiPreset.accessibilityHighContrast),
                        label: const Text('高对比无障碍'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 滑块设置
          Card(
            child: Column(
              children: [
                _sliderTile(
                  cs,
                  Icons.rounded_corner_rounded,
                  '卡片圆角',
                  '${settings.cardRadius.toStringAsFixed(0)}',
                  settings.cardRadius,
                  8,
                  28,
                  10,
                  notifier.setCardRadius,
                ),
                divider(),
                _sliderTile(
                  cs,
                  Icons.format_size_rounded,
                  '文字缩放',
                  '${settings.textScaleFactor.toStringAsFixed(2)}x',
                  settings.textScaleFactor,
                  0.9,
                  1.2,
                  6,
                  notifier.setTextScaleFactor,
                ),
                divider(),
                _sliderTile(
                  cs,
                  Icons.photo_size_select_large_rounded,
                  '图标缩放',
                  '${settings.iconScaleFactor.toStringAsFixed(2)}x',
                  settings.iconScaleFactor,
                  0.85,
                  1.3,
                  9,
                  notifier.setIconScaleFactor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 下拉设置
          Card(
            child: Column(
              children: [
                _dropdownTile<UiDensity>(
                  cs,
                  Icons.density_small_rounded,
                  '界面密度',
                  settings.density,
                  const [
                    DropdownMenuItem(
                        value: UiDensity.comfortable, child: Text('舒适')),
                    DropdownMenuItem(
                        value: UiDensity.compact, child: Text('紧凑')),
                  ],
                  notifier.setDensity,
                ),
                divider(),
                _dropdownTile<UiCardStyle>(
                  cs,
                  Icons.style_rounded,
                  '卡片风格',
                  settings.cardStyle,
                  const [
                    DropdownMenuItem(
                        value: UiCardStyle.soft, child: Text('柔和渐变')),
                    DropdownMenuItem(
                        value: UiCardStyle.flat, child: Text('纯色扁平')),
                  ],
                  notifier.setCardStyle,
                ),
                divider(),
                _dropdownTile<int>(
                  cs,
                  Icons.grid_view_rounded,
                  '网格列数',
                  settings.preferredColumns,
                  const [
                    DropdownMenuItem(value: 0, child: Text('自动')),
                    DropdownMenuItem(value: 2, child: Text('2 列')),
                    DropdownMenuItem(value: 3, child: Text('3 列')),
                    DropdownMenuItem(value: 4, child: Text('4 列')),
                  ],
                  notifier.setPreferredColumns,
                ),
                divider(),
                _dropdownTile<UiShadowLevel>(
                  cs,
                  Icons.blur_linear_rounded,
                  '阴影强度',
                  settings.shadowLevel,
                  const [
                    DropdownMenuItem(
                        value: UiShadowLevel.off, child: Text('关闭')),
                    DropdownMenuItem(
                        value: UiShadowLevel.soft, child: Text('柔和')),
                    DropdownMenuItem(
                        value: UiShadowLevel.strong, child: Text('明显')),
                  ],
                  notifier.setShadowLevel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 开关
          Card(
            child: Column(
              children: [
                _switchTile(cs, Icons.animation_rounded, '启用动画',
                    settings.enableAnimations, notifier.setAnimations),
                divider(),
                _switchTile(
                    cs,
                    Icons.description_outlined,
                    '显示工具描述',
                    settings.showToolDescription,
                    notifier.setShowToolDescription),
                divider(),
                _switchTile(cs, Icons.contrast_rounded, '高对比模式',
                    settings.highContrast, notifier.setHighContrast),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 恢复默认
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: notifier.resetAppearance,
              icon: const Icon(Icons.restore_rounded),
              label: const Text('恢复默认'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Theme option (ListTile) ─────────────────────────────────────────
  Widget _themeOption(
    ColorScheme cs,
    SettingsNotifier notifier,
    ThemeMode current,
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    final selected = current == mode;
    return ListTile(
      leading: Icon(icon, color: selected ? cs.primary : cs.onSurfaceVariant),
      title: Text(label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          )),
      trailing: selected
          ? Icon(Icons.check_rounded, color: cs.primary)
          : null,
      onTap: selected ? null : () => notifier.setThemeMode(mode),
    );
  }

  // ── Slider tile ─────────────────────────────────────────────────────
  Widget _sliderTile(
    ColorScheme cs,
    IconData icon,
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          SizedBox(
            width: 160,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ── Dropdown tile ───────────────────────────────────────────────────
  Widget _dropdownTile<T>(
    ColorScheme cs,
    IconData icon,
    String title,
    T value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: 120,
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              isDense: true,
              underline: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Switch tile ─────────────────────────────────────────────────────
  Widget _switchTile(
    ColorScheme cs,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: cs.primary),
      title: Text(title),
    );
  }
}
