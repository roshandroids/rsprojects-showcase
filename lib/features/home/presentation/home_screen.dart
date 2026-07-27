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

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.surface,
            scheme.tertiary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.section,
          AppSpacing.lg,
          AppSpacing.section,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppBreakpoints.contentMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                HomeContent.heroHeadline,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                HomeContent.heroSupport,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton(
                    label: 'Explore projects',
                    icon: Icons.grid_view_rounded,
                    onPressed: () => context.go(AppRoutes.projects),
                  ),
                  AppButton(
                    label: 'About RSProjects',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go(AppRoutes.about),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          eyebrow: 'Featured',
          title: 'Spotlight projects',
          subtitle: 'Curated entries from the registry (`featured: true`).',
          action: AppButton(
            label: 'All projects',
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
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

class _PrinciplesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      item.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.72),
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
              AppBadge(label: tech, tone: AppBadgeTone.primary),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          eyebrow: 'Open',
          title: 'Open source',
          subtitle: HomeContent.openSourceBody,
        ),
        const SizedBox(height: AppSpacing.lg),
        SelectableText(
          HomeContent.openSourceUrl,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _CommunitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          eyebrow: 'People',
          title: 'Community',
          subtitle: HomeContent.communityBody,
        ),
      ],
    );
  }
}

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(HomeContent.ctaTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            HomeContent.ctaBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Browse the catalog',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => context.go(AppRoutes.projects),
          ),
        ],
      ),
    );
  }
}
