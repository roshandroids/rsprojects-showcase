/// Application theme tokens and ThemeData builders.
///
/// **Why:** Keeps visual system (colors, typography, spacing) out of features.
/// **Owner:** App / design system owner.
/// **When:** Implement after brand guidelines are finalized.
library;

import 'package:flutter/material.dart';

/// Builds light and dark [ThemeData] for the showcase portal.
///
/// TODO(app): Define color scheme, typography, and component themes.
abstract final class AppTheme {
  AppTheme._();

  // TODO(app): Implement lightTheme / darkTheme builders.
  static ThemeData get light {
    // TODO(app): Replace with branded ThemeData.
    return ThemeData.light(useMaterial3: true);
  }

  static ThemeData get dark {
    // TODO(app): Replace with branded ThemeData.
    return ThemeData.dark(useMaterial3: true);
  }
}
