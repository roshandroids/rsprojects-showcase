/// Shared project card for catalog and home featured sections.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';

AppBadgeTone _statusTone(ProjectStatus status) {
  return switch (status) {
    ProjectStatus.active => AppBadgeTone.success,
    ProjectStatus.beta => AppBadgeTone.info,
    ProjectStatus.experimental => AppBadgeTone.warning,
    ProjectStatus.archived => AppBadgeTone.neutral,
  };
}

/// Catalog / featured project surface.
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      elevated: project.featured,
      onTap: () => context.go(AppRoutes.projectDetailPath(project.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (project.featured)
                const AppBadge(
                  label: 'Featured',
                  tone: AppBadgeTone.featured,
                  icon: Icons.star_rounded,
                ),
            ],
          ),
          if (project.tagline != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              project.tagline!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.72),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppBadge(
                label: project.status.name,
                tone: _statusTone(project.status),
              ),
              AppBadge(
                label: project.category.name,
                tone: AppBadgeTone.primary,
              ),
              ...project.platforms.take(3).map(
                    (platform) => AppBadge(label: platform),
                  ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'v${project.version}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}
