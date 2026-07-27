/// Status / platform / featured badges — Material 3 tonal chips.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

enum AppBadgeTone { neutral, primary, success, warning, info, featured }

/// Compact label badge with outline + tonal fill.
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

    final (Color bg, Color fg, Color border) = switch (tone) {
      AppBadgeTone.neutral => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
          scheme.outlineVariant,
        ),
      AppBadgeTone.primary => (
          scheme.primaryContainer.withValues(alpha: 0.72),
          scheme.onPrimaryContainer,
          scheme.primary.withValues(alpha: 0.28),
        ),
      AppBadgeTone.success => (
          semantic.successContainer,
          semantic.onSuccessContainer,
          semantic.success.withValues(alpha: 0.28),
        ),
      AppBadgeTone.warning => (
          semantic.warningContainer,
          semantic.onWarningContainer,
          semantic.warning.withValues(alpha: 0.28),
        ),
      AppBadgeTone.info => (
          semantic.infoContainer,
          semantic.onInfoContainer,
          semantic.info.withValues(alpha: 0.28),
        ),
      AppBadgeTone.featured => (
          scheme.tertiaryContainer.withValues(alpha: 0.8),
          scheme.onTertiaryContainer,
          scheme.tertiary.withValues(alpha: 0.32),
        ),
    };

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs + 1,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.borderChip,
          border: Border.all(color: border),
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
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
