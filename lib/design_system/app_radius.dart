/// Corner radius / shape tokens (Material 3 expressive).
///
/// **Why:** Shared shape language for buttons, cards, inputs, and chrome.
/// **Owner:** Design system (extractable to `rsprojects_design_system`).
library;

import 'package:flutter/material.dart';

/// Radius scale and derived [BorderRadius] / [ShapeBorder] helpers.
abstract final class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double sm = 8;
  static const double md = 12;

  /// Chips / compact controls (~10–12dp).
  static const double chip = 11;

  /// Buttons / inputs (~12–16dp).
  static const double button = 14;

  /// Cards / large surfaces (~16–20dp).
  static const double card = 18;
  static const double lg = 16;
  static const double dialog = 20;
  static const double xl = 24;
  static const double full = 999;

  static final BorderRadius borderSm = BorderRadius.circular(sm);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderChip = BorderRadius.circular(chip);
  static final BorderRadius borderButton = BorderRadius.circular(button);
  static final BorderRadius borderLg = BorderRadius.circular(lg);
  static final BorderRadius borderCard = BorderRadius.circular(card);
  static final BorderRadius borderDialog = BorderRadius.circular(dialog);
  static final BorderRadius borderXl = BorderRadius.circular(xl);

  static final RoundedRectangleBorder shapeSm =
      RoundedRectangleBorder(borderRadius: borderSm);
  static final RoundedRectangleBorder shapeMd =
      RoundedRectangleBorder(borderRadius: borderMd);
  static final RoundedRectangleBorder shapeLg =
      RoundedRectangleBorder(borderRadius: borderLg);
  static final RoundedRectangleBorder shapeCard =
      RoundedRectangleBorder(borderRadius: borderCard);
}
