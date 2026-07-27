/// Spacing scale for consistent layout rhythm.
///
/// **Why:** Central spacing tokens so features do not hardcode padding values.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

/// 8px-based spacing scale (with a 4px half-step for tight inline gaps).
abstract final class AppSpacing {
  AppSpacing._();

  /// Half-step for icon gaps and badge padding only.
  static const double xxs = 4;

  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
  static const double xxl = 64;
  static const double section = 96;
}
