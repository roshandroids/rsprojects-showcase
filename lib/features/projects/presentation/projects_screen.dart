/// Projects catalog presentation — search, filters, responsive grid.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        AppSectionHeader(
          eyebrow: 'Catalog',
          title: 'Projects',
          subtitle:
              'Browse RSProjects products from the generated registry. '
              'Search and filter stay on this page for Phase 1.',
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search projects',
            hintText: 'Name, tagline, tags…',
            prefixIcon: Icon(Icons.search_rounded),
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.setSearch,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Platform',
                style: Theme.of(context).textTheme.labelLarge,
              ),
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
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Text('Sort', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: AppSpacing.md),
            DropdownButton<ProjectSort>(
              value: query.sort,
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
            const Spacer(),
            AppButton(
              label: 'Clear filters',
              variant: AppButtonVariant.text,
              size: AppButtonSize.small,
              onPressed: notifier.clearFilters,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
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
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
