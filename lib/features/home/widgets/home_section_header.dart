import 'package:flutter/material.dart';
import 'package:toolbox/features/home/widgets/home_category_chips.dart';
import 'package:toolbox/models/tool_entry.dart';

/// 通用分区标题（"最近使用"、"我的收藏"等）
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }
}

/// 分类标题（带分类图标和工具数量标签）
class CategoryHeader extends StatelessWidget {
  final ToolCategory cat;
  final int count;
  const CategoryHeader({super.key, required this.cat, required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final meta = kHomeCategories[cat];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Icon(meta?.$2 ?? Icons.apps_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 6),
          Text(meta?.$1 ?? '其他',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cs.primaryContainer.withValues(alpha: 0.5),
            ),
            child: Text('$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onPrimaryContainer)),
          ),
        ],
      ),
    );
  }
}
