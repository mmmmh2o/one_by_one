import 'package:flutter/material.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/models/tool_entry.dart';

/// 网格工具卡片
class HomeToolGridCard extends StatelessWidget {
  final ToolEntry tool;
  final bool isFavorite;
  final bool showDescription;
  final double iconScale;
  final double cardRadius;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HomeToolGridCard({
    super.key,
    required this.tool,
    required this.isFavorite,
    this.showDescription = true,
    this.iconScale = 1.0,
    this.cardRadius = 16,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10 * iconScale),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cs.primaryContainer,
                    ),
                    child: Icon(
                      tool.icon,
                      size: 24 * iconScale,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    tool.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (showDescription) ...[
                    const SizedBox(height: 2),
                    Text(
                      tool.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
            if (isFavorite)
              Positioned(
                top: 6,
                right: 6,
                child:
                    Icon(Icons.star_rounded, size: 16, color: cs.primary),
              ),
          ],
        ),
      ),
    );
  }
}
