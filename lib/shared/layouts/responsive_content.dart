/// Constrains page content to a readable max width with responsive padding.
///
/// **Why:** Shared content column used inside [AppShell] pages — one grid.
/// **Owner:** Shared platform.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

/// Centers [child] and applies horizontal padding based on viewport width.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    super.key,
    this.maxWidth = AppBreakpoints.contentMaxWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  /// Horizontal inset for the shared content grid at [width].
  static double horizontalPadding(double width) {
    if (width < AppBreakpoints.compact) return AppSpacing.sm;
    if (width < AppBreakpoints.medium) return AppSpacing.md;
    return AppSpacing.lg;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: horizontalPadding(width),
                vertical: AppSpacing.md,
              ),
          child: child,
        ),
      ),
    );
  }
}
