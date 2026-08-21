/// Unit tests for project DTO mapping and query helpers.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/infrastructure/projects_infrastructure.dart';

void main() {
  group('ProjectDto', () {
    test('maps JSON to domain entity', () {
      final project = ProjectDto.fromJson({
        'id': 'document_platform',
        'name': 'Document Platform',
        'description': 'Docs product',
        'version': '0.9.0',
        'status': 'beta',
        'category': 'platform',
        'platforms': ['web', 'macos'],
        'featured': true,
        'tagline': 'Living docs',
        'tags': ['documentation'],
      }).toDomain();

      expect(project.id, 'document_platform');
      expect(project.status, ProjectStatus.beta);
      expect(project.category, ProjectCategory.platform);
      expect(project.featured, isTrue);
      expect(project.platforms, ['web', 'macos']);
      expect(project.tagline, 'Living docs');
    });

    test('maps a playground block, generator fields included', () {
      final project = ProjectDto.fromJson({
        'id': 'document_platform',
        'name': 'Document Platform',
        'description': 'Docs product',
        'version': '0.9.0',
        'status': 'beta',
        'category': 'platform',
        'platforms': ['web'],
        'featured': true,
        'playground': {
          'enabled': true,
          'id': 'document-platform',
          'demoPath': '/generated/document-platform/',
          'status': 'deployed',
          'version': '1.2.0',
          'commit': 'abc1234',
          'deployedAt': '2026-08-21T12:00:00Z',
        },
      }).toDomain();

      expect(project.playground, isNotNull);
      expect(project.playground!.enabled, isTrue);
      expect(project.playground!.id, 'document-platform');
      expect(project.playground!.demoPath, '/generated/document-platform/');
      expect(project.playground!.isDeployed, isTrue);
      expect(project.playground!.version, '1.2.0');
    });

    test('leaves playground null when absent', () {
      final project = ProjectDto.fromJson({
        'id': 'x',
        'name': 'X',
        'description': 'd',
        'version': '1.0.0',
        'status': 'active',
        'category': 'tool',
        'platforms': ['web'],
        'featured': false,
      }).toDomain();

      expect(project.playground, isNull);
    });

    test('a pending playground reports isDeployed false', () {
      final project = ProjectDto.fromJson({
        'id': 'x',
        'name': 'X',
        'description': 'd',
        'version': '1.0.0',
        'status': 'active',
        'category': 'tool',
        'platforms': ['web'],
        'featured': false,
        'playground': {
          'enabled': true,
          'id': 'x',
          'demoPath': '/generated/x/',
          'status': 'pending',
        },
      }).toDomain();

      expect(project.playground!.isDeployed, isFalse);
    });
  });

  group('applyProjectQuery', () {
    final projects = [
      const Project(
        id: 'a',
        name: 'Alpha Docs',
        description: 'Documentation tooling',
        version: '1.0.0',
        status: ProjectStatus.active,
        category: ProjectCategory.tool,
        platforms: ['web'],
        featured: false,
        tags: ['docs'],
      ),
      const Project(
        id: 'b',
        name: 'Beta Platform',
        description: 'Platform product',
        version: '0.9.0',
        status: ProjectStatus.beta,
        category: ProjectCategory.platform,
        platforms: ['macos', 'windows'],
        featured: true,
        tagline: 'Featured first',
      ),
    ];

    test('filters by search text', () {
      final result = applyProjectQuery(
        projects,
        const ProjectQuery(search: 'alpha'),
      );
      expect(result.map((p) => p.id), ['a']);
    });

    test('filters by status, category, platform', () {
      final result = applyProjectQuery(
        projects,
        const ProjectQuery(
          status: ProjectStatus.beta,
          category: ProjectCategory.platform,
          platform: 'macos',
        ),
      );
      expect(result.map((p) => p.id), ['b']);
    });

    test('sorts featured first', () {
      final result = applyProjectQuery(
        projects,
        const ProjectQuery(sort: ProjectSort.featuredFirst),
      );
      expect(result.first.id, 'b');
    });
  });
}
