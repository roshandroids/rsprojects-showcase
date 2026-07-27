/// Project detail presentation — metadata-driven by route id.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_showcase_template.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

/// Detail screen for a single project id from the registry.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProject = ref.watch(projectByIdProvider(projectId));
    final asyncCatalog = ref.watch(projectsCatalogProvider);

    return AppPage(
      child: asyncProject.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppLoadingState(message: 'Loading project…'),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppErrorState(
            title: 'Could not load project',
            message: error.toString(),
            onRetry: () => ref.invalidate(projectByIdProvider(projectId)),
          ),
        ),
        data: (project) {
          if (project == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppEmptyState(
                title: 'Project not found',
                message:
                    'No registry entry matches “$projectId”. '
                    'Check the id or return to the catalog.',
                icon: Icons.search_off_rounded,
                actionLabel: 'Back to Projects',
                onAction: () => context.go(AppRoutes.projects),
              ),
            );
          }

          final relatedIds = project.showcase?.relatedProjectIds ?? const [];
          final related = asyncCatalog.maybeWhen(
            data: (catalog) => resolveRelatedProjects(
              catalog.all.where((p) => p.id != project.id).toList(),
              relatedIds,
            ),
            orElse: () => const <Project>[],
          );
          final examples = asyncCatalog.maybeWhen(
            data: (catalog) => catalog.examples,
            orElse: () => const <ProjectExample>[],
          );

          return ProjectShowcaseTemplate(
            project: project,
            relatedProjects: related,
            examples: examples,
          );
        },
      ),
    );
  }
}
