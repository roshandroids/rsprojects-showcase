/// Status / platform / featured badges.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

enum AppBadgeTone { neutral, primary, success, warning, info, featured }

/// Compact label badge.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.tone = AppBadgeTone.neutral,
    this.icon,
  });

  final String label;
  final AppBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semanticColors;

    final (Color bg, Color fg) = switch (tone) {
      AppBadgeTone.neutral => (
          scheme.surfaceContainerHighest,
          scheme.onSurface.withValues(alpha: 0.8),
        ),
      AppBadgeTone.primary => (
          scheme.primary.withValues(alpha: 0.14),
          scheme.primary,
        ),
      AppBadgeTone.success => (
          semantic.successContainer,
          semantic.onSuccessContainer,
        ),
      AppBadgeTone.warning => (
          semantic.warningContainer,
          semantic.onWarningContainer,
        ),
      AppBadgeTone.info => (
          semantic.infoContainer,
          semantic.onInfoContainer,
        ),
      AppBadgeTone.featured => (
          scheme.tertiary.withValues(alpha: 0.16),
          scheme.tertiary,
        ),
    };

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.borderSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
