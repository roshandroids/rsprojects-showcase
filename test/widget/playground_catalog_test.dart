/// Widget tests for playground catalog loading and missing playground UX.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/application/projects_application.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/projects_screen.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/playground_card.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_showcase_template.dart';

class _FakeRepo implements ProjectRepository {
  _FakeRepo({this.playgrounds = const []});

  final List<Project> projects = const [];
  final List<ProjectPlayground> playgrounds;

  @override
  Future<List<Project>> fetchProjects() async => projects;

  @override
  Future<Project?> fetchById(String id) async {
    for (final project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  @override
  Future<List<ProjectPlayground>> fetchPlaygrounds() async => playgrounds;
}

const _live = ProjectPlayground(
  id: 'document-platform',
  projectId: 'document_platform',
  name: 'Document Platform',
  description: 'Editor playground',
  category: 'platform',
  demoPath: '/generated/document-platform/',
  status: PlaygroundStatus.deployed,
  version: '1.2.0',
);

const _pending = ProjectPlayground(
  id: 'hcm-requisitions',
  projectId: 'hcm_requisitions',
  name: 'HCM Requisitions',
  description: 'Requisition playground',
  category: 'library',
  demoPath: '/generated/hcm-requisitions/',
  status: PlaygroundStatus.pending,
);

void main() {
  testWidgets('catalog loads multiple playgrounds', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectRepositoryProvider.overrideWithValue(
            _FakeRepo(playgrounds: const [_live, _pending]),
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

    expect(find.byType(PlaygroundCard), findsNWidgets(2));
    expect(find.text('Document Platform'), findsWidgets);
    expect(find.text('HCM Requisitions'), findsOneWidget);
    expect(find.text('Open Playground'), findsOneWidget);
    expect(find.text('Playground not deployed yet'), findsOneWidget);
  });

  testWidgets('missing playgrounds show empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [projectRepositoryProvider.overrideWithValue(_FakeRepo())],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProjectsScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('No playgrounds yet'), findsOneWidget);
    expect(find.byType(PlaygroundCard), findsNothing);
  });

  testWidgets('detail shows Open Playground when live', (tester) async {
    const project = Project(
      id: 'document_platform',
      name: 'Document Platform',
      description: 'Docs',
      version: '1.2.0',
      status: ProjectStatus.beta,
      category: ProjectCategory.platform,
      platforms: ['web'],
      featured: false,
      playground: _live,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProjectShowcaseTemplate(project: project),
          ),
        ),
      ),
    );

    expect(find.text('Open Playground'), findsWidgets);
  });
}
