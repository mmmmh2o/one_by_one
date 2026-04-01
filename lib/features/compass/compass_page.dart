import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class CompassPage extends ConsumerWidget {
  const CompassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compassProvider);
    final ui = ref.watch(settingsProvider);
    final scheme = Theme.of(context).colorScheme;

    return ToolScaffold(
      toolId: 'compass',
      children: [
        const SizedBox(height: AppSpacing.xl),
        // 指南针仪表盘
        Center(
          child: AppCard(
            child: SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(
                painter: _CompassPainter(
                  heading: state.heading,
                  primaryColor: scheme.primary,
                  surfaceColor: scheme.surface,
                  outlineColor: scheme.outlineVariant,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 方位与角度
        Center(
          child: Column(
            children: [
              Text(
                state.direction,
                style: scaledTextStyle(
                  Theme.of(context).textTheme.headlineMedium,
                  ui.textScaleFactor,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${state.heading.toStringAsFixed(1)}°',
                style: scaledTextStyle(
                  Theme.of(context).textTheme.bodyLarge,
                  ui.textScaleFactor,
                ),
              ),
            ],
          ),
        ),

        // 校准提示
        if (state.needsCalibration)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: AppCard(
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: scheme.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '磁场信号较弱，请远离金属物体或在室外使用',
                      style: scaledTextStyle(
                        Theme.of(context).textTheme.bodyMedium,
                        ui.textScaleFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 指南针自定义画笔
class _CompassPainter extends CustomPainter {
  final double heading;
  final Color primaryColor;
  final Color surfaceColor;
  final Color outlineColor;

  _CompassPainter({
    required this.heading,
    required this.primaryColor,
    required this.surfaceColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;

    // 外圈
    final circlePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, circlePaint);

    // 刻度
    final tickPaint = Paint()..strokeWidth = 1.5;
    for (var i = 0; i < 360; i += 5) {
      final rad = (i - 90) * pi / 180;
      final isMajor = i % 30 == 0;
      final innerR = radius - (isMajor ? 16 : 8);
      tickPaint.color = isMajor ? primaryColor : outlineColor;
      canvas.drawLine(
        Offset(center.dx + innerR * cos(rad), center.dy + innerR * sin(rad)),
        Offset(
            center.dx + (radius - 2) * cos(rad),
            center.dy + (radius - 2) * sin(rad)),
        tickPaint,
      );
    }

    // 方位标注
    const labels = {'N': 0, 'E': 90, 'S': 180, 'W': 270};
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    labels.forEach((label, angle) {
      final rad = (angle - 90) * pi / 180;
      final labelR = radius - 28;
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: label == 'N' ? Colors.red : primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx + labelR * cos(rad) - textPainter.width / 2,
          center.dy + labelR * sin(rad) - textPainter.height / 2,
        ),
      );
    });

    // 指针（旋转画布）
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-heading * pi / 180);

    final northPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final southPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.fill;

    // 北针
    final northPath = Path()
      ..moveTo(0, -radius + 40)
      ..lineTo(-8, 0)
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(northPath, northPaint);

    // 南针
    final southPath = Path()
      ..moveTo(0, radius - 40)
      ..lineTo(-8, 0)
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(southPath, southPaint);

    // 中心点
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 6, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) =>
      old.heading != heading;
}
