/// Widget tests for the generic project showcase template.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_showcase_template.dart';

const _project = Project(
  id: 'document_platform',
  name: 'Document Platform',
  tagline: 'Structured documents',
  description: 'Living docs for product teams.',
  version: '0.9.0',
  status: ProjectStatus.beta,
  category: ProjectCategory.platform,
  platforms: ['web', 'macos'],
  featured: true,
  repositoryUrl: 'https://github.com/example/docs',
  docsUrl: 'https://example.com/docs',
  showcase: ProjectShowcase(
    heroMedia: ShowcaseHeroMedia(
      kind: ShowcaseHeroMediaKind.image,
      alt: 'Document Platform hero',
    ),
    problem: 'Docs drift across tools.',
    solution: 'A shared content model and export pipeline.',
    features: [
      ShowcaseFeature(title: 'Structured schemas', icon: 'schema'),
    ],
    demo: ShowcaseDemo(
      available: false,
      note: 'Demo coming soon',
    ),
    media: [
      ShowcaseMediaItem(
        kind: ShowcaseMediaKind.diagram,
        alt: 'Pipeline diagram',
        caption: 'Author → publish',
      ),
    ],
    architecture: 'Content registry drives a generic template.',
    architectureDiagram: ShowcaseMediaItem(
      kind: ShowcaseMediaKind.diagram,
      alt: 'Architecture layers',
    ),
    technologies: ['Flutter', 'Dart'],
    roadmap: [
      ShowcaseRoadmapItem(
        item: 'Interactive demo',
        status: ShowcaseRoadmapStatus.planned,
      ),
    ],
    contributors: [
      ShowcaseContributor(name: 'Roshan Shrestha', role: 'Maintainer'),
    ],
    downloads: [
      ShowcaseDownload(
        label: 'Source',
        url: 'https://example.com/source',
        platform: 'all',
      ),
    ],
    contributing: 'PRs welcome.',
  ),
);

void main() {
  testWidgets('template shows hero and populated sections only', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.projectDetailPath('document_platform'),
      routes: [
        GoRoute(
          path: AppRoutes.projects,
          builder: (_, _) => const Scaffold(body: Text('Catalog')),
        ),
        GoRoute(
          path: '/projects/:id',
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(
              child: ProjectShowcaseTemplate(project: _project),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
    await tester.pump();

    expect(find.text('Document Platform'), findsOneWidget);
    expect(find.text('Structured documents'), findsOneWidget);
    expect(find.text('Document Platform hero'), findsOneWidget);
    expect(find.text('Problem Statement'), findsOneWidget);
    expect(find.text('Docs drift across tools.'), findsOneWidget);
    expect(find.text('Solution Overview'), findsOneWidget);
    expect(find.text('Key Features'), findsOneWidget);
    expect(find.text('Structured schemas'), findsOneWidget);
    expect(find.text('Interactive Demo'), findsOneWidget);
    expect(find.text('Demo coming soon'), findsOneWidget);
    expect(find.text('Screenshots / Gallery'), findsOneWidget);
    expect(find.text('Architecture Overview'), findsOneWidget);
    expect(find.text('Architecture layers'), findsOneWidget);
    expect(find.text('Technologies Used'), findsOneWidget);
    expect(find.text('Roadmap'), findsOneWidget);
    expect(find.text('Contributors'), findsOneWidget);
    expect(find.text('Roshan Shrestha'), findsOneWidget);
    expect(find.text('Downloads'), findsOneWidget);
    expect(find.text('Source'), findsOneWidget);
    expect(find.text('Contributing'), findsOneWidget);

    // Benchmarks / changelog omitted when empty.
    expect(find.text('Benchmarks'), findsNothing);
    expect(find.text('Changelog'), findsNothing);
  });

  testWidgets('omits optional sections when showcase is absent', (tester) async {
    const minimal = Project(
      id: 'minimal',
      name: 'Minimal',
      description: 'Bare catalog entry',
      version: '0.1.0',
      status: ProjectStatus.experimental,
      category: ProjectCategory.other,
      platforms: ['web'],
      featured: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProjectShowcaseTemplate(project: minimal),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Minimal'), findsOneWidget);
    expect(find.text('Problem Statement'), findsNothing);
    expect(find.text('Key Features'), findsNothing);
    expect(find.text('Interactive Demo'), findsOneWidget); // placeholder
    expect(find.text('Platform Support'), findsOneWidget); // from platforms[]
  });
}
