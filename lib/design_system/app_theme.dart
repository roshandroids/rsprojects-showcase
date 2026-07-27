/// FlexColorScheme-powered Material 3 theme builders for RSProjects.
///
/// **Why:** Generates light/dark [ThemeData] from the custom brand palette
/// in [AppColors], with typography, radii, and semantic extensions applied.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/design_system/app_typography.dart';

/// Builds light and dark themes from the same RSProjects brand palette.
///
/// Does **not** use predefined [FlexScheme] presets.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        schemeColors: AppColors.brandScheme,
        semantic: AppSemanticColors.light,
        onSurface: AppBrand.ink,
        muted: AppBrand.muted,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        schemeColors: AppColors.brandSchemeDark,
        semantic: AppSemanticColors.dark,
        onSurface: AppBrand.mist,
        muted: const Color(0xFF94A3B8),
      );

  static ThemeData _build({
    required Brightness brightness,
    required FlexSchemeColor schemeColors,
    required AppSemanticColors semantic,
    required Color onSurface,
    required Color muted,
  }) {
    final textTheme = AppTypography.textTheme(
      onSurface: onSurface,
      muted: muted,
    );

    final base = brightness == Brightness.light
        ? FlexThemeData.light(
            colors: schemeColors,
            useMaterial3: true,
            // Custom brand only — no FlexScheme.* presets.
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 6,
            appBarStyle: FlexAppBarStyle.surface,
            subThemesData: _subThemes,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            textTheme: textTheme,
            primaryTextTheme: textTheme,
          )
        : FlexThemeData.dark(
            colors: schemeColors,
            useMaterial3: true,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 8,
            appBarStyle: FlexAppBarStyle.surface,
            subThemesData: _subThemes,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            textTheme: textTheme,
            primaryTextTheme: textTheme,
          );

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[semantic],
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnColors: true,
    useM2StyleDividerInM3: false,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: AppRadius.md,
    filledButtonRadius: AppRadius.sm,
    elevatedButtonRadius: AppRadius.sm,
    outlinedButtonRadius: AppRadius.sm,
    textButtonRadius: AppRadius.sm,
    chipRadius: AppRadius.sm,
    cardRadius: AppRadius.md,
    dialogRadius: AppRadius.lg,
    bottomSheetRadius: AppRadius.lg,
    navigationBarLabelBehavior:
        NavigationDestinationLabelBehavior.alwaysShow,
    alignedDropdown: true,
    // Spacing-aware component defaults (placeholders for later refinement).
    defaultRadius: AppRadius.md,
    thinBorderWidth: 1,
    thickBorderWidth: 1.5,
    inputDecoratorContentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );
}
