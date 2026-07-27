/// Projects feature tests — catalog async states and project card.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/projects_screen.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_card.dart';

class _FakeRepo implements ProjectRepository {
  _FakeRepo(this._projects, {this.throwOnFetch = false});

  final List<Project> _projects;
  final bool throwOnFetch;

  @override
  Future<List<Project>> fetchProjects() async {
    if (throwOnFetch) {
      throw Exception('registry unavailable');
    }
    return _projects;
  }

  @override
  Future<Project?> fetchById(String id) async {
    for (final p in _projects) {
      if (p.id == id) return p;
    }
    return null;
  }
}

const _sample = Project(
  id: 'document_platform',
  name: 'Document Platform',
  description: 'Living docs',
  version: '0.9.0',
  status: ProjectStatus.beta,
  category: ProjectCategory.platform,
  platforms: ['web'],
  featured: true,
  tagline: 'Structured documents',
);

void main() {
  testWidgets('catalog shows loading then project cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(
            _FakeRepo(const [_sample]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProjectsScreen()),
        ),
      ),
    );

    expect(find.byType(AppLoadingState), findsOneWidget);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Document Platform'), findsOneWidget);
    expect(find.text('Featured'), findsWidgets);
  });

  testWidgets('catalog shows empty state when registry has no projects',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(_FakeRepo(const [])),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProjectsScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('No projects yet'), findsOneWidget);
  });

  testWidgets('catalog shows error state with retry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(
            _FakeRepo(const [], throwOnFetch: true),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProjectsScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Could not load projects'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('project card shows name and featured badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: ProjectCard(project: _sample),
        ),
      ),
    );
    expect(find.text('Document Platform'), findsOneWidget);
    expect(find.text('Featured'), findsOneWidget);
  });
}
