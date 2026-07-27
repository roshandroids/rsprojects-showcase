/// Generic project showcase — product landing layout for every RSProjects entry.
///
/// Sections render only when content is available. No project-specific UI.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_card.dart';
import 'package:rsprojects_showcase/shared/examples/example_gallery.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

AppBadgeTone statusTone(ProjectStatus status) {
  return switch (status) {
    ProjectStatus.active => AppBadgeTone.success,
    ProjectStatus.beta => AppBadgeTone.info,
    ProjectStatus.experimental => AppBadgeTone.warning,
    ProjectStatus.archived => AppBadgeTone.neutral,
  };
}

/// Canonical showcase layout driven entirely by [project] (+ resolved related).
class ProjectShowcaseTemplate extends StatelessWidget {
  const ProjectShowcaseTemplate({
    required this.project,
    super.key,
    this.relatedProjects = const [],
    this.examples,
    this.onBack,
  });

  final Project project;
  final List<Project> relatedProjects;
  final List<ProjectExample>? examples;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final showcase = project.showcase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        _Breadcrumb(
          projectName: project.name,
          onBack: onBack ?? () => context.go(AppRoutes.projects),
        ),
        const SizedBox(height: AppSpacing.lg),
        _HeroSection(project: project),
        if (_hasPrimaryActions(project)) ...[
          const SizedBox(height: AppSpacing.md),
          _QuickActions(project: project),
        ],
        if (showcase?.problem != null || showcase?.solution != null) ...[
          const SizedBox(height: AppSpacing.section),
          _OverviewSection(
            problem: showcase?.problem,
            solution: showcase?.solution,
            description: project.description,
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.section),
          _OverviewSection(description: project.description),
        ],
        if (showcase != null && showcase.features.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _FeaturesSection(features: showcase.features),
        ],
        const SizedBox(height: AppSpacing.section),
        _DemoSection(project: project, demo: showcase?.demo),
        if (showcase != null && showcase.galleryItems.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _GallerySection(items: showcase.galleryItems),
        ],
        if (showcase != null &&
            (showcase.architecture != null ||
                showcase.architectureDiagram != null)) ...[
          const SizedBox(height: AppSpacing.section),
          _ArchitectureSection(
            body: showcase.architecture,
            diagram: showcase.architectureDiagram,
          ),
        ],
        if (showcase != null && showcase.technologies.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _TechnologiesSection(technologies: showcase.technologies),
        ],
        const SizedBox(height: AppSpacing.section),
        if (showcase != null && showcase.platformSupport.isNotEmpty)
          _PlatformSupportSection(items: showcase.platformSupport)
        else
          _PlatformSupportSection(
            items: [
              for (final platform in project.platforms)
                ShowcasePlatformSupport(platform: platform),
            ],
          ),
        if (showcase?.installation != null) ...[
          const SizedBox(height: AppSpacing.section),
          _TextBlock(title: 'Get started', body: showcase!.installation!),
        ],
        if (showcase != null && showcase.documentationLinks.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _DocumentationSection(links: showcase.documentationLinks),
        ],
        if (examples != null) ...[
          const SizedBox(height: AppSpacing.section),
          ExampleGallery(projectId: project.id, examples: examples!),
        ],
        if (showcase != null && showcase.benchmarks.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _BenchmarksSection(benchmarks: showcase.benchmarks),
        ],
        if (showcase != null && showcase.roadmap.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _RoadmapSection(items: showcase.roadmap),
        ],
        if (showcase != null && showcase.changelog.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _ChangelogSection(entries: showcase.changelog),
        ],
        if (showcase != null && showcase.contributors.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _ContributorsSection(contributors: showcase.contributors),
        ],
        if (showcase != null && showcase.downloads.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _DownloadsSection(downloads: showcase.downloads),
        ],
        if (relatedProjects.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          _RelatedSection(projects: relatedProjects),
        ],
        if (showcase?.contributing != null) ...[
          const SizedBox(height: AppSpacing.section),
          _TextBlock(title: 'Contributing', body: showcase!.contributing!),
        ],
        if (project.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          AppSectionHeader(
            title: 'Tags',
            subtitle: project.tags.join(' · '),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  bool _hasPrimaryActions(Project project) {
    return project.demoUrl != null ||
        project.repositoryUrl != null ||
        project.docsUrl != null;
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.projectName, required this.onBack});

  final String projectName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xxs,
        children: [
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: scheme.onSurfaceVariant,
            ),
            child: const Text('Projects'),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
          Text(
            projectName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final heroMedia = project.showcase?.heroMedia;
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (heroMedia != null) ...[
          _HeroMediaBanner(media: heroMedia),
          const SizedBox(height: AppSpacing.lg),
        ] else ...[
          AspectRatio(
            aspectRatio: 21 / 9,
            child: Material(
              color: scheme.surfaceContainerHighest,
              borderRadius: AppRadius.borderCard,
              child: Center(
                child: Icon(
                  Icons.layers_outlined,
                  size: 48,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (project.featured) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: 'Featured',
              tone: AppBadgeTone.featured,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          project.name,
          style: compact
              ? theme.textTheme.displaySmall
              : theme.textTheme.displayMedium,
        ),
        if (project.tagline != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            project.tagline!,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AppBadge(
              label: project.status.name,
              tone: statusTone(project.status),
            ),
            AppBadge(label: project.category.name),
            AppBadge(label: 'v${project.version}'),
            ...project.platforms.map((platform) => AppBadge(label: platform)),
          ],
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        if (project.demoUrl != null)
          _UrlAction(
            label: 'Try demo',
            url: project.demoUrl!,
            variant: AppButtonVariant.primary,
            icon: Icons.play_arrow_rounded,
          ),
        if (project.repositoryUrl != null)
          _UrlAction(
            label: 'GitHub',
            url: project.repositoryUrl!,
            variant: AppButtonVariant.secondary,
            icon: Icons.code_rounded,
          ),
        if (project.docsUrl != null)
          _UrlAction(
            label: 'Docs',
            url: project.docsUrl!,
            variant: AppButtonVariant.tonal,
            icon: Icons.menu_book_rounded,
          ),
      ],
    );
  }
}

class _HeroMediaBanner extends StatelessWidget {
  const _HeroMediaBanner({required this.media});

  final ShowcaseHeroMedia media;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = media.alt ??
        switch (media.kind) {
          ShowcaseHeroMediaKind.video => 'Hero video',
          ShowcaseHeroMediaKind.lottie => 'Hero animation',
          ShowcaseHeroMediaKind.image => 'Hero image',
        };

    return ClipRRect(
      borderRadius: AppRadius.borderCard,
      child: AspectRatio(
        aspectRatio: 21 / 9,
        child: ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: media.src != null && media.src!.isNotEmpty
              ? Image.asset(
                  media.src!,
                  fit: BoxFit.cover,
                  semanticLabel: label,
                  errorBuilder: (_, _, _) => _GalleryPlaceholder(
                    label: label,
                    icon: _heroKindIcon(media.kind),
                  ),
                )
              : _GalleryPlaceholder(
                  label: label,
                  icon: _heroKindIcon(media.kind),
                ),
        ),
      ),
    );
  }
}

IconData _heroKindIcon(ShowcaseHeroMediaKind kind) {
  return switch (kind) {
    ShowcaseHeroMediaKind.video => Icons.videocam_outlined,
    ShowcaseHeroMediaKind.lottie => Icons.auto_awesome_outlined,
    ShowcaseHeroMediaKind.image => Icons.image_outlined,
  };
}

IconData _featureIcon(String? key) {
  return switch (key) {
    'schema' || 'structure' => Icons.account_tree_outlined,
    'export' => Icons.ios_share_outlined,
    'workflow' => Icons.sync_alt_rounded,
    'platform' || 'devices' => Icons.devices_outlined,
    'search' => Icons.search_rounded,
    'security' => Icons.shield_outlined,
    'performance' => Icons.speed_outlined,
    'docs' => Icons.menu_book_outlined,
    _ => Icons.auto_awesome_outlined,
  };
}

IconData _mediaKindIcon(ShowcaseMediaKind kind) {
  return switch (kind) {
    ShowcaseMediaKind.video => Icons.videocam_outlined,
    ShowcaseMediaKind.diagram => Icons.schema_outlined,
    ShowcaseMediaKind.image => Icons.image_outlined,
  };
}

class _UrlAction extends StatelessWidget {
  const _UrlAction({
    required this.label,
    required this.url,
    required this.variant,
    this.icon,
  });

  final String label;
  final String url;
  final AppButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: url,
      child: AppButton(
        label: label,
        variant: variant,
        icon: icon,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(url)),
          );
        },
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({
    this.problem,
    this.solution,
    this.description,
  });

  final String? problem;
  final String? solution;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Overview',
          subtitle: 'What this product is and why it exists.',
        ),
        const SizedBox(height: AppSpacing.md),
        if (description != null) ...[
          Text(
            description!,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          if (problem != null || solution != null)
            const SizedBox(height: AppSpacing.md),
        ],
        if (problem != null || solution != null)
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < AppBreakpoints.compact;
              final problemCard = problem == null
                  ? null
                  : _OverviewCard(
                      title: 'Problem',
                      body: problem!,
                      scheme: scheme,
                      theme: theme,
                    );
              final solutionCard = solution == null
                  ? null
                  : _OverviewCard(
                      title: 'Solution',
                      body: solution!,
                      scheme: scheme,
                      theme: theme,
                    );

              if (stacked) {
                return Column(
                  children: [
                    ?problemCard,
                    if (problemCard != null && solutionCard != null)
                      const SizedBox(height: AppSpacing.sm),
                    ?solutionCard,
                  ],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (problemCard != null) Expanded(child: problemCard),
                    if (problemCard != null && solutionCard != null)
                      const SizedBox(width: AppSpacing.sm),
                    if (solutionCard != null) Expanded(child: solutionCard),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.body,
    required this.scheme,
    required this.theme,
  });

  final String title;
  final String body;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppSectionHeader(title: title, subtitle: body);
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.features});

  final List<ShowcaseFeature> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Features',
          subtitle: 'Capabilities that define this product.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 240,
          children: [
            for (final feature in features)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _featureIcon(feature.icon),
                      color: scheme.primary,
                      size: 24,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(feature.title, style: theme.textTheme.titleLarge),
                    if (feature.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        feature.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (feature.media != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: ClipRRect(
                          borderRadius: AppRadius.borderMd,
                          child: ColoredBox(
                            color: scheme.surfaceContainerHighest,
                            child: feature.media!.src != null &&
                                    feature.media!.src!.isNotEmpty
                                ? Image.asset(
                                    feature.media!.src!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        _GalleryPlaceholder(
                                      label: feature.media!.alt,
                                      icon: _mediaKindIcon(feature.media!.kind),
                                    ),
                                  )
                                : _GalleryPlaceholder(
                                    label: feature.media!.alt,
                                    icon: _mediaKindIcon(feature.media!.kind),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({required this.project, this.demo});

  final Project project;
  final ShowcaseDemo? demo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final available = demo?.available == true ||
        (demo?.url != null && demo!.url!.isNotEmpty) ||
        project.demoUrl != null;
    final url = demo?.url ?? project.demoUrl;
    final note = demo?.note ??
        (available
            ? null
            : 'Interactive demo is not available yet for this project.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Demo'),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                available ? 'Demo available' : 'Coming soon',
                style: theme.textTheme.titleLarge,
              ),
              if (note != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  note,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (url != null) ...[
                const SizedBox(height: AppSpacing.sm),
                SelectableText(
                  url,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
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

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.items});

  final List<ShowcaseMediaItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Gallery',
          subtitle: 'Screenshots and visuals from the product.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 220,
          children: [
            for (final item in items)
              AppCard(
                clipChild: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: item.src != null && item.src!.isNotEmpty
                            ? Image.asset(
                                item.src!,
                                fit: BoxFit.cover,
                                semanticLabel: item.alt,
                                errorBuilder: (_, _, _) => _GalleryPlaceholder(
                                  label: item.alt,
                                  icon: _mediaKindIcon(item.kind),
                                ),
                              )
                            : _GalleryPlaceholder(
                                label: item.alt,
                                icon: _mediaKindIcon(item.kind),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Text(
                        item.caption ?? item.alt,
                        style: theme.textTheme.bodyMedium,
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

class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder({
    required this.label,
    this.icon = Icons.image_outlined,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: scheme.onSurfaceVariant, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureSection extends StatelessWidget {
  const _ArchitectureSection({this.body, this.diagram});

  final String? body;
  final ShowcaseMediaItem? diagram;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title: 'Architecture',
          subtitle: body,
        ),
        if (diagram != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppCard(
            clipChild: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: diagram!.src != null && diagram!.src!.isNotEmpty
                        ? Image.asset(
                            diagram!.src!,
                            fit: BoxFit.contain,
                            semanticLabel: diagram!.alt,
                            errorBuilder: (_, _, _) => _GalleryPlaceholder(
                              label: diagram!.alt,
                              icon: Icons.schema_outlined,
                            ),
                          )
                        : _GalleryPlaceholder(
                            label: diagram!.alt,
                            icon: Icons.schema_outlined,
                          ),
                  ),
                ),
                if (diagram!.caption != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Text(
                      diagram!.caption!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TechnologiesSection extends StatelessWidget {
  const _TechnologiesSection({required this.technologies});

  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Stack'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final tech in technologies) AppBadge(label: tech),
          ],
        ),
      ],
    );
  }
}

class _PlatformSupportSection extends StatelessWidget {
  const _PlatformSupportSection({required this.items});

  final List<ShowcasePlatformSupport> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Platforms'),
        const SizedBox(height: AppSpacing.sm),
        AppGrid(
          minTileWidth: 200,
          children: [
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.platform, style: theme.textTheme.titleMedium),
                    if (item.notes != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.notes!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DocumentationSection extends StatelessWidget {
  const _DocumentationSection({required this.links});

  final List<ShowcaseLink> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Documentation'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final link in links)
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(link.label, style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    SelectableText(
                      link.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
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

class _BenchmarksSection extends StatelessWidget {
  const _BenchmarksSection({required this.benchmarks});

  final List<ShowcaseBenchmark> benchmarks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Benchmarks',
          subtitle: 'Performance and quality targets.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 180,
          children: [
            for (final bench in benchmarks)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bench.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(bench.value, style: theme.textTheme.headlineMedium),
                    if (bench.note != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        bench.note!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _RoadmapSection extends StatelessWidget {
  const _RoadmapSection({required this.items});

  final List<ShowcaseRoadmapItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Roadmap'),
        const SizedBox(height: AppSpacing.sm),
        for (final item in items) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.55),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.status != null) ...[
                  AppBadge(
                    label: item.status!.label,
                    tone: switch (item.status!) {
                      ShowcaseRoadmapStatus.done => AppBadgeTone.success,
                      ShowcaseRoadmapStatus.inProgress => AppBadgeTone.info,
                      ShowcaseRoadmapStatus.planned => AppBadgeTone.neutral,
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(item.item, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ChangelogSection extends StatelessWidget {
  const _ChangelogSection({required this.entries});

  final List<ShowcaseChangelogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Changelog'),
        const SizedBox(height: AppSpacing.sm),
        for (final entry in entries) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppBadge(
                      label: 'v${entry.version}',
                      tone: AppBadgeTone.primary,
                    ),
                    if (entry.date != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        entry.date!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(entry.notes, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ContributorsSection extends StatelessWidget {
  const _ContributorsSection({required this.contributors});

  final List<ShowcaseContributor> contributors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Contributors'),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 200,
          children: [
            for (final person in contributors)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: scheme.surfaceContainerHighest,
                          child: Text(
                            person.name.isNotEmpty
                                ? person.name[0].toUpperCase()
                                : '?',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            person.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    if (person.role != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        person.role!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (person.url != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      SelectableText(
                        person.url!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DownloadsSection extends StatelessWidget {
  const _DownloadsSection({required this.downloads});

  final List<ShowcaseDownload> downloads;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(title: 'Downloads'),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          minTileWidth: 220,
          children: [
            for (final item in downloads)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: theme.textTheme.titleLarge),
                    if (item.platform != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      AppBadge(label: item.platform!),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    SelectableText(
                      item.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    if (item.checksum != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        item.checksum!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _RelatedSection extends StatelessWidget {
  const _RelatedSection({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Related projects',
          subtitle: 'Other products from the same registry.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppGrid(
          children: [
            for (final project in projects) ProjectCard(project: project),
          ],
        ),
      ],
    );
  }
}
