/// Home presentation — brand-first landing with registry featured projects.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/home/presentation/home_content.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_card.dart';

/// Brand-first home experience (shell-hosted).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HeroSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.section),
                const _FeaturedSection(),
                const SizedBox(height: AppSpacing.section),
                const _CategoriesSection(),
                const SizedBox(height: AppSpacing.section),
                _PrinciplesSection(),
                const SizedBox(height: AppSpacing.section),
                _TechnologiesSection(),
                const SizedBox(height: AppSpacing.section),
                _OpenSourceSection(),
                const SizedBox(height: AppSpacing.section),
                _CommunitySection(),
                const SizedBox(height: AppSpacing.section),
                const _FinalCtaSection(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final compact = AppBreakpoints.isCompact(width);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.45, 1.0],
          colors: [
            scheme.primary.withValues(alpha: 0.16),
            scheme.surface,
            scheme.tertiary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: compact ? -40 : 48,
            top: compact ? 24 : 40,
            child: IgnorePointer(
              child: Container(
                width: compact ? 160 : 280,
                height: compact ? 160 : 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      scheme.secondary.withValues(alpha: 0.18),
                      scheme.secondary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              compact ? AppSpacing.xxl : AppSpacing.section + AppSpacing.lg,
              AppSpacing.lg,
              compact ? AppSpacing.xxl : AppSpacing.section + AppSpacing.md,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBadge(
                    label: HomeContent.heroEyebrow,
                    tone: AppBadgeTone.primary,
                    icon: Icons.hub_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppConstants.appName,
                    style: (compact
                            ? theme.textTheme.displaySmall
                            : theme.textTheme.displayMedium)
                        ?.copyWith(color: scheme.primary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(
                      HomeContent.heroHeadline,
                      style: compact
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      HomeContent.heroSupport,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    children: [
                      AppButton(
                        label: 'Explore projects',
                        size: AppButtonSize.large,
                        icon: Icons.grid_view_rounded,
                        onPressed: () => context.go(AppRoutes.projects),
                      ),
                      AppButton(
                        label: 'About RSProjects',
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.large,
                        onPressed: () => context.go(AppRoutes.about),
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

class _FeaturedSection extends ConsumerWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCatalog = ref.watch(projectsCatalogProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          eyebrow: 'Spotlight',
          title: 'Featured projects',
          subtitle:
              'Curated registry entries marked featured — still fully content-driven.',
          action: AppButton(
            label: 'All projects',
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => context.go(AppRoutes.projects),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        asyncCatalog.when(
          loading: () => const AppLoadingState(message: 'Loading featured…'),
          error: (error, _) => AppErrorState(
            title: 'Could not load featured projects',
            message: error.toString(),
            onRetry: () =>
                ref.read(projectsCatalogProvider.notifier).refresh(),
          ),
          data: (catalog) {
            final featured = catalog.featured;
            if (featured.isEmpty) {
              return const AppEmptyState(
                title: 'No featured projects',
                message:
                    'Mark a project as featured in metadata and regenerate '
                    'the registry.',
                icon: Icons.star_outline_rounded,
              );
            }
            return AppGrid(
              children: [
                for (final project in featured) ProjectCard(project: project),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CategoriesSection extends ConsumerWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCatalog = ref.watch(projectsCatalogProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          eyebrow: 'Browse',
          title: 'Categories',
          subtitle: 'Jump into the catalog by product category from the registry.',
        ),
        const SizedBox(height: AppSpacing.xl),
        asyncCatalog.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (catalog) {
            final categories = <ProjectCategory>{
              for (final p in catalog.all) p.category,
            }.toList()
              ..sort((a, b) => a.name.compareTo(b.name));

            if (categories.isEmpty) return const SizedBox.shrink();

            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final category in categories)
                  Material(
                    type: MaterialType.transparency,
                    child: ActionChip(
                      avatar: Icon(
                        _categoryIcon(category),
                        size: 18,
                        color: scheme.primary,
                      ),
                      label: Text(category.name),
                      onPressed: () => context.go(AppRoutes.projects),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
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

class _PrinciplesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          eyebrow: 'Craft',
          title: 'Engineering principles',
          subtitle: HomeContent.principlesIntro,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppGrid(
          minTileWidth: 240,
          children: [
            for (final item in HomeContent.principles)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: scheme.primary, size: 28),
                    const SizedBox(height: AppSpacing.md),
                    Text(item.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      item.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TechnologiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          eyebrow: 'Stack',
          title: 'Technologies',
          subtitle: HomeContent.technologiesIntro,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final tech in HomeContent.technologies)
              AppChip(label: tech, selected: true),
          ],
        ),
      ],
    );
  }
}

class _OpenSourceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code_rounded, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Open source', style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            HomeContent.openSourceBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableText(
            HomeContent.openSourceUrl,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups_outlined, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Community', style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            HomeContent.communityBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderCard,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.55),
            scheme.tertiaryContainer.withValues(alpha: 0.4),
          ],
        ),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(HomeContent.ctaTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              HomeContent.ctaBody,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Browse the catalog',
              size: AppButtonSize.large,
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(AppRoutes.projects),
            ),
          ],
        ),
      ),
    );
  }
}
