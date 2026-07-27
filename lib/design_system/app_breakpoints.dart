/// Responsive breakpoint tokens for layout decisions.
///
/// **Why:** Single source for viewport thresholds — avoid magic numbers.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

/// Canonical breakpoints for RSProjects surfaces.
///
/// Widths are logical pixels (`MediaQuery.sizeOf(context).width`).
abstract final class AppBreakpoints {
  AppBreakpoints._();

  /// Compact phones / narrow windows.
  static const double compact = 600;

  /// Tablets / medium windows.
  static const double medium = 905;

  /// Desktops / wide windows.
  static const double expanded = 1240;

  /// Max content width inside the shell.
  static const double contentMaxWidth = 1120;

  static bool isCompact(double width) => width < compact;

  static bool isMedium(double width) => width >= compact && width < medium;

  static bool isExpanded(double width) => width >= medium;
}
