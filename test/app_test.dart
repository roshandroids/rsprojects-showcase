/// App-level smoke / navigation tests.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/app.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';

class _TestProjectRepository implements ProjectRepository {
  static const projects = [
    Project(
      id: 'document_platform',
      name: 'Document Platform',
      description: 'Living product documentation',
      version: '0.9.0',
      status: ProjectStatus.beta,
      category: ProjectCategory.platform,
      platforms: ['web'],
      featured: true,
      tagline: 'Structured documents',
    ),
  ];

  @override
  Future<List<Project>> fetchProjects() async => projects;

  @override
  Future<Project?> fetchById(String id) async {
    for (final project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }
}

Future<void> pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  GoRouter buildRouter() => createAppRouter();

  Widget buildApp(GoRouter router) {
    return ProviderScope(
      overrides: [
        projectRepositoryProvider.overrideWithValue(_TestProjectRepository()),
      ],
      child: RsProjectsShowcaseApp(router: router),
    );
  }

  testWidgets('app shell builds on home route', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await pumpFrames(tester);

    expect(find.textContaining('RSProjects'), findsWidgets);
    expect(find.text('Explore projects'), findsOneWidget);
  });

  testWidgets('top navigation reaches projects and about', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(buildApp(router));
    await pumpFrames(tester);

    router.go(AppRoutes.projects);
    await pumpFrames(tester);
    expect(router.state.uri.path, AppRoutes.projects);
    expect(find.textContaining('Browse RSProjects'), findsWidgets);

    router.go(AppRoutes.about);
    await pumpFrames(tester);
    expect(router.state.uri.path, AppRoutes.about);
    expect(find.textContaining('RSProjects'), findsWidgets);
  });

  testWidgets('unknown route shows 404 page', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(buildApp(router));
    await pumpFrames(tester);

    router.go('/does-not-exist');
    await pumpFrames(tester);

    expect(find.text('Page not found'), findsOneWidget);
  });

  testWidgets('project detail route loads registry project', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(buildApp(router));
    await pumpFrames(tester);

    router.go(AppRoutes.projectDetailPath('document_platform'));
    await pumpFrames(tester);

    expect(find.text('Document Platform'), findsOneWidget);
  });
}
