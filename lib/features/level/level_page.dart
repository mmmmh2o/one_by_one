import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class LevelPage extends ConsumerWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(levelProvider);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'level',
      children: [
        const SizedBox(height: AppSpacing.xl),

        // 水平仪圆盘
        Center(
          child: AppCard(
            child: SizedBox(
              width: 240,
              height: 240,
              child: CustomPaint(
                painter: _LevelPainter(
                  offsetX: state.offsetX,
                  isLevel: state.isLevel,
                  primaryColor: scheme.primary,
                  surfaceColor: scheme.surfaceContainerHighest,
                  levelColor: Colors.green,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 角度显示
        Center(
          child: Column(
            children: [
              Text(
                state.isLevel ? '✓ 水平' : '偏斜',
                style: scaledTextStyle(
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: state.isLevel ? Colors.green : scheme.error,
                      ),
                  ui.textScaleFactor,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${state.tiltAngle.toStringAsFixed(1)}°',
                style: scaledTextStyle(
                  Theme.of(context).textTheme.bodyLarge,
                  ui.textScaleFactor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 使用提示
        AppCard(
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '将手机平放在桌面上，泡泡居中即为水平。',
                  style: scaledTextStyle(
                    Theme.of(context).textTheme.bodySmall,
                    ui.textScaleFactor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelPainter extends CustomPainter {
  final double offsetX;
  final bool isLevel;
  final Color primaryColor;
  final Color surfaceColor;
  final Color levelColor;

  _LevelPainter({
    required this.offsetX,
    required this.isLevel,
    required this.primaryColor,
    required this.surfaceColor,
    required this.levelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;

    // 外圈
    final circlePaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, circlePaint);

    // 十字线
    final crossPaint = Paint()
      ..color = surfaceColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      crossPaint,
    );

    // 中心圆
    canvas.drawCircle(center, 8, circlePaint);

    // 泡泡位置
    final bubbleX = center.dx + offsetX * (radius - 20);
    final bubbleColor = isLevel ? levelColor : primaryColor;

    // 泡泡阴影
    final shadowPaint = Paint()
      ..color = bubbleColor.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(bubbleX, center.dy), 16, shadowPaint);

    // 泡泡
    final bubblePaint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(bubbleX, center.dy), 14, bubblePaint);

    // 泡泡高光
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(bubbleX - 4, center.dy - 4), 4, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _LevelPainter old) =>
      old.offsetX != offsetX || old.isLevel != isLevel;
}
