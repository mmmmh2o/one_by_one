import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/core/providers/favorites_provider.dart';
import 'package:toolbox/core/providers/recents_provider.dart';
import 'package:toolbox/core/providers/settings_provider.dart';
import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/features/home/widgets/home_category_chips.dart';
import 'package:toolbox/features/home/widgets/home_tool_grid_card.dart';
import 'package:toolbox/models/tool_entry.dart';

/// 分类浏览页 — 底栏第二个 Tab
class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  ToolCategory? _selected;

  void _openTool(ToolEntry tool) {
    ref.read(recentToolsProvider.notifier).recordUse(tool.id);
    context.push('/tool/${tool.id}');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final favIds = ref.watch(favoritesProvider);
    final cs = Theme.of(context).colorScheme;

    // 按分类分组
    final grouped = <ToolCategory, List<ToolEntry>>{};
    for (final t in allTools) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    final visibleCats = _selected != null
        ? [_selected!]
        : kHomeCategories.keys.where((c) => grouped.containsKey(c)).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('分类'),
          centerTitle: true,
          floating: true,
          snap: true,
        ),
        // 分类 chips
        SliverToBoxAdapter(
          child: HomeCategoryChips(
            selected: _selected,
            onSelected: (cat) => setState(() => _selected = cat),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // 各分类下的工具网格
        for (final cat in visibleCats) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Icon(kHomeCategories[cat]?.$2 ?? Icons.apps_rounded,
                      size: 18, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    kHomeCategories[cat]?.$1 ?? '其他',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cs.primaryContainer.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      '${grouped[cat]?.length ?? 0}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildGrid(context, grouped[cat] ?? [], favIds, settings),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<ToolEntry> tools,
      Set<String> favIds, SettingsState settings) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = settings.preferredColumns > 0
        ? settings.preferredColumns
        : (width > 1000 ? 4 : width > 720 ? 3 : 2);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: width < 420 ? 1.0 : 1.15,
        ),
        itemCount: tools.length,
        itemBuilder: (_, i) => HomeToolGridCard(
          tool: tools[i],
          isFavorite: favIds.contains(tools[i].id),
          showDescription: settings.showToolDescription,
          iconScale: settings.iconScaleFactor,
          cardRadius: settings.cardRadius,
          onTap: () => _openTool(tools[i]),
          onLongPress: () => _openTool(tools[i]),
        ),
      ),
    );
  }
}
