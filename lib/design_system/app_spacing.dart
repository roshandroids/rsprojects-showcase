/// Spacing scale for consistent layout rhythm.
///
/// **Why:** Central spacing tokens so features do not hardcode padding values.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

/// 4px-based spacing scale.
abstract final class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double section = 64;
}
