/// FlexColorScheme-powered Material 3 theme builders for RSProjects.
///
/// **Why:** Generates polished light/dark [ThemeData] from FlexScheme.tealM3
/// with Material 3 component theming, surface blends, and semantic extensions.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/design_system/app_typography.dart';

/// Builds light and dark themes from [FlexScheme.tealM3] (Blue stone teal).
///
/// Chosen among FlexColorScheme built-ins for a premium, developer-centric
/// look: deep teal primary, cool slate surfaces, restrained blue tertiary.
abstract final class AppTheme {
  AppTheme._();

  /// Active FlexColorScheme preset (D-028).
  static const FlexScheme scheme = FlexScheme.tealM3;

  static ThemeData get light => _build(
        brightness: Brightness.light,
        semantic: AppSemanticColors.light,
        onSurface: AppBrand.ink,
        muted: AppBrand.muted,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        semantic: AppSemanticColors.dark,
        onSurface: AppBrand.mist,
        muted: const Color(0xFF94A3B8),
      );

  static ThemeData _build({
    required Brightness brightness,
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
            scheme: scheme,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 14,
            appBarStyle: FlexAppBarStyle.surface,
            tooltipsMatchBackground: true,
            visualDensity: VisualDensity.standard,
            subThemesData: _subThemes,
            textTheme: textTheme,
            primaryTextTheme: textTheme,
          )
        : FlexThemeData.dark(
            scheme: scheme,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 16,
            appBarStyle: FlexAppBarStyle.surface,
            tooltipsMatchBackground: true,
            visualDensity: VisualDensity.standard,
            darkIsTrueBlack: false,
            subThemesData: _subThemes,
            textTheme: textTheme,
            primaryTextTheme: textTheme,
          );

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[semantic],
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        surfaceTintColor: base.colorScheme.surfaceTint.withValues(alpha: 0.08),
        shape: AppRadius.shapeLg,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnColors: true,
    useMaterial3Typography: true,
    useM2StyleDividerInM3: false,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: AppRadius.button,
    filledButtonRadius: AppRadius.button,
    elevatedButtonRadius: AppRadius.button,
    outlinedButtonRadius: AppRadius.button,
    textButtonRadius: AppRadius.button,
    chipRadius: AppRadius.chip,
    cardRadius: AppRadius.card,
    dialogRadius: AppRadius.dialog,
    bottomSheetRadius: AppRadius.dialog,
    navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    alignedDropdown: true,
    defaultRadius: AppRadius.lg,
    thinBorderWidth: 1,
    thickBorderWidth: 1.5,
    elevatedButtonElevation: 1,
    inputDecoratorContentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );
}
