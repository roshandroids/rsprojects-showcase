/// Generic project showcase page template — same layout for every RSProjects product.
///
/// Sections render only when content is available. No project-specific UI.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_card.dart';

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
    this.onBack,
  });

  final Project project;
  final List<Project> relatedProjects;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final showcase = project.showcase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Back to Projects',
          variant: AppButtonVariant.text,
          icon: Icons.arrow_back_rounded,
          onPressed: onBack ?? () => context.go(AppRoutes.projects),
        ),
        const SizedBox(height: AppSpacing.lg),
        _HeroSection(project: project),
        if (showcase?.problem != null)
          _TextSection(title: 'Problem Statement', body: showcase!.problem!),
        if (showcase?.solution != null)
          _TextSection(title: 'Solution Overview', body: showcase!.solution!),
        if (showcase != null && showcase.features.isNotEmpty)
          _FeaturesSection(features: showcase.features),
        _DemoSection(project: project, demo: showcase?.demo),
        if (showcase != null && showcase.screenshots.isNotEmpty)
          _GallerySection(screenshots: showcase.screenshots),
        if (showcase?.architecture != null)
          _TextSection(
            title: 'Architecture Overview',
            body: showcase!.architecture!,
          ),
        if (showcase != null && showcase.technologies.isNotEmpty)
          _TechnologiesSection(technologies: showcase.technologies),
        if (showcase != null && showcase.platformSupport.isNotEmpty)
          _PlatformSupportSection(items: showcase.platformSupport)
        else
          _PlatformSupportSection(
            items: [
              for (final platform in project.platforms)
                ShowcasePlatformSupport(platform: platform),
            ],
          ),
        if (showcase?.installation != null)
          _TextSection(title: 'Installation', body: showcase!.installation!),
        if (showcase != null && showcase.documentationLinks.isNotEmpty)
          _DocumentationSection(links: showcase.documentationLinks),
        if (showcase != null && showcase.examples.isNotEmpty)
          _ExamplesSection(examples: showcase.examples),
        if (showcase != null && showcase.benchmarks.isNotEmpty)
          _BenchmarksSection(benchmarks: showcase.benchmarks),
        if (showcase != null && showcase.roadmap.isNotEmpty)
          _RoadmapSection(items: showcase.roadmap),
        if (showcase != null && showcase.changelog.isNotEmpty)
          _ChangelogSection(entries: showcase.changelog),
        if (relatedProjects.isNotEmpty)
          _RelatedSection(projects: relatedProjects),
        if (showcase?.contributing != null)
          _TextSection(title: 'Contributing', body: showcase!.contributing!),
        if (project.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.section),
          AppSectionHeader(
            title: 'Tags',
            subtitle: project.tags.join(' · '),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (project.featured) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: 'Featured',
              tone: AppBadgeTone.featured,
              icon: Icons.star_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(project.name, style: theme.textTheme.displaySmall),
        if (project.tagline != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.tagline!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppBadge(
              label: project.status.name,
              tone: statusTone(project.status),
            ),
            AppBadge(
              label: project.category.name,
              tone: AppBadgeTone.primary,
            ),
            AppBadge(label: 'v${project.version}'),
            ...project.platforms.map((platform) => AppBadge(label: platform)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          project.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.84),
          ),
        ),
        if (_hasPrimaryActions(project)) ...[
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              if (project.demoUrl != null)
                _UrlAction(
                  label: 'Demo',
                  url: project.demoUrl!,
                  variant: AppButtonVariant.primary,
                  icon: Icons.play_circle_outline_rounded,
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
                  label: 'Documentation',
                  url: project.docsUrl!,
                  variant: AppButtonVariant.text,
                  icon: Icons.menu_book_rounded,
                ),
            ],
          ),
        ],
      ],
    );
  }

  bool _hasPrimaryActions(Project project) {
    return project.demoUrl != null ||
        project.repositoryUrl != null ||
        project.docsUrl != null;
  }
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
          // Phase 1.5: expose URL via snackbar until url_launcher is added.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(url)),
          );
        },
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: AppSectionHeader(title: title, subtitle: body),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.features});

  final List<ShowcaseFeature> features;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Key Features'),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            minTileWidth: 240,
            children: [
              for (final feature in features)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (feature.description != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          feature.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.72),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Interactive Demo'),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      available
                          ? Icons.play_circle_outline_rounded
                          : Icons.hourglass_empty_rounded,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      available ? 'Demo available' : 'Demo placeholder',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                if (note != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    note,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
                if (url != null) ...[
                  const SizedBox(height: AppSpacing.md),
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
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.screenshots});

  final List<ShowcaseScreenshot> screenshots;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Screenshots / Gallery'),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            minTileWidth: 220,
            children: [
              for (final shot in screenshots)
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: ColoredBox(
                          color: scheme.surfaceContainerHighest,
                          child: shot.src != null && shot.src!.isNotEmpty
                              ? Image.asset(
                                  shot.src!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _GalleryPlaceholder(
                                    label: shot.alt,
                                  ),
                                )
                              : _GalleryPlaceholder(label: shot.alt),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          shot.caption ?? shot.alt,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: scheme.primary, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _TechnologiesSection extends StatelessWidget {
  const _TechnologiesSection({required this.technologies});

  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Technologies Used'),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tech in technologies)
                AppBadge(label: tech, tone: AppBadgeTone.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformSupportSection extends StatelessWidget {
  const _PlatformSupportSection({required this.items});

  final List<ShowcasePlatformSupport> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Platform Support'),
          const SizedBox(height: AppSpacing.lg),
          AppGrid(
            minTileWidth: 200,
            children: [
              for (final item in items)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBadge(label: item.platform),
                      if (item.notes != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(item.notes!, style: theme.textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentationSection extends StatelessWidget {
  const _DocumentationSection({required this.links});

  final List<ShowcaseLink> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Documentation Links'),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              for (final link in links)
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(link.label, style: theme.textTheme.labelLarge),
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
      ),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection({required this.examples});

  final List<ShowcaseExample> examples;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Examples / Playground'),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            minTileWidth: 240,
            children: [
              for (final example in examples)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(example.title, style: theme.textTheme.titleMedium),
                      if (example.description != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          example.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                      if (example.url != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        SelectableText(
                          example.url!,
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
      ),
    );
  }
}

class _BenchmarksSection extends StatelessWidget {
  const _BenchmarksSection({required this.benchmarks});

  final List<ShowcaseBenchmark> benchmarks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Benchmarks'),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            minTileWidth: 180,
            children: [
              for (final bench in benchmarks)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bench.label, style: theme.textTheme.labelLarge),
                      const SizedBox(height: AppSpacing.xs),
                      Text(bench.value, style: theme.textTheme.headlineSmall),
                      if (bench.note != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(bench.note!, style: theme.textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoadmapSection extends StatelessWidget {
  const _RoadmapSection({required this.items});

  final List<ShowcaseRoadmapItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Roadmap'),
          const SizedBox(height: AppSpacing.lg),
          for (final item in items) ...[
            Row(
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
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Text(item.item, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(title: 'Changelog'),
          const SizedBox(height: AppSpacing.lg),
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
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          entry.date!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.56),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(entry.notes, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _RelatedSection extends StatelessWidget {
  const _RelatedSection({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSectionHeader(
            title: 'Related RSProjects',
            subtitle: 'Other products from the same registry.',
          ),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            children: [
              for (final project in projects) ProjectCard(project: project),
            ],
          ),
        ],
      ),
    );
  }
}
