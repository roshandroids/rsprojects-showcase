/// Constrains page content to a readable max width with responsive padding.
///
/// **Why:** Shared content column used inside [AppShell] pages.
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < AppBreakpoints.compact
        ? AppSpacing.md
        : width < AppBreakpoints.medium
            ? AppSpacing.lg
            : AppSpacing.xl;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: AppSpacing.lg,
              ),
          child: child,
        ),
      ),
    );
  }
}
