import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../models/tool_entry.dart';

class ToolEntryList extends ConsumerWidget {
  final List<ToolEntry> tools;
  final ValueChanged<ToolEntry> onTap;

  const ToolEntryList({super.key, required this.tools, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final autoColumns = width > 1000
        ? 4
        : width > 720
            ? 3
            : 2;
    final crossAxisCount = settings.preferredColumns == 0
        ? autoColumns
        : settings.preferredColumns;

    final shadow = switch (settings.shadowLevel) {
      UiShadowLevel.off => <BoxShadow>[],
      UiShadowLevel.soft => [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      UiShadowLevel.strong => [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
    };

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: settings.density == UiDensity.compact ? 10 : 14,
        mainAxisSpacing: settings.density == UiDensity.compact ? 10 : 14,
        childAspectRatio: width < 420 ? 1.0 : 1.12,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return InkWell(
          borderRadius: BorderRadius.circular(settings.cardRadius),
          onTap: () => onTap(tool),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(settings.cardRadius),
              color: settings.cardStyle == UiCardStyle.flat
                  ? Theme.of(context).colorScheme.surface
                  : null,
              gradient: settings.cardStyle == UiCardStyle.soft
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withOpacity(0.35),
                      ],
                    )
                  : null,
              border: Border.all(
                color: settings.highContrast
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor.withOpacity(0.2),
              ),
              boxShadow: shadow,
            ),
              child: Padding(
              padding: EdgeInsets.all(
                settings.density == UiDensity.compact ? AppSpacing.sm : AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    ),
                    child: Icon(
                      tool.icon,
                      size: 22 * settings.iconScaleFactor,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    tool.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) *
                              settings.textScaleFactor,
                        ),
                  ),
                  if (settings.showToolDescription) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tool.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize:
                                (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) *
                                    settings.textScaleFactor,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
