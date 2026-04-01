import 'package:flutter/material.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/models/tool_entry.dart';

/// 列表工具条目
class HomeToolListTile extends StatelessWidget {
  final ToolEntry tool;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HomeToolListTile({
    super.key,
    required this.tool,
    required this.isFavorite,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cs.primaryContainer,
        ),
        child: Icon(tool.icon, size: 22, color: cs.onPrimaryContainer),
      ),
      title: Text(
        tool.name,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        tool.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: isFavorite
          ? Icon(Icons.star_rounded, size: 18, color: cs.primary)
          : null,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 2),
    );
  }
}
