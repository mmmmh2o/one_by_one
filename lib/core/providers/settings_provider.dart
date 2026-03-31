import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UiDensity { comfortable, compact }

enum UiAccent { green, ocean, amber }

enum UiCardStyle { soft, flat }

enum UiShadowLevel { off, soft, strong }

enum UiPreset {
  custom,
  compactEfficiency,
  largeTextReading,
  minimalCards,
  accessibilityHighContrast,
}

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final UiDensity density;
  final UiAccent accent;
  final double cardRadius;
  final bool enableAnimations;
  final double textScaleFactor;
  final bool showToolDescription;
  final UiCardStyle cardStyle;
  final double iconScaleFactor;
  final int preferredColumns;
  final UiPreset currentPreset;
  final UiShadowLevel shadowLevel;
  final bool highContrast;
  final bool monetEnabled;

  const SettingsState({
    required this.locale,
    required this.themeMode,
    required this.density,
    required this.accent,
    required this.cardRadius,
    required this.enableAnimations,
    required this.textScaleFactor,
    required this.showToolDescription,
    required this.cardStyle,
    required this.iconScaleFactor,
    required this.preferredColumns,
    required this.currentPreset,
    required this.shadowLevel,
    required this.highContrast,
    required this.monetEnabled,
  });

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    UiDensity? density,
    UiAccent? accent,
    double? cardRadius,
    bool? enableAnimations,
    double? textScaleFactor,
    bool? showToolDescription,
    UiCardStyle? cardStyle,
    double? iconScaleFactor,
    int? preferredColumns,
    UiPreset? currentPreset,
    UiShadowLevel? shadowLevel,
    bool? highContrast,
    bool? monetEnabled,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      density: density ?? this.density,
      accent: accent ?? this.accent,
      cardRadius: cardRadius ?? this.cardRadius,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      showToolDescription: showToolDescription ?? this.showToolDescription,
      cardStyle: cardStyle ?? this.cardStyle,
      iconScaleFactor: iconScaleFactor ?? this.iconScaleFactor,
      preferredColumns: preferredColumns ?? this.preferredColumns,
      currentPreset: currentPreset ?? this.currentPreset,
      shadowLevel: shadowLevel ?? this.shadowLevel,
      highContrast: highContrast ?? this.highContrast,
      monetEnabled: monetEnabled ?? this.monetEnabled,
    );
  }
}

const _defaultSettings = SettingsState(
  locale: Locale('zh'),
  themeMode: ThemeMode.system,
  density: UiDensity.comfortable,
  accent: UiAccent.green,
  cardRadius: 14,
  enableAnimations: true,
  textScaleFactor: 1.0,
  showToolDescription: true,
  cardStyle: UiCardStyle.soft,
  iconScaleFactor: 1.0,
  preferredColumns: 0,
  currentPreset: UiPreset.custom,
  shadowLevel: UiShadowLevel.soft,
  highContrast: false,
  monetEnabled: false,
);

abstract class _SettingsKeys {
  static const themeMode = 'ui.theme_mode';
  static const density = 'ui.density';
  static const accent = 'ui.accent';
  static const cardRadius = 'ui.card_radius';
  static const enableAnimations = 'ui.enable_animations';
  static const textScaleFactor = 'ui.text_scale';
  static const showToolDescription = 'ui.show_description';
  static const cardStyle = 'ui.card_style';
  static const iconScaleFactor = 'ui.icon_scale';
  static const preferredColumns = 'ui.preferred_columns';
  static const currentPreset = 'ui.current_preset';
  static const shadowLevel = 'ui.shadow_level';
  static const highContrast = 'ui.high_contrast';
  static const monetEnabled = 'ui.monet_enabled';
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final _hydrationCompleter = Completer<void>();

  SettingsNotifier() : super(_defaultSettings) {
    unawaited(_hydrate());
  }

  /// 等待本地配置加载完成（启动时用）
  Future<void> waitForHydration() => _hydrationCompleter.future;

  ThemeMode _themeModeFrom(int index) => ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
  UiDensity _densityFrom(int index) => UiDensity.values[index.clamp(0, UiDensity.values.length - 1)];
  UiAccent _accentFrom(int index) => UiAccent.values[index.clamp(0, UiAccent.values.length - 1)];
  UiCardStyle _cardStyleFrom(int index) => UiCardStyle.values[index.clamp(0, UiCardStyle.values.length - 1)];
  UiPreset _presetFrom(int index) => UiPreset.values[index.clamp(0, UiPreset.values.length - 1)];
  UiShadowLevel _shadowFrom(int index) =>
      UiShadowLevel.values[index.clamp(0, UiShadowLevel.values.length - 1)];

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final hydrated = state.copyWith(
      themeMode: _themeModeFrom(prefs.getInt(_SettingsKeys.themeMode) ?? state.themeMode.index),
      density: _densityFrom(prefs.getInt(_SettingsKeys.density) ?? state.density.index),
      accent: _accentFrom(prefs.getInt(_SettingsKeys.accent) ?? state.accent.index),
      cardRadius: prefs.getDouble(_SettingsKeys.cardRadius) ?? state.cardRadius,
      enableAnimations: prefs.getBool(_SettingsKeys.enableAnimations) ?? state.enableAnimations,
      textScaleFactor: prefs.getDouble(_SettingsKeys.textScaleFactor) ?? state.textScaleFactor,
      showToolDescription: prefs.getBool(_SettingsKeys.showToolDescription) ?? state.showToolDescription,
      cardStyle: _cardStyleFrom(prefs.getInt(_SettingsKeys.cardStyle) ?? state.cardStyle.index),
      iconScaleFactor: prefs.getDouble(_SettingsKeys.iconScaleFactor) ?? state.iconScaleFactor,
      preferredColumns: prefs.getInt(_SettingsKeys.preferredColumns) ?? state.preferredColumns,
      currentPreset: _presetFrom(prefs.getInt(_SettingsKeys.currentPreset) ?? state.currentPreset.index),
      shadowLevel: _shadowFrom(prefs.getInt(_SettingsKeys.shadowLevel) ?? state.shadowLevel.index),
      highContrast: prefs.getBool(_SettingsKeys.highContrast) ?? state.highContrast,
      monetEnabled: prefs.getBool(_SettingsKeys.monetEnabled) ?? state.monetEnabled,
    );
    state = hydrated;
    if (!_hydrationCompleter.isCompleted) {
      _hydrationCompleter.complete();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_SettingsKeys.themeMode, state.themeMode.index);
    await prefs.setInt(_SettingsKeys.density, state.density.index);
    await prefs.setInt(_SettingsKeys.accent, state.accent.index);
    await prefs.setDouble(_SettingsKeys.cardRadius, state.cardRadius);
    await prefs.setBool(_SettingsKeys.enableAnimations, state.enableAnimations);
    await prefs.setDouble(_SettingsKeys.textScaleFactor, state.textScaleFactor);
    await prefs.setBool(_SettingsKeys.showToolDescription, state.showToolDescription);
    await prefs.setInt(_SettingsKeys.cardStyle, state.cardStyle.index);
    await prefs.setDouble(_SettingsKeys.iconScaleFactor, state.iconScaleFactor);
    await prefs.setInt(_SettingsKeys.preferredColumns, state.preferredColumns);
    await prefs.setInt(_SettingsKeys.currentPreset, state.currentPreset.index);
    await prefs.setInt(_SettingsKeys.shadowLevel, state.shadowLevel.index);
    await prefs.setBool(_SettingsKeys.highContrast, state.highContrast);
    await prefs.setBool(_SettingsKeys.monetEnabled, state.monetEnabled);
  }

  void _setState(SettingsState next, {bool markCustom = true}) {
    state = markCustom ? next.copyWith(currentPreset: UiPreset.custom) : next;
    unawaited(_persist());
  }

  void setLocale(Locale locale) {
    _setState(state.copyWith(locale: locale), markCustom: false);
  }

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _setState(state.copyWith(themeMode: next));
  }

  void setThemeMode(ThemeMode mode) {
    _setState(state.copyWith(themeMode: mode));
  }

  void setDensity(UiDensity density) {
    _setState(state.copyWith(density: density));
  }

  void setAccent(UiAccent accent) {
    _setState(state.copyWith(accent: accent));
  }

  void setCardRadius(double radius) {
    _setState(state.copyWith(cardRadius: radius.clamp(8, 24)));
  }

  void setAnimations(bool enabled) {
    _setState(state.copyWith(enableAnimations: enabled));
  }

  void setTextScaleFactor(double value) {
    _setState(state.copyWith(textScaleFactor: value.clamp(0.9, 1.2)));
  }

  void setShowToolDescription(bool show) {
    _setState(state.copyWith(showToolDescription: show));
  }

  void setCardStyle(UiCardStyle style) {
    _setState(state.copyWith(cardStyle: style));
  }

  void resetAppearance() {
    _setState(_defaultSettings, markCustom: false);
  }

  void setIconScaleFactor(double value) {
    _setState(state.copyWith(iconScaleFactor: value.clamp(0.85, 1.3)));
  }

  void setPreferredColumns(int value) {
    final safe = value.clamp(0, 4);
    _setState(state.copyWith(preferredColumns: safe));
  }

  void setShadowLevel(UiShadowLevel level) {
    _setState(state.copyWith(shadowLevel: level));
  }

  void setHighContrast(bool enabled) {
    _setState(state.copyWith(highContrast: enabled));
  }

  void setMonetEnabled(bool enabled) {
    _setState(state.copyWith(monetEnabled: enabled));
  }

  void applyPreset(UiPreset preset) {
    switch (preset) {
      case UiPreset.compactEfficiency:
        _setState(state.copyWith(
          density: UiDensity.compact,
          textScaleFactor: 0.95,
          iconScaleFactor: 0.9,
          showToolDescription: false,
          cardStyle: UiCardStyle.flat,
          cardRadius: 10,
          preferredColumns: 4,
          enableAnimations: false,
          currentPreset: UiPreset.compactEfficiency,
        ), markCustom: false);
        break;
      case UiPreset.largeTextReading:
        _setState(state.copyWith(
          density: UiDensity.comfortable,
          textScaleFactor: 1.2,
          iconScaleFactor: 1.15,
          showToolDescription: true,
          cardStyle: UiCardStyle.soft,
          cardRadius: 18,
          preferredColumns: 2,
          enableAnimations: true,
          currentPreset: UiPreset.largeTextReading,
        ), markCustom: false);
        break;
      case UiPreset.minimalCards:
        _setState(state.copyWith(
          density: UiDensity.compact,
          textScaleFactor: 1.0,
          iconScaleFactor: 1.0,
          showToolDescription: false,
          cardStyle: UiCardStyle.flat,
          cardRadius: 8,
          preferredColumns: 3,
          enableAnimations: false,
          currentPreset: UiPreset.minimalCards,
          shadowLevel: UiShadowLevel.off,
          highContrast: false,
        ), markCustom: false);
        break;
      case UiPreset.accessibilityHighContrast:
        _setState(state.copyWith(
          density: UiDensity.comfortable,
          textScaleFactor: 1.2,
          iconScaleFactor: 1.2,
          showToolDescription: true,
          cardStyle: UiCardStyle.flat,
          cardRadius: 12,
          preferredColumns: 2,
          enableAnimations: false,
          currentPreset: UiPreset.accessibilityHighContrast,
          shadowLevel: UiShadowLevel.off,
          highContrast: true,
        ), markCustom: false);
        break;
      case UiPreset.custom:
        _setState(state.copyWith(currentPreset: UiPreset.custom), markCustom: false);
        break;
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
