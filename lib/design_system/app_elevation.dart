/// Elevation / opacity tokens for surfaces.
///
/// **Why:** Card and chrome depth without hardcoding shadow values in widgets.
/// **Owner:** Design system.
library;

import 'package:flutter/material.dart';

/// Surface elevation and overlay opacity scale.
abstract final class AppElevation {
  AppElevation._();

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 2;

  static const double overlaySubtle = 0.04;
  static const double overlayMedium = 0.08;
  static const double chromeOpacity = 0.86;
  static const double footerOpacity = 0.72;

  static List<BoxShadow> softShadow(ColorScheme scheme) {
    return [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
