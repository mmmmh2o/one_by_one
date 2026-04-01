import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/features/home/home_page.dart';
import 'package:toolbox/features/explore/explore_page.dart';
import 'package:toolbox/features/settings/settings_page.dart';
import 'package:toolbox/features/common/tool_shell_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          // 0: 首页
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          // 1: 分类
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePage(),
            ),
          ]),
          // 2: 设置
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ]),
        ],
      ),
      // 工具详情页 — 覆盖在底栏之上
      GoRoute(
        path: '/tool/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final tool = id == null ? null : getToolById(id);
          if (tool == null) {
            return const ToolShellPage(toolName: '未知工具');
          }
          return tool.builder?.call(context) ??
              const ToolShellPage(toolName: '未实现');
        },
      ),
    ],
  );
}

/// 底栏 Shell — 三 Tab 布局
class _AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _AppShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: '分类',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
