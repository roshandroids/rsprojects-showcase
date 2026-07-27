/// Home feature tests.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/home/presentation/home_screen.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';

class _FakeRepo implements ProjectRepository {
  @override
  Future<List<Project>> fetchProjects() async => const [
        Project(
          id: 'document_platform',
          name: 'Document Platform',
          description: 'Living docs',
          version: '0.9.0',
          status: ProjectStatus.beta,
          category: ProjectCategory.platform,
          platforms: ['web'],
          featured: true,
        ),
      ];

  @override
  Future<Project?> fetchById(String id) async => null;
}

void main() {
  testWidgets('home hero CTA navigates to projects', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.projects,
          builder: (context, state) => const Scaffold(
            body: Text('Projects destination'),
          ),
        ),
        GoRoute(
          path: AppRoutes.about,
          builder: (context, state) => const Scaffold(body: Text('About')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('RSProjects'), findsWidgets);
    expect(find.text('Explore projects'), findsOneWidget);

    await tester.tap(find.text('Explore projects'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Projects destination'), findsOneWidget);
  });

  testWidgets('home shows featured project from registry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: HomeScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Document Platform'), findsOneWidget);
    expect(find.text('Spotlight projects'), findsOneWidget);
  });
}
