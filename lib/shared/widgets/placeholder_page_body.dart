/// Shared placeholder page body used by feature screens before real UI lands.
///
/// **Why:** Consistent polished empty state inside the application shell.
/// **Owner:** Shared platform.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/shared/layouts/responsive_content.dart';

/// Polished placeholder content for shell-hosted routes.
class PlaceholderPageBody extends StatelessWidget {
  const PlaceholderPageBody({
    required this.title,
    required this.subtitle,
    super.key,
    this.eyebrow,
    this.actions = const [],
  });

  final String? eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ResponsiveContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            if (eyebrow != null) ...[
              Text(
                eyebrow!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(title, style: theme.textTheme.displaySmall),
            const SizedBox(height: AppSpacing.md),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: actions,
              ),
            ],
            const SizedBox(height: AppSpacing.section),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.45),
                ),
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.construction_rounded, color: scheme.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'This page is a structural placeholder. '
                        'Business logic and content loading are intentionally deferred.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
