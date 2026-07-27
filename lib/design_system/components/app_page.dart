/// Page and grid layout primitives.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_breakpoints.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/shared/layouts/responsive_content.dart';

/// Scrollable page body with responsive content width.
class AppPage extends StatelessWidget {
  const AppPage({
    required this.child,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContent(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Responsive wrap/grid for cards.
class AppGrid extends StatelessWidget {
  const AppGrid({
    required this.children,
    super.key,
    this.minTileWidth = 280,
    this.spacing = AppSpacing.lg,
  });

  final List<Widget> children;
  final double minTileWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < AppBreakpoints.compact
            ? 1
            : width < AppBreakpoints.medium
                ? 2
                : (width / minTileWidth).floor().clamp(2, 3);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(
                width: columns == 1
                    ? width
                    : (width - spacing * (columns - 1)) / columns,
                child: child,
              ),
          ],
        );
      },
    );
  }
}
