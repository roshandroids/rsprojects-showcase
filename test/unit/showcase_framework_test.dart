/// Unit tests for showcase metadata validation and mapping.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/content/content_schema.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/infrastructure/projects_infrastructure.dart';

void main() {
  group('validateShowcaseMetadata', () {
    test('accepts well-formed showcase object', () {
      final errors = validateShowcaseMetadata({
        'problem': 'A problem',
        'features': [
          {'title': 'Feature A', 'description': 'Desc'},
        ],
        'roadmap': [
          {'item': 'Ship demo', 'status': 'planned'},
        ],
        'relatedProjectIds': ['ai_tray'],
      });
      expect(errors, isEmpty);
    });

    test('rejects invalid roadmap status and feature shape', () {
      final errors = validateShowcaseMetadata({
        'features': [
          {'description': 'missing title'},
        ],
        'roadmap': [
          {'item': 'X', 'status': 'maybe'},
        ],
      });
      expect(errors.any((e) => e.contains('features')), isTrue);
      expect(errors.any((e) => e.contains('roadmap')), isTrue);
    });
  });

  group('ProjectShowcaseDto', () {
    test('maps nested showcase into domain', () {
      final project = ProjectDto.fromJson({
        'id': 'document_platform',
        'name': 'Document Platform',
        'description': 'Docs',
        'version': '0.9.0',
        'status': 'beta',
        'category': 'platform',
        'platforms': ['web'],
        'featured': true,
        'showcase': {
          'problem': 'Docs drift',
          'features': [
            {'title': 'Schemas', 'description': 'Typed models'},
          ],
          'demo': {'available': false, 'note': 'Soon'},
          'technologies': ['Flutter'],
          'relatedProjectIds': ['ai_tray'],
          'roadmap': [
            {'item': 'Demo', 'status': 'planned'},
          ],
        },
      }).toDomain();

      expect(project.showcase, isNotNull);
      expect(project.showcase!.problem, 'Docs drift');
      expect(project.showcase!.features, hasLength(1));
      expect(project.showcase!.features.first.title, 'Schemas');
      expect(project.showcase!.demo?.available, isFalse);
      expect(project.showcase!.technologies, ['Flutter']);
      expect(project.showcase!.relatedProjectIds, ['ai_tray']);
      expect(
        project.showcase!.roadmap.first.status,
        ShowcaseRoadmapStatus.planned,
      );
    });
  });

  group('resolveRelatedProjects', () {
    test('preserves declared order and skips missing ids', () {
      const catalog = [
        Project(
          id: 'a',
          name: 'A',
          description: 'A',
          version: '1',
          status: ProjectStatus.active,
          category: ProjectCategory.tool,
          platforms: ['web'],
          featured: false,
        ),
        Project(
          id: 'b',
          name: 'B',
          description: 'B',
          version: '1',
          status: ProjectStatus.active,
          category: ProjectCategory.tool,
          platforms: ['web'],
          featured: false,
        ),
      ];
      final related = resolveRelatedProjects(catalog, ['b', 'missing', 'a']);
      expect(related.map((p) => p.id), ['b', 'a']);
    });
  });
}
