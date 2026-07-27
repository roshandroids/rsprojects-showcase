/// Motion tokens (durations and curves).
///
/// **Why:** Consistent animation language across the portal.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flutter/animation.dart';

/// Shared motion primitives — subtle only (150–200ms hover).
abstract final class AppMotion {
  AppMotion._();

  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration emphasis = Duration(milliseconds: 400);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutCubic;

  static Duration pageTransition = normal;
  static Curve pageCurve = standard;
}
