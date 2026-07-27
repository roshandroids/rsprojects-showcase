/// FlexColorScheme-powered Material 3 theme builders for RSProjects.
///
/// **Why:** Generates polished light/dark [ThemeData] from FlexScheme.tealM3
/// with Material 3 component theming and semantic extensions — clean surfaces,
/// no glossy chrome.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/design_system/app_typography.dart';

/// Builds light and dark themes from [FlexScheme.tealM3] (Blue stone teal).
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
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 4,
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
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 6,
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
      scaffoldBackgroundColor: base.colorScheme.surface,
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: base.colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: AppRadius.shapeCard,
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: base.colorScheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: base.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.55),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSearch,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSearch,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSearch,
          borderSide: BorderSide(
            color: base.colorScheme.primary.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs + 4,
        ),
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
    inputDecoratorIsFilled: true,
    inputDecoratorRadius: AppRadius.search,
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
    defaultRadius: AppRadius.md,
    thinBorderWidth: 1,
    thickBorderWidth: 1,
    elevatedButtonElevation: 0,
    inputDecoratorContentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs + 4,
    ),
  );
}
