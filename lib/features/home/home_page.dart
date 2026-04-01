import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/core/providers/favorites_provider.dart';
import 'package:toolbox/core/providers/recents_provider.dart';
import 'package:toolbox/core/providers/settings_provider.dart';
import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/features/home/home_animations.dart';
import 'package:toolbox/features/home/widgets/home_category_chips.dart';
import 'package:toolbox/features/home/widgets/home_horizontal_tool_row.dart';
import 'package:toolbox/features/home/widgets/home_search_bar.dart';
import 'package:toolbox/features/home/widgets/home_tool_grid_card.dart';
import 'package:toolbox/features/home/widgets/home_tool_list_tile.dart';
import 'package:toolbox/models/tool_entry.dart';

// ── Local UI state ─────────────────────────────────────────────────────────

final _searchQueryProvider = StateProvider<String>((_) => '');
final _selectedCategoryProvider = StateProvider<ToolCategory?>((_) => null);
final _viewModeProvider = StateProvider<_ViewMode>((_) => _ViewMode.grid);

enum _ViewMode { grid, list }

// ═══════════════════════════════════════════════════════════════════════════
// HomePage
// ═══════════════════════════════════════════════════════════════════════════

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeAnimations _anim;
  bool _animReady = false;

  @override
  void initState() {
    super.initState();
    _anim = HomeAnimations(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final enableAnim = ref.read(settingsProvider).enableAnimations;
      if (enableAnim) {
        _anim.controller.forward();
      } else {
        _anim.controller.value = 1.0;
      }
      setState(() => _animReady = true);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _openTool(ToolEntry tool) {
    ref.read(recentToolsProvider.notifier).recordUse(tool.id);
    context.push('/tool/${tool.id}');
  }

  void _showToolSheet(ToolEntry tool) {
    final favs = ref.read(favoritesProvider);
    final isFav = favs.contains(tool.id);
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: cs.primaryContainer.withValues(alpha: 0.5),
              ),
              child: Icon(tool.icon, size: 32, color: cs.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(tool.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(tool.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: Icon(isFav
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded),
              title: Text(isFav ? '取消收藏' : '收藏'),
              onTap: () {
                ref.read(favoritesProvider.notifier).toggle(tool.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: const Text('打开工具'),
              onTap: () {
                Navigator.pop(context);
                _openTool(tool);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 包裹缩放+淡入动画（不依赖 ref，安全用于 sliver 中）
  Widget _animated(int index, Widget child, bool enableAnimations) {
    if (!enableAnimations || !_animReady) return child;
    return AnimatedBuilder(
      animation: _anim.controller,
      builder: (context, _) => Transform.scale(
        scale: _anim.scale(index).value,
        child: Opacity(
          opacity: _anim.fade(index).value,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (allTools.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('工具正在建设中…')),
      );
    }

    final query = ref.watch(_searchQueryProvider);
    final selectedCat = ref.watch(_selectedCategoryProvider);
    final viewMode = ref.watch(_viewModeProvider);
    final favIds = ref.watch(favoritesProvider);
    final recentIds = ref.watch(recentToolsProvider);
    final settings = ref.watch(settingsProvider);
    final enableAnim = settings.enableAnimations;

    // ── Filtering ──────────────────────────────────────────────────
    final filtered = allTools.where((t) {
      if (selectedCat != null && t.category != selectedCat) return false;
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        return t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // ── Grouping ───────────────────────────────────────────────────
    final grouped = <ToolCategory, List<ToolEntry>>{};
    for (final t in filtered) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    final visibleCategories = selectedCat != null
        ? [selectedCat]
        : kHomeCategories.keys
            .where((c) => grouped.containsKey(c))
            .toList();

    // ── Recent / favorites ─────────────────────────────────────────
    final recentTools = recentIds
        .map((id) => toolIndex[id])
        .whereType<ToolEntry>()
        .toList();
    final favoriteTools = favIds
        .map((id) => toolIndex[id])
        .whereType<ToolEntry>()
        .toList();

    final isGrouped =
        viewMode == _ViewMode.grid && selectedCat == null && query.isEmpty;
    final showRecents = recentTools.isNotEmpty && query.isEmpty;
    final showFavorites = favoriteTools.isNotEmpty && query.isEmpty;

    int animIdx = 0;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (enableAnim) {
            _anim.controller.reset();
            _anim.controller.forward();
          }
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // ── App bar ────────────────────────────────────────────
            SliverAppBar(
              title: const Text('工具箱'),
              centerTitle: true,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  tooltip:
                      viewMode == _ViewMode.grid ? '列表视图' : '网格视图',
                  icon: Icon(viewMode == _ViewMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded),
                  onPressed: () =>
                      ref.read(_viewModeProvider.notifier).state =
                          viewMode == _ViewMode.grid
                              ? _ViewMode.list
                              : _ViewMode.grid,
                ),
              ],
            ),

            // ── Search ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _animated(
                animIdx++,
                HomeSearchBar(
                  onChanged: (v) =>
                      ref.read(_searchQueryProvider.notifier).state = v,
                ),
                enableAnim,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // ── Category chips ─────────────────────────────────────
            SliverToBoxAdapter(
              child: _animated(
                animIdx++,
                HomeCategoryChips(
                  selected: selectedCat,
                  onSelected: (cat) => ref
                      .read(_selectedCategoryProvider.notifier)
                      .state = cat,
                ),
                enableAnim,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),

            // ── Tool count (when filtering) ────────────────────────
            if (selectedCat != null || query.isNotEmpty)
              SliverToBoxAdapter(
                child: _animated(
                  animIdx++,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 4),
                    child: Text(
                      '${filtered.length} 个工具',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ),
                  enableAnim,
                ),
              ),

            // ── Recent tools (horizontal) ──────────────────────────
            if (showRecents) ...[
              SliverToBoxAdapter(
                child: _animated(
                  animIdx++,
                  _SectionHeader(
                      title: '最近使用', icon: Icons.history_rounded),
                  enableAnim,
                ),
              ),
              SliverToBoxAdapter(
                child: _animated(
                  animIdx++,
                  HomeHorizontalToolRow(
                    tools: recentTools,
                    iconScale: settings.iconScaleFactor,
                    onTap: _openTool,
                  ),
                  enableAnim,
                ),
              ),
            ],

            // ── Favorites (horizontal) ─────────────────────────────
            if (showFavorites) ...[
              SliverToBoxAdapter(
                child: _animated(
                  animIdx++,
                  const _SectionHeader(
                      title: '我的收藏', icon: Icons.star_rounded),
                  enableAnim,
                ),
              ),
              SliverToBoxAdapter(
                child: _animated(
                  animIdx++,
                  HomeHorizontalToolRow(
                    tools: favoriteTools,
                    iconScale: settings.iconScaleFactor,
                    onTap: _openTool,
                  ),
                  enableAnim,
                ),
              ),
            ],

            // ── Grouped categories ─────────────────────────────────
            if (isGrouped)
              for (final cat in visibleCategories) ...[
                SliverToBoxAdapter(
                  child: _animated(
                    animIdx++,
                    _CategoryHeader(
                        cat: cat, count: grouped[cat]?.length ?? 0),
                    enableAnim,
                  ),
                ),
                _buildGrid(context, grouped[cat] ?? [], favIds, settings),
              ]
            else
              _buildContent(
                  context, filtered, favIds, viewMode, settings),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ── Content switcher ────────────────────────────────────────────────
  Widget _buildContent(
    BuildContext context,
    List<ToolEntry> tools,
    Set<String> favIds,
    _ViewMode viewMode,
    SettingsState settings,
  ) {
    if (tools.isEmpty) return _emptyState(context);
    return viewMode == _ViewMode.grid
        ? _buildGrid(context, tools, favIds, settings)
        : _buildList(context, tools, favIds);
  }

  // ── Grid ────────────────────────────────────────────────────────────
  SliverPadding _buildGrid(BuildContext context, List<ToolEntry> tools,
      Set<String> favIds, SettingsState settings) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = settings.preferredColumns > 0
        ? settings.preferredColumns
        : (width > 1000 ? 4 : width > 720 ? 3 : 2);
    final maxExtent = width / cols;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxExtent,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => HomeToolGridCard(
            tool: tools[i],
            isFavorite: favIds.contains(tools[i].id),
            showDescription: settings.showToolDescription,
            iconScale: settings.iconScaleFactor,
            cardRadius: settings.cardRadius,
            onTap: () => _openTool(tools[i]),
            onLongPress: () => _showToolSheet(tools[i]),
          ),
          childCount: tools.length,
        ),
      ),
    );
  }

  // ── List ────────────────────────────────────────────────────────────
  SliverList _buildList(BuildContext context, List<ToolEntry> tools,
      Set<String> favIds) {
    return SliverList.builder(
      itemCount: tools.length,
      itemBuilder: (_, i) => HomeToolListTile(
        tool: tools[i],
        isFavorite: favIds.contains(tools[i].id),
        onTap: () => _openTool(tools[i]),
        onLongPress: () => _showToolSheet(tools[i]),
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────
  SliverFillRemaining _emptyState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56,
                color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: AppSpacing.sm),
            Text('没有找到匹配的工具',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Extracted header widgets (Stateless, no ref dependency)
// ═══════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

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

class _CategoryHeader extends StatelessWidget {
  final ToolCategory cat;
  final int count;
  const _CategoryHeader({required this.cat, required this.count});

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
