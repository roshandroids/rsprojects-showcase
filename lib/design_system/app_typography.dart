/// RSProjects typography scale.
///
/// **Why:** Central text styles for FlexColorScheme / [ThemeData.textTheme].
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
///
/// Uses Flutter Material typography as the body baseline (cross-platform) with
/// a serif display stack via [fontFamilyFallback] — no web-only font APIs.
library;

import 'package:flutter/material.dart';

/// Typography builders for light and dark themes.
abstract final class AppTypography {
  AppTypography._();

  /// Cross-platform display fallbacks (resolved per host; not web-only).
  static const List<String> displayFallback = [
    'Georgia',
    'Times New Roman',
    'serif',
  ];

  /// Base text theme colored for [onSurface] / muted labels.
  static TextTheme textTheme({
    required Color onSurface,
    required Color muted,
  }) {
    // Material 2021 defaults work on Web, mobile, and desktop without
    // hard-coding a single OS font family (e.g. Segoe UI).
    final base = Typography.material2021().black.apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );

    TextStyle display(TextStyle? style) => (style ?? const TextStyle()).copyWith(
          fontFamilyFallback: displayFallback,
          fontWeight: FontWeight.w600,
          height: 1.1,
          letterSpacing: -0.6,
          color: onSurface,
        );

    return base.copyWith(
      displayLarge: display(base.displayLarge).copyWith(fontSize: 57),
      displayMedium: display(base.displayMedium).copyWith(fontSize: 45),
      displaySmall: display(base.displaySmall).copyWith(fontSize: 36),
      headlineLarge: display(base.headlineLarge).copyWith(fontSize: 32),
      headlineMedium: display(base.headlineMedium).copyWith(fontSize: 28),
      headlineSmall: display(base.headlineSmall).copyWith(
            fontSize: 24,
            letterSpacing: -0.3,
          ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.5, color: onSurface),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.5, color: onSurface),
      bodySmall: base.bodySmall?.copyWith(height: 1.45, color: muted),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(color: muted),
      labelSmall: base.labelSmall?.copyWith(color: muted),
    );
  }
}
