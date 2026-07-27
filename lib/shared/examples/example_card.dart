/// Interactive card for a single [ProjectExample].
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

/// Card container for example title, metadata, and optional demo summary.
class ExampleCard extends StatelessWidget {
  const ExampleCard({
    required this.example,
    super.key,
    this.onTap,
    this.showDemo = true,
  });

  final ProjectExample example;
  final VoidCallback? onTap;
  final bool showDemo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final demo = example.resolvedDemo;

    return AppCard(
      onTap: onTap,
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                label: example.category.label,
                tone: AppBadgeTone.primary,
              ),
              if (example.featured) ...[
                const SizedBox(width: AppSpacing.sm),
                const AppBadge(label: 'Featured', tone: AppBadgeTone.info),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(example.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            example.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          if (example.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in example.tags)
                  AppBadge(label: tag, tone: AppBadgeTone.neutral),
              ],
            ),
          ],
          if (showDemo) ...[
            const SizedBox(height: AppSpacing.md),
            _DemoSummary(demo: demo),
          ],
          if (example.sourceUrl != null) ...[
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              example.sourceUrl!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.primary,
              ),
            ),
          ],
          if (example.documentationLinks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final link in example.documentationLinks)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                child: Text(
                  link.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DemoSummary extends StatelessWidget {
  const _DemoSummary({required this.demo});

  final DemoSpec demo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (IconData icon, String label, String? detail) = switch (demo) {
      DemoEmbeddedWeb(:final embedUrl) => (
          Icons.web_rounded,
          'Embedded web demo',
          embedUrl,
        ),
      DemoExternalLink(:final url) => (
          Icons.open_in_new_rounded,
          'External demo',
          url,
        ),
      DemoMediaFallback(:final media) => (
          Icons.slideshow_rounded,
          'Media preview',
          '${media.length} item${media.length == 1 ? '' : 's'}',
        ),
      DemoUnavailable(:final note) => (
          Icons.hourglass_empty_rounded,
          'Demo unavailable',
          note,
        ),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge),
              if (detail != null && detail.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
