/// Projects catalog presentation — search, filter rows, equal-height grid.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_card.dart';

/// Registry-backed projects catalog screen.
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCatalog = ref.watch(projectsCatalogProvider);

    return AppPage(
      child: asyncCatalog.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppLoadingState(message: 'Loading projects…'),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppErrorState(
            title: 'Could not load projects',
            message: error.toString(),
            onRetry: () => ref.read(projectsCatalogProvider.notifier).refresh(),
          ),
        ),
        data: (catalog) => _CatalogBody(catalog: catalog),
      ),
    );
  }
}

class _CatalogBody extends ConsumerWidget {
  const _CatalogBody({required this.catalog});

  final ProjectsCatalogState catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(projectsCatalogProvider.notifier);
    final query = catalog.query;
    final filtered = catalog.filtered;
    final platforms = {
      for (final project in catalog.all) ...project.platforms,
    }.toList()
      ..sort();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasFilters = query.status != null ||
        query.category != null ||
        query.platform != null ||
        query.search.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        AppSectionHeader(
          title: 'Projects',
          subtitle:
              'Browse RSProjects products. Search and filter stay on this page.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppSearchField(
          hintText: 'Search by name, tagline, or tag…',
          onChanged: notifier.setSearch,
        ),
        const SizedBox(height: AppSpacing.md),
        _FilterRow(
          label: 'Status',
          children: [
            AppChip(
              label: 'All',
              selected: query.status == null,
              onSelected: (_) => notifier.setStatus(null),
            ),
            ...ProjectStatus.values.map(
              (status) => AppChip(
                label: status.name,
                selected: query.status == status,
                onSelected: (selected) =>
                    notifier.setStatus(selected ? status : null),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _FilterRow(
          label: 'Category',
          children: [
            AppChip(
              label: 'All',
              selected: query.category == null,
              onSelected: (_) => notifier.setCategory(null),
            ),
            ...ProjectCategory.values.map(
              (category) => AppChip(
                label: category.name,
                selected: query.category == category,
                onSelected: (selected) =>
                    notifier.setCategory(selected ? category : null),
              ),
            ),
          ],
        ),
        if (platforms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          _FilterRow(
            label: 'Platform',
            children: [
              AppChip(
                label: 'All',
                selected: query.platform == null,
                onSelected: (_) => notifier.setPlatform(null),
              ),
              ...platforms.map(
                (platform) => AppChip(
                  label: platform,
                  selected: query.platform == platform,
                  onSelected: (selected) =>
                      notifier.setPlatform(selected ? platform : null),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text(
              'Sort',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            DropdownButtonHideUnderline(
              child: DropdownButton<ProjectSort>(
                value: query.sort,
                borderRadius: AppRadius.borderMd,
                onChanged: (value) {
                  if (value != null) notifier.setSort(value);
                },
                items: const [
                  DropdownMenuItem(
                    value: ProjectSort.featuredFirst,
                    child: Text('Featured first'),
                  ),
                  DropdownMenuItem(
                    value: ProjectSort.nameAsc,
                    child: Text('Name A–Z'),
                  ),
                  DropdownMenuItem(
                    value: ProjectSort.nameDesc,
                    child: Text('Name Z–A'),
                  ),
                  DropdownMenuItem(
                    value: ProjectSort.status,
                    child: Text('Status'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (hasFilters)
              AppButton(
                label: 'Clear filters',
                variant: AppButtonVariant.text,
                size: AppButtonSize.small,
                onPressed: notifier.clearFilters,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (catalog.all.isEmpty)
          const AppEmptyState(
            title: 'No projects yet',
            message:
                'The registry is empty. Add metadata under content/projects '
                'and regenerate the registry.',
            icon: Icons.folder_off_outlined,
          )
        else if (filtered.isEmpty)
          AppEmptyState(
            title: 'No matching projects',
            message: 'Try adjusting search or filters.',
            icon: Icons.filter_alt_off_outlined,
            actionLabel: 'Clear filters',
            onAction: notifier.clearFilters,
          )
        else
          AppGrid(
            children: [
              for (final project in filtered) ProjectCard(project: project),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: children,
        ),
      ],
    );
  }
}
