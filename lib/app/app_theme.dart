import 'package:flutter/material.dart';

import 'package:toolbox/core/constants/colors.dart';
import 'package:toolbox/core/constants/typography.dart';
import 'package:toolbox/core/providers/settings_provider.dart';

abstract class AppTheme {
  static ThemeData light(SettingsState settings) {
    final seed = _accentColor(settings.accent);
    final compact = settings.density == UiDensity.compact;
    final contrast = settings.highContrast;
    final outline = contrast ? AppColors.greenDark : AppColors.border;
    return ThemeData(
      useMaterial3: true,
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(settings.cardRadius),
          side: BorderSide(color: outline, width: contrast ? 1.5 : 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 14,
          vertical: compact ? 10 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
          borderSide: BorderSide(color: outline, width: contrast ? 1.5 : 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
          borderSide: BorderSide(color: outline, width: contrast ? 1.5 : 1),
        ),
      ),
      textTheme: AppTypography.textTheme,
    );
  }

  static ThemeData dark(SettingsState settings) {
    final seed = _accentColor(settings.accent);
    final compact = settings.density == UiDensity.compact;
    return ThemeData(
      useMaterial3: true,
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF101511),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(settings.cardRadius),
        ),
      ),
      textTheme: AppTypography.textTheme,
    );
  }

  static Color _accentColor(UiAccent accent) {
    switch (accent) {
      case UiAccent.ocean:
        return AppColors.sky;
      case UiAccent.amber:
        return AppColors.amber;
      case UiAccent.green:
      default:
        return AppColors.green;
    }
  }
}
