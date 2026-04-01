import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/spacing.dart';
import '../providers/settings_provider.dart';

class AppCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(settings.cardRadius);

    // 阴影
    final List<BoxShadow> shadows;
    switch (settings.shadowLevel) {
      case UiShadowLevel.off:
        shadows = [];
        break;
      case UiShadowLevel.soft:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ];
        break;
      case UiShadowLevel.strong:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ];
        break;
    }

    // 卡片风格
    final Color bgColor;
    switch (settings.cardStyle) {
      case UiCardStyle.soft:
        bgColor = cs.surfaceContainerLow;
        break;
      case UiCardStyle.flat:
        bgColor = cs.surface;
        break;
    }

    final card = Material(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: settings.highContrast
              ? cs.primary
              : cs.outlineVariant.withOpacity(0.5),
          width: settings.highContrast ? 1.5 : 0.5,
        ),
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: shadows,
        ),
        child: child,
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(borderRadius: borderRadius, onTap: onTap, child: card);
  }
}
