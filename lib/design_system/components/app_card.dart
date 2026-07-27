/// Surface card used across catalog and home.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_elevation.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

/// Themed card with optional tap handler.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.elevated = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
      elevation: elevated ? AppElevation.level1 : AppElevation.level0,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      shape: AppRadius.shapeMd,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              child: content,
            ),
    );
  }
}
