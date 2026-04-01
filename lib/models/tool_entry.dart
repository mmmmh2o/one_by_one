import 'package:flutter/material.dart';

enum ToolCategory {
  daily,
  query,
  calculator,
  text,
  image,
  device,
  file,
  thirdParty,
  other,
}

/// 延迟加载的工具页面 Widget
///
/// 用 `DeferredWidget` 包裹需要 deferred import 的模块，
/// 首次打开时显示加载指示器，模块加载完成后自动切换为实际页面。
class DeferredWidget extends StatelessWidget {
  final Future<void> Function() loader;
  final WidgetBuilder builder;
  const DeferredWidget({
    super.key,
    required this.loader,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loader(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder(context);
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class ToolEntry {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final ToolCategory category;
  final WidgetBuilder? builder;
  /// 延迟加载器，配合 DeferredWidget 使用
  final Future<void> Function()? loadLibrary;
  final bool isPremium;
  final bool isOffline;
  final int sortOrder;

  const ToolEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.builder,
    this.loadLibrary,
    this.isPremium = false,
    this.isOffline = true,
    this.sortOrder = 0,
  });
}
