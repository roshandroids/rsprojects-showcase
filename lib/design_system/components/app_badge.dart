/// Status / platform badges — restrained Material 3 tonal chips.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_colors.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

/// Hierarchy: neutral (default) → primary (emphasis) → success/warning (status).
enum AppBadgeTone { neutral, primary, success, warning, info, featured }

/// Compact label badge with soft tonal fill — no heavy borders.
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

    // Prefer surface tones; reserve semantic colors for status only.
    final (Color bg, Color fg) = switch (tone) {
      AppBadgeTone.neutral => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
      AppBadgeTone.primary => (
          scheme.primaryContainer.withValues(alpha: 0.55),
          scheme.onPrimaryContainer,
        ),
      AppBadgeTone.success => (
          semantic.successContainer.withValues(alpha: 0.7),
          semantic.onSuccessContainer,
        ),
      AppBadgeTone.warning => (
          semantic.warningContainer.withValues(alpha: 0.7),
          semantic.onWarningContainer,
        ),
      AppBadgeTone.info => (
          scheme.secondaryContainer.withValues(alpha: 0.55),
          scheme.onSecondaryContainer,
        ),
      AppBadgeTone.featured => (
          scheme.primaryContainer.withValues(alpha: 0.55),
          scheme.onPrimaryContainer,
        ),
    };

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.borderChip,
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
