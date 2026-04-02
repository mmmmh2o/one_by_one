import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ui_text_scale.dart';
import '../../core/widgets/app_card.dart';
import '../common/tool_scaffold.dart';
import 'providers.dart';

class ProtractorPage extends ConsumerWidget {
  const ProtractorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(protractorProvider);
    final ui = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ToolScaffold(
      toolId: 'protractor',
      children: [
        const SizedBox(height: AppSpacing.lg),

        // 量角器盘面
        Center(
          child: AppCard(
            child: SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: _ProtractorPainter(
                  angle: state.angle,
                  primaryColor: cs.primary,
                  surfaceColor: cs.surfaceContainerHighest,
                  onSurface: cs.onSurface,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // 角度数值
        Center(
          child: Column(
            children: [
              Text(
                '${state.angle.toStringAsFixed(1)}°',
                style: scaledTextStyle(
                  textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: cs.primary,
                  ),
                  ui.textScaleFactor,
                ),
              ),
              if (state.specialName != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  state.specialName!,
                  style: scaledTextStyle(
                    textTheme.titleMedium?.copyWith(color: cs.secondary),
                    ui.textScaleFactor,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // 传感器数据
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DataChip(label: 'X', value: state.rawX.toStringAsFixed(2), color: cs.primary),
              _DataChip(label: 'Y', value: state.rawY.toStringAsFixed(2), color: cs.secondary),
              _DataChip(label: '角度', value: '${state.angle.toStringAsFixed(1)}°', color: cs.tertiary),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // 使用提示
        AppCard(
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: cs.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '将手机竖直放置，倾斜手机查看角度变化。',
                  style: scaledTextStyle(textTheme.bodySmall, ui.textScaleFactor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DataChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DataChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: color)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _ProtractorPainter extends CustomPainter {
  final double angle;
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurface;

  _ProtractorPainter({
    required this.angle,
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurface,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    // 半圆弧背景
    final bgPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // 从左边开始
      pi, // 半圆
      false,
      bgPaint,
    );

    // 刻度线
    final tickPaint = Paint()
      ..color = surfaceColor
      ..strokeWidth = 1;
    final majorTickPaint = Paint()
      ..color = onSurface.withOpacity(0.5)
      ..strokeWidth = 1.5;

    for (int i = 0; i <= 180; i += 5) {
      final rad = pi + (i * pi / 180);
      final isMajor = i % 30 == 0;
      final innerR = radius - (isMajor ? 16 : 8);
      final outerR = radius;
      final p1 = Offset(center.dx + innerR * cos(rad), center.dy + innerR * sin(rad));
      final p2 = Offset(center.dx + outerR * cos(rad), center.dy + outerR * sin(rad));
      canvas.drawLine(p1, p2, isMajor ? majorTickPaint : tickPaint);

      // 度数标签
      if (isMajor) {
        final labelR = radius - 26;
        final lp = Offset(center.dx + labelR * cos(rad), center.dy + labelR * sin(rad));
        final tp = TextPainter(
          text: TextSpan(
            text: '$i°',
            style: TextStyle(color: onSurface.withOpacity(0.6), fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
      }
    }

    // 指针
    final pointerRad = pi + (angle * pi / 180);
    final pointerPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final pointerEnd = Offset(
      center.dx + radius * cos(pointerRad),
      center.dy + radius * sin(pointerRad),
    );
    canvas.drawLine(center, pointerEnd, pointerPaint);

    // 中心点
    final centerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerPaint);

    // 指针尖端圆点
    final tipPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pointerEnd, 5, tipPaint);

    // 扫过区域弧
    if (angle > 0.5) {
      final sweepPaint = Paint()
        ..color = primaryColor.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi,
        angle * pi / 180,
        true,
        sweepPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProtractorPainter old) => old.angle != angle;
}
