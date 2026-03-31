import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:toolbox/core/registry/tool_registry.dart';
import 'package:toolbox/features/home/home_page.dart';
import 'package:toolbox/features/common/tool_shell_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/tool/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final tool = id == null ? null : getToolById(id);
          if (tool == null) {
            return const ToolShellPage(toolName: '未知工具');
          }
          return tool.builder?.call(context) ?? const ToolShellPage(toolName: '未实现');
        },
      ),
    ],
  );
}
