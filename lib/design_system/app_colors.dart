/// RSProjects semantic color tokens (status / chrome) layered on FlexScheme.
///
/// **Why:** FlexScheme.tealM3 drives Material [ColorScheme]; this file holds
/// brand-adjacent seeds for semantics and chrome that ColorScheme does not cover.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flutter/material.dart';

/// Brand-adjacent seeds aligned with FlexScheme.tealM3 (Blue stone teal).
///
/// Prefer [ColorScheme] from the theme for UI colors. Use [AppBrand] only for
/// semantic extensions and rare chrome that sits outside Material roles.
abstract final class AppBrand {
  AppBrand._();

  // Align with FlexColor.tealM3 light primary / cool slate neutrals.
  static const Color primary = Color(0xFF006A60);
  static const Color primaryContainer = Color(0xFFBBEDE6);
  static const Color secondary = Color(0xFF0E7490); // cyan accent (developer stack)
  static const Color secondaryContainer = Color(0xFFCFFAFE);
  static const Color tertiary = Color(0xFF4338CA); // subtle indigo accent
  static const Color tertiaryContainer = Color(0xFFE0E7FF);

  static const Color error = Color(0xFFB42318);
  static const Color errorContainer = Color(0xFFFEF3F2);

  static const Color success = Color(0xFF067647);
  static const Color successContainer = Color(0xFFDCFAE6);
  static const Color warning = Color(0xFFB54708);
  static const Color warningContainer = Color(0xFFFFFAEB);
  static const Color info = Color(0xFF175CD3);
  static const Color infoContainer = Color(0xFFEFF8FF);

  static const Color ink = Color(0xFF0F172A);
  static const Color mist = Color(0xFFF1F5F9);
  static const Color outline = Color(0xFF94A3B8);
  static const Color muted = Color(0xFF64748B);
}

/// Semantic colors beyond the Material [ColorScheme] (success / warning / info).
///
/// Access via `Theme.of(context).extension<AppSemanticColors>()` or
/// `context.semanticColors`.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.muted,
    required this.outlineSubtle,
    required this.brandMark,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color muted;
  final Color outlineSubtle;
  final Color brandMark;

  /// Light semantic overlay seeded from [AppBrand].
  static const AppSemanticColors light = AppSemanticColors(
    success: AppBrand.success,
    onSuccess: Color(0xFFFFFFFF),
    successContainer: AppBrand.successContainer,
    onSuccessContainer: Color(0xFF053321),
    warning: AppBrand.warning,
    onWarning: Color(0xFFFFFFFF),
    warningContainer: AppBrand.warningContainer,
    onWarningContainer: Color(0xFF7A2E0E),
    info: AppBrand.info,
    onInfo: Color(0xFFFFFFFF),
    infoContainer: AppBrand.infoContainer,
    onInfoContainer: Color(0xFF102A56),
    muted: AppBrand.muted,
    outlineSubtle: Color(0xFFCBD5E1),
    brandMark: AppBrand.primary,
  );

  /// Dark semantic overlay — slate-forward, not pure black.
  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF47CD89),
    onSuccess: Color(0xFF053321),
    successContainer: Color(0xFF085D3A),
    onSuccessContainer: AppBrand.successContainer,
    warning: Color(0xFFFDB022),
    onWarning: Color(0xFF7A2E0E),
    warningContainer: Color(0xFF93370D),
    onWarningContainer: AppBrand.warningContainer,
    info: Color(0xFF84CAFF),
    onInfo: Color(0xFF102A56),
    infoContainer: Color(0xFF1849A9),
    onInfoContainer: AppBrand.infoContainer,
    muted: Color(0xFF94A3B8),
    outlineSubtle: Color(0xFF334155),
    brandMark: Color(0xFF53DBCA),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? muted,
    Color? outlineSubtle,
    Color? brandMark,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      muted: muted ?? this.muted,
      outlineSubtle: outlineSubtle ?? this.outlineSubtle,
      brandMark: brandMark ?? this.brandMark,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer:
          Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      outlineSubtle: Color.lerp(outlineSubtle, other.outlineSubtle, t)!,
      brandMark: Color.lerp(brandMark, other.brandMark, t)!,
    );
  }
}

/// Convenience accessors for semantic tokens and [ColorScheme].
extension AppThemeColorsX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
