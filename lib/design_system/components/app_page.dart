/// Page and grid layout primitives — one content grid, equal-height rows.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_breakpoints.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/design_system/components/app_footer.dart';
import 'package:rsprojects_showcase/shared/layouts/responsive_content.dart';

/// Scrollable page body with responsive content width and site footer.
class AppPage extends StatelessWidget {
  const AppPage({
    required this.child,
    super.key,
    this.padding,
    this.showFooter = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveContent(
            padding: padding,
            child: child,
          ),
          if (showFooter) const AppFooter(),
        ],
      ),
    );
  }
}

/// Responsive grid that keeps tiles in a row the same height.
class AppGrid extends StatelessWidget {
  const AppGrid({
    required this.children,
    super.key,
    this.minTileWidth = 280,
    this.spacing = AppSpacing.md,
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

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += columns) {
          final slice = children.sublist(
            i,
            (i + columns).clamp(0, children.length),
          );
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < columns; j++) ...[
                    if (j > 0) SizedBox(width: spacing),
                    Expanded(
                      child: j < slice.length ? slice[j] : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
          );
          if (i + columns < children.length) {
            rows.add(SizedBox(height: spacing));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
