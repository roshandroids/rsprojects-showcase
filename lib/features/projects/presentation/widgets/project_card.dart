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

IconData _categoryIcon(ProjectCategory category) {
  return switch (category) {
    ProjectCategory.platform => Icons.layers_rounded,
    ProjectCategory.tool => Icons.build_circle_outlined,
    ProjectCategory.library => Icons.extension_outlined,
    ProjectCategory.app => Icons.apps_rounded,
    ProjectCategory.other => Icons.auto_awesome_outlined,
  };
}

/// Equal-height project card — cover, title, description, meta, badges, footer.
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      elevated: project.featured,
      clipChild: true,
      onTap: () => context.go(AppRoutes.projectDetailPath(project.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardMedia(project: project),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: AppRadius.borderMd,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          _categoryIcon(project.category),
                          color: scheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          project.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    project.tagline ?? project.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'v${project.version} · ${project.category.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (project.featured)
                        const AppBadge(
                          label: 'Featured',
                          tone: AppBadgeTone.featured,
                        ),
                      AppBadge(
                        label: project.status.name,
                        tone: _statusTone(project.status),
                      ),
                      ...project.platforms.take(2).map(
                            (platform) => AppBadge(label: platform),
                          ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        'View project',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: scheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMedia extends StatelessWidget {
  const _CardMedia({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: SizedBox(
        height: 128,
        width: double.infinity,
        child: Center(
          child: Icon(
            _categoryIcon(project.category),
            size: 36,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
