import 'package:flutter/material.dart';

/// 首页搜索栏 — 无状态纯展示，onChanged 回调驱动
class HomeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HomeSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SearchBar(
        hintText: '搜索工具…',
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.search_rounded),
        ),
        onChanged: onChanged,
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: cs.outlineVariant),
        ),
        backgroundColor: WidgetStatePropertyAll(
          cs.surfaceContainerHighest.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
