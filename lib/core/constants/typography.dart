import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// 字体样式构建器。
///
/// 启动时已禁止 `GoogleFonts.config.allowRuntimeFetching = false`，
/// 此处调用 `GoogleFonts.plusJakartaSans()` 时会优先使用本地缓存，
/// 未缓存时自动回退到系统默认字体，不会阻塞启动。
abstract class AppTypography {
  /// Plus Jakarta Sans 字体族名（用于精确匹配或 asset 注册时）
  static const String fontName = 'Plus Jakarta Sans';

  /// 生成 TextStyle，自动回退到系统 sans-serif
  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.onSurface,
    );
  }

  static TextTheme get textTheme => TextTheme(
        // ── Display / Headline ──────────────────────────────────────────
        displayLarge: _style(fontSize: 32, fontWeight: FontWeight.w700),
        headlineLarge: _style(fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: _style(fontSize: 24, fontWeight: FontWeight.w600),
        headlineSmall: _style(fontSize: 20, fontWeight: FontWeight.w600),

        // ── Title ───────────────────────────────────────────────────────
        titleLarge: _style(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: _style(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: _style(fontSize: 14, fontWeight: FontWeight.w600),

        // ── Body ────────────────────────────────────────────────────────
        bodyLarge: _style(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: _style(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: _style(fontSize: 12, fontWeight: FontWeight.w400),

        // ── Label ───────────────────────────────────────────────────────
        labelLarge: _style(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: _style(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: _style(fontSize: 11, fontWeight: FontWeight.w500),
      );
}
