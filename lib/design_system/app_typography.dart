/// RSProjects typography scale — Material 3 hierarchy, developer-centric.
///
/// **Why:** Central text styles for FlexColorScheme / [ThemeData.textTheme].
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
///
/// Uses Flutter Material 2021 typography (cross-platform) with tighter display
/// tracking for a premium product-marketing feel — no decorative serif stack.
library;

import 'package:flutter/material.dart';

/// Typography builders for light and dark themes.
abstract final class AppTypography {
  AppTypography._();

  /// Base text theme colored for [onSurface] / muted labels.
  static TextTheme textTheme({
    required Color onSurface,
    required Color muted,
  }) {
    final base = Typography.material2021().black.apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );

    TextStyle display(TextStyle? style) => (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w700,
          height: 1.05,
          letterSpacing: -1.4,
          color: onSurface,
        );

    TextStyle headline(TextStyle? style) => (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -0.6,
          color: onSurface,
        );

    return base.copyWith(
      displayLarge: display(base.displayLarge).copyWith(fontSize: 57),
      displayMedium: display(base.displayMedium).copyWith(fontSize: 45),
      displaySmall: display(base.displaySmall).copyWith(fontSize: 36),
      headlineLarge: headline(base.headlineLarge).copyWith(fontSize: 32),
      headlineMedium: headline(base.headlineMedium).copyWith(fontSize: 28),
      headlineSmall: headline(base.headlineSmall).copyWith(fontSize: 24),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.25,
        color: onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.55, color: onSurface),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.5, color: onSurface),
      bodySmall: base.bodySmall?.copyWith(height: 1.45, color: muted),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: muted,
      ),
    );
  }
}
