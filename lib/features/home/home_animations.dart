import 'package:flutter/material.dart';

/// 首页入场动画 — 分段缩放+淡入，每个区块依次进入
class HomeAnimations {
  final AnimationController controller;
  final int total;
  late final List<Animation<double>> scales;
  late final List<Animation<double>> fades;

  HomeAnimations({required TickerProvider vsync, this.total = 10})
      : controller = AnimationController(
          duration: const Duration(milliseconds: 900),
          vsync: vsync,
        ) {
    scales = List.generate(total, (i) {
      final start = (i / total).clamp(0.0, 0.8);
      final end = ((i + 2) / total).clamp(0.1, 1.0);
      return Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    fades = List.generate(total, (i) {
      final start = (i / total).clamp(0.0, 0.8);
      final end = ((i + 2) / total).clamp(0.1, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
  }

  Animation<double> scale(int index) =>
      scales[index.clamp(0, total - 1)];
  Animation<double> fade(int index) =>
      fades[index.clamp(0, total - 1)];

  void dispose() => controller.dispose();
}
