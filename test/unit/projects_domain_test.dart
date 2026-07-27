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
