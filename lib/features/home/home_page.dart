import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/core/constants/spacing.dart';
import 'package:toolbox/core/providers/favorites_provider.dart';
import 'package:toolbox/core/providers/recents_provider.dart';
import 'package:toolbox/core/providers/settings_provider.dart';
import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/models/tool_entry.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// Local UI state
// ═══════════════════════════════════════════════════════════════════════════════

final _searchQueryProvider = StateProvider<String>((_) => '');
final _selectedCategoryProvider = StateProvider<ToolCategory?>((_) => null);
final _viewModeProvider =
    StateProvider<_ViewMode>((_) => _ViewMode.grid);

enum _ViewMode { grid, list }

// ═══════════════════════════════════════════════════════════════════════════════
// Category metadata
// ═══════════════════════════════════════════════════════════════════════════════

const _kCategories = <ToolCategory, (String label, IconData icon)>{
  ToolCategory.daily: ('日常', Icons.wb_sunny_outlined),
  ToolCategory.calculator: ('计算', Icons.calculate_outlined),
  ToolCategory.text: ('文本', Icons.text_snippet_outlined),
  ToolCategory.other: ('趣味', Icons.auto_awesome_outlined),
  ToolCategory.thirdParty: ('高级', Icons.extension_outlined),
};

String _categoryLabel(ToolCategory c) =>
    _kCategories[c]?.$1 ?? '其他';

IconData _categoryIcon(ToolCategory c) =>
    _kCategories[c]?.$2 ?? Icons.apps_rounded;

// ═══════════════════════════════════════════════════════════════════════════════
// HomePage
// ═══════════════════════════════════════════════════════════════════════════════

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // ── Navigate to tool & record recents ──────────────────────────────────────
  void _openTool(BuildContext context, WidgetRef ref, ToolEntry tool) {
    ref.read(recentToolsProvider.notifier).recordUse(tool.id);
    context.push('/tool/${tool.id}');
  }

  // ── Long-press context menu ───────────────────────────────────────────────
  void _showToolSheet(
      BuildContext context, WidgetRef ref, ToolEntry tool) {
    final favs = ref.read(favoritesProvider);
    final isFav = favs.contains(tool.id);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon + name
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
              ),
              child: Icon(tool.icon, size: 32,
                  color:
                      Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(tool.name,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(tool.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.md),

            // Actions
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
                _openTool(context, ref, tool);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    // ── Filtering ────────────────────────────────────────────────────────
    final filtered = allTools.where((t) {
      if (selectedCat != null && t.category != selectedCat) return false;
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        return t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // ── Grouping (only in grid mode + no filter) ─────────────────────────
    final grouped = <ToolCategory, List<ToolEntry>>{};
    for (final t in filtered) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    final visibleCategories = selectedCat != null
        ? [selectedCat]
        : _kCategories.keys.where((c) => grouped.containsKey(c)).toList();

    // ── Recent / favorite resolved lists ─────────────────────────────────
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

    // ── Build ────────────────────────────────────────────────────────────
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── App bar ──────────────────────────────────────────────────
          SliverAppBar.large(
            title: const Text('工具箱'),
            actions: [
              // View toggle
              IconButton(
                tooltip: viewMode == _ViewMode.grid ? '列表视图' : '网格视图',
                icon: Icon(viewMode == _ViewMode.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded),
                onPressed: () =>
                    ref.read(_viewModeProvider.notifier).state =
                        viewMode == _ViewMode.grid
                            ? _ViewMode.list
                            : _ViewMode.grid,
              ),
              // Settings
              IconButton(
                tooltip: '设置',
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => _showSettingsSheet(context),
              ),
            ],
          ),

          // ── Search ───────────────────────────────────────────────────
          _buildSearchBar(context, ref),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

          // ── Category chips ───────────────────────────────────────────
          _buildCategoryChips(context, ref, selectedCat),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

          // ── Tool count (when filtering) ──────────────────────────────
          if (selectedCat != null || query.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md + 4),
                child: Text(
                  '${filtered.length} 个工具',
                  style:
                      Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                ),
              ),
            ),

          // ── Recent tools (horizontal) ────────────────────────────────
          if (showRecents) ...[
            _sectionHeader(context, '最近使用', Icons.history_rounded),
            _horizontalToolList(context, ref, recentTools),
          ],

          // ── Favorites (horizontal) ───────────────────────────────────
          if (showFavorites) ...[
            _sectionHeader(
                context, '我的收藏', Icons.star_rounded),
            _horizontalToolList(context, ref, favoriteTools),
          ],

          // ── Grouped categories ───────────────────────────────────────
          if (isGrouped)
            for (final cat in visibleCategories) ...[
              _categorySliverHeader(context, cat,
                  grouped[cat]?.length ?? 0),
              _buildGrid(context, ref, grouped[cat] ?? [], favIds),
            ]
          else
            _buildContent(context, ref, filtered, favIds, viewMode),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Search bar
  // ═══════════════════════════════════════════════════════════════════════════

  SliverToBoxAdapter _buildSearchBar(
      BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: SearchBar(
          hintText: '搜索工具…',
          leading: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.search_rounded),
          ),
          onChanged: (v) =>
              ref.read(_searchQueryProvider.notifier).state = v,
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Category chips
  // ═══════════════════════════════════════════════════════════════════════════

  SliverToBoxAdapter _buildCategoryChips(
      BuildContext context, WidgetRef ref, ToolCategory? selectedCat) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: _kCategories.length + 1,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, i) {
            if (i == 0) {
              final sel = selectedCat == null;
              return FilterChip(
                label: const Text('全部'),
                selected: sel,
                showCheckmark: false,
                avatar: sel
                    ? Icon(Icons.check_rounded,
                        size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)
                    : null,
                onSelected: (_) => ref
                    .read(_selectedCategoryProvider.notifier)
                    .state = null,
              );
            }
            final entry = _kCategories.entries.elementAt(i - 1);
            final cat = entry.key;
            final (label, icon) = entry.value;
            final sel = selectedCat == cat;
            return FilterChip(
              label: Text(label),
              selected: sel,
              showCheckmark: false,
              avatar: Icon(icon,
                  size: 18,
                  color: sel
                      ? Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant),
              onSelected: (_) => ref
                  .read(_selectedCategoryProvider.notifier)
                  .state = sel ? null : cat,
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Horizontal tool row (recents / favorites)
  // ═══════════════════════════════════════════════════════════════════════════

  SliverToBoxAdapter _sectionHeader(
      BuildContext context, String title, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md + 4, AppSpacing.md, AppSpacing.md + 4, 0),
        child: Row(
          children: [
            Icon(icon, size: 18,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _horizontalToolList(
      BuildContext context, WidgetRef ref, List<ToolEntry> tools) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          itemCount: tools.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, i) {
            final tool = tools[i];
            return _TapScale(
              onTap: () => _openTool(context, ref, tool),
              child: Container(
                width: 108,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerLow,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.4),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tool.icon,
                        size: 24,
                        color: Theme.of(context)
                            .colorScheme
                            .primary),
                    const SizedBox(height: 6),
                    Text(
                      tool.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Category section header (grouped view)
  // ═══════════════════════════════════════════════════════════════════════════

  SliverToBoxAdapter _categorySliverHeader(
      BuildContext context, ToolCategory cat, int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md + 4, AppSpacing.lg, AppSpacing.md + 4, 0),
        child: Row(
          children: [
            Icon(_categoryIcon(cat),
                size: 18,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(_categoryLabel(cat),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
              ),
              child: Text('$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer)),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Grid / List content
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(BuildContext context, WidgetRef ref,
      List<ToolEntry> tools, Set<String> favIds, _ViewMode viewMode) {
    if (tools.isEmpty) return _emptyState(context);
    return viewMode == _ViewMode.grid
        ? _buildGrid(context, ref, tools, favIds)
        : _buildList(context, ref, tools, favIds);
  }

  // ── Grid ──────────────────────────────────────────────────────────────────

  SliverPadding _buildGrid(BuildContext context, WidgetRef ref,
      List<ToolEntry> tools, Set<String> favIds) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = width > 1000 ? 4 : width > 720 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.md),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: width < 420 ? 1.0 : 1.15,
        ),
        itemCount: tools.length,
        itemBuilder: (_, i) => _ToolGridCard(
          tool: tools[i],
          isFavorite: favIds.contains(tools[i].id),
          onTap: () => _openTool(context, ref, tools[i]),
          onLongPress: () => _showToolSheet(context, ref, tools[i]),
        ),
      ),
    );
  }

  // ── List ──────────────────────────────────────────────────────────────────

  SliverList _buildList(BuildContext context, WidgetRef ref,
      List<ToolEntry> tools, Set<String> favIds) {
    return SliverList.builder(
      itemCount: tools.length,
      itemBuilder: (_, i) => _ToolListTile(
        tool: tools[i],
        isFavorite: favIds.contains(tools[i].id),
        onTap: () => _openTool(context, ref, tools[i]),
        onLongPress: () => _showToolSheet(context, ref, tools[i]),
      ),
    );
  }

  // ── Empty ─────────────────────────────────────────────────────────────────

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

  // ═══════════════════════════════════════════════════════════════════════════
  // Settings bottom sheet
  // ═══════════════════════════════════════════════════════════════════════════

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _SettingsSheet(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Tap scale animation wrapper
// ═══════════════════════════════════════════════════════════════════════════════

class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _TapScale({required this.child, required this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 150),
    vsync: this,
  );
  late final _scale = Tween(begin: 1.0, end: 0.94)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapCancel: _controller.reverse,
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Grid card
// ═══════════════════════════════════════════════════════════════════════════════

class _ToolGridCard extends StatelessWidget {
  final ToolEntry tool;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ToolGridCard({
    required this.tool,
    required this.isFavorite,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
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
                  // Icon in tonal container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.primaryContainer,
                    ),
                    child: Icon(tool.icon, size: 24,
                        color: scheme.onPrimaryContainer),
                  ),
                  const Spacer(),
                  // Name
                  Text(tool.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  // Description
                  Text(tool.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            // Favorite star
            if (isFavorite)
              Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.star_rounded,
                    size: 16, color: scheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// List tile
// ═══════════════════════════════════════════════════════════════════════════════

class _ToolListTile extends StatelessWidget {
  final ToolEntry tool;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ToolListTile({
    required this.tool,
    required this.isFavorite,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: scheme.primaryContainer,
        ),
        child: Icon(tool.icon,
            size: 22, color: scheme.onPrimaryContainer),
      ),
      title: Text(tool.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(tool.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant)),
      trailing: isFavorite
          ? Icon(Icons.star_rounded, size: 18, color: scheme.primary)
          : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Settings sheet (unchanged functionality, MD3 styled)
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.85,
      builder: (ctx, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Text('UI 自定义',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),

          // ── Presets ────────────────────────────────────────────────────
          Text('预设方案',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                selected:
                    settings.currentPreset == UiPreset.compactEfficiency,
                onSelected: (_) =>
                    notifier.applyPreset(UiPreset.compactEfficiency),
                label: const Text('紧凑效率'),
              ),
              ChoiceChip(
                selected:
                    settings.currentPreset == UiPreset.largeTextReading,
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
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),

          // ── Theme mode ─────────────────────────────────────────────────
          DropdownButtonFormField<ThemeMode>(
            value: settings.themeMode,
            decoration: const InputDecoration(labelText: '主题模式'),
            items: const [
              DropdownMenuItem(
                  value: ThemeMode.system, child: Text('跟随系统')),
              DropdownMenuItem(
                  value: ThemeMode.light, child: Text('浅色')),
              DropdownMenuItem(
                  value: ThemeMode.dark, child: Text('深色')),
            ],
            onChanged: (mode) {
              if (mode != null) notifier.setThemeMode(mode);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Density ────────────────────────────────────────────────────
          DropdownButtonFormField<UiDensity>(
            value: settings.density,
            decoration: const InputDecoration(labelText: '界面密度'),
            items: const [
              DropdownMenuItem(
                  value: UiDensity.comfortable, child: Text('舒适')),
              DropdownMenuItem(
                  value: UiDensity.compact, child: Text('紧凑')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setDensity(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Accent color ───────────────────────────────────────────────
          DropdownButtonFormField<UiAccent>(
            value: settings.accent,
            decoration: const InputDecoration(labelText: '强调色'),
            items: const [
              DropdownMenuItem(
                  value: UiAccent.green, child: Text('森林绿')),
              DropdownMenuItem(
                  value: UiAccent.ocean, child: Text('海洋蓝')),
              DropdownMenuItem(
                  value: UiAccent.amber, child: Text('琥珀橙')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setAccent(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Monet (dynamic color) ──────────────────────────────────────
          SwitchListTile(
            value: settings.monetEnabled,
            onChanged: notifier.setMonetEnabled,
            contentPadding: EdgeInsets.zero,
            title: const Text('莫奈取色（动态壁纸取色）'),
            subtitle: const Text('Android 12+ 取壁纸色生成主题'),
            secondary: Icon(
              Icons.palette_outlined,
              color: settings.monetEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Card radius ────────────────────────────────────────────────
          Text('卡片圆角 ${settings.cardRadius.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium),
          Slider(
            min: 8,
            max: 28,
            divisions: 10,
            value: settings.cardRadius,
            onChanged: notifier.setCardRadius,
          ),

          // ── Card style ─────────────────────────────────────────────────
          DropdownButtonFormField<UiCardStyle>(
            value: settings.cardStyle,
            decoration: const InputDecoration(labelText: '卡片风格'),
            items: const [
              DropdownMenuItem(
                  value: UiCardStyle.soft, child: Text('柔和渐变')),
              DropdownMenuItem(
                  value: UiCardStyle.flat, child: Text('纯色扁平')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setCardStyle(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Column count ───────────────────────────────────────────────
          DropdownButtonFormField<int>(
            value: settings.preferredColumns,
            decoration: const InputDecoration(labelText: '网格列数'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('自动')),
              DropdownMenuItem(value: 2, child: Text('2 列')),
              DropdownMenuItem(value: 3, child: Text('3 列')),
              DropdownMenuItem(value: 4, child: Text('4 列')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setPreferredColumns(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Shadow ─────────────────────────────────────────────────────
          DropdownButtonFormField<UiShadowLevel>(
            value: settings.shadowLevel,
            decoration: const InputDecoration(labelText: '阴影强度'),
            items: const [
              DropdownMenuItem(
                  value: UiShadowLevel.off, child: Text('关闭')),
              DropdownMenuItem(
                  value: UiShadowLevel.soft, child: Text('柔和')),
              DropdownMenuItem(
                  value: UiShadowLevel.strong, child: Text('明显')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setShadowLevel(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Toggles ────────────────────────────────────────────────────
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
          SwitchListTile(
            value: settings.highContrast,
            onChanged: notifier.setHighContrast,
            contentPadding: EdgeInsets.zero,
            title: const Text('高对比模式'),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Text / icon scale ──────────────────────────────────────────
          Text('文字缩放 ${settings.textScaleFactor.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium),
          Slider(
            min: 0.9,
            max: 1.2,
            divisions: 6,
            value: settings.textScaleFactor,
            onChanged: notifier.setTextScaleFactor,
          ),
          Text('图标缩放 ${settings.iconScaleFactor.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium),
          Slider(
            min: 0.85,
            max: 1.3,
            divisions: 9,
            value: settings.iconScaleFactor,
            onChanged: notifier.setIconScaleFactor,
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Reset ──────────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: notifier.resetAppearance,
              icon: const Icon(Icons.restore_rounded),
              label: const Text('恢复默认'),
            ),
          ),
        ],
      ),
    );
  }
}
