import 'package:flutter/material.dart';
import 'package:toolbox/models/tool_entry.dart';

const kHomeCategories = <ToolCategory, (String label, IconData icon)>{
  ToolCategory.daily: ('日常', Icons.wb_sunny_outlined),
  ToolCategory.calculator: ('计算', Icons.calculate_outlined),
  ToolCategory.text: ('文本', Icons.text_snippet_outlined),
  ToolCategory.device: ('设备', Icons.phone_android_rounded),
  ToolCategory.image: ('图片', Icons.image_outlined),
  ToolCategory.other: ('趣味', Icons.auto_awesome_outlined),
  ToolCategory.thirdParty: ('高级', Icons.extension_outlined),
};

/// 分类筛选 Chips — 水平滚动
class HomeCategoryChips extends StatelessWidget {
  final ToolCategory? selected;
  final ValueChanged<ToolCategory?> onSelected;

  const HomeCategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kHomeCategories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            final sel = selected == null;
            return FilterChip(
              label: const Text('全部'),
              selected: sel,
              showCheckmark: false,
              avatar: sel
                  ? Icon(Icons.check_rounded,
                      size: 18, color: cs.onSecondaryContainer)
                  : null,
              onSelected: (_) => onSelected(null),
            );
          }
          final entry = kHomeCategories.entries.elementAt(i - 1);
          final cat = entry.key;
          final (label, icon) = entry.value;
          final sel = selected == cat;
          return FilterChip(
            label: Text(label),
            selected: sel,
            showCheckmark: false,
            avatar: Icon(
              icon,
              size: 18,
              color: sel ? cs.onSecondaryContainer : cs.onSurfaceVariant,
            ),
            onSelected: (_) => onSelected(sel ? null : cat),
          );
        },
      ),
    );
  }
}
