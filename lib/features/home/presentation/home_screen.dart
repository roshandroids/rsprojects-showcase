/// Home presentation — brand-first product landing aligned to one content grid.
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
    return const AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          SizedBox(height: AppSpacing.section),
          _FeaturedSection(),
          SizedBox(height: AppSpacing.section),
          _CategoriesSection(),
          SizedBox(height: AppSpacing.section),
          _PrinciplesSection(),
          SizedBox(height: AppSpacing.section),
          _TechnologiesSection(),
          SizedBox(height: AppSpacing.section),
          _OpenSourceSection(),
          SizedBox(height: AppSpacing.xl),
          _CommunitySection(),
          SizedBox(height: AppSpacing.section),
          _FinalCtaSection(),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = AppBreakpoints.isCompact(width);
    final medium = AppBreakpoints.isMedium(width) || compact;

    return Padding(
      padding: EdgeInsets.only(
        top: compact ? AppSpacing.xl : AppSpacing.xxl,
        bottom: AppSpacing.lg,
      ),
      child: medium
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCopy(compact: compact),
                const SizedBox(height: AppSpacing.lg),
                const _HeroProductPreview(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: _HeroCopy(compact: compact)),
                const SizedBox(width: AppSpacing.xl),
                const Expanded(flex: 5, child: _HeroProductPreview()),
              ],
            ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.appName,
          style: (compact
                  ? theme.textTheme.displaySmall
                  : theme.textTheme.displayMedium)
              ?.copyWith(letterSpacing: -1.2),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          HomeContent.heroHeadline,
          style: (compact
                  ? theme.textTheme.headlineSmall
                  : theme.textTheme.headlineMedium)
              ?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            HomeContent.heroSupport,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AppButton(
              label: 'Explore projects',
              size: AppButtonSize.large,
              onPressed: () => context.go(AppRoutes.projects),
            ),
            AppButton(
              label: 'About',
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.large,
              onPressed: () => context.go(AppRoutes.about),
            ),
          ],
        ),
      ],
    );
  }
}

/// Product showcase panel — catalog preview, not a decorative gradient.
class _HeroProductPreview extends StatelessWidget {
  const _HeroProductPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderCard,
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              border: Border(
                bottom: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
            child: Row(
              children: [
                _Dot(scheme.outline),
                const SizedBox(width: AppSpacing.xxs),
                _Dot(scheme.outline),
                const SizedBox(width: AppSpacing.xxs),
                _Dot(scheme.outline),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Projects',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: const [
                _PreviewRow(
                  title: 'Sample Platform',
                  meta: 'Platform · beta',
                ),
                SizedBox(height: AppSpacing.xs),
                _PreviewRow(
                  title: 'Sample Tool',
                  meta: 'Tool · active',
                ),
                SizedBox(height: AppSpacing.xs),
                _PreviewRow(
                  title: 'Sample App',
                  meta: 'App · experimental',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.title, required this.meta});

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(Icons.folder_outlined, size: 18, color: scheme.primary),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                Text(
                  meta,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
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
          title: 'Featured projects',
          subtitle: 'Curated products from the registry.',
          action: AppButton(
            label: 'View all',
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => context.go(AppRoutes.projects),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
          title: 'Browse by category',
          subtitle: 'Jump into the catalog by product type.',
        ),
        const SizedBox(height: AppSpacing.md),
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
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
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
  const _PrinciplesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'How we build',
          subtitle: HomeContent.principlesIntro,
        ),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 240,
          children: [
            for (final item in HomeContent.principles)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: scheme.primary, size: 24),
                    const SizedBox(height: AppSpacing.sm),
                    Text(item.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
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
  const _TechnologiesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Technologies',
          subtitle: HomeContent.technologiesIntro,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final tech in HomeContent.technologies)
              AppBadge(label: tech, tone: AppBadgeTone.neutral),
          ],
        ),
      ],
    );
  }
}

class _OpenSourceSection extends StatelessWidget {
  const _OpenSourceSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open source', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            HomeContent.openSourceBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
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

    return Material(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderCard,
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(HomeContent.ctaTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              HomeContent.ctaBody,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
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
