import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/registry/tool_registry.dart';
import '../../models/tool_entry.dart';

/// 统一工具页外壳 — 替代各工具重复的 Scaffold + AppBar + Padding
///
/// 用法：
/// ```dart
/// return ToolScaffold(
///   toolId: 'calculator',
///   children: [ AppCard(...), AppButton(...), ... ],
/// );
/// ```
class ToolScaffold extends ConsumerWidget {
  /// 工具 ID，自动从 registry 获取名称
  final String toolId;

  /// 主体内容列表，自动放入 Column
  final List<Widget> children;

  /// 是否允许滚动（内容较多时设为 true）
  final bool scrollable;

  /// AppBar 额外操作按钮
  final List<Widget>? appBarActions;

  /// body 是否使用 Expanded 包裹（用于 Expanded + ListView 场景）
  final bool expandBody;

  const ToolScaffold({
    super.key,
    required this.toolId,
    required this.children,
    this.scrollable = false,
    this.appBarActions,
    this.expandBody = false,
  });

  ToolEntry? _lookupTool() => getToolById(toolId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tool = _lookupTool();
    final title = tool?.name ?? toolId;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    Widget body;
    if (scrollable) {
      body = SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: content,
      );
    } else if (expandBody) {
      // 需要 Expanded 子组件时，外层用 Column 包裹并用 Expanded 扩展中间区域
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: content,
            ),
          ),
        ],
      );
    } else {
      body = Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions,
      ),
      body: body,
    );
  }
}
