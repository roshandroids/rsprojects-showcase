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

    test('accepts Phase 2.1 rich media fields', () {
      final errors = validateShowcaseMetadata({
        'heroMedia': {'kind': 'image', 'alt': 'Hero'},
        'media': [
          {'kind': 'diagram', 'alt': 'Pipeline'},
          {'kind': 'video', 'alt': 'Walkthrough'},
        ],
        'features': [
          {
            'title': 'Schemas',
            'icon': 'schema',
            'media': {'kind': 'image', 'alt': 'Feature visual'},
          },
        ],
        'architectureDiagram': {
          'kind': 'diagram',
          'alt': 'Layers',
        },
        'contributors': [
          {'name': 'Roshan', 'role': 'Maintainer'},
        ],
        'downloads': [
          {
            'label': 'Source',
            'url': 'https://example.com',
            'platform': 'all',
          },
        ],
      });
      expect(errors, isEmpty);
    });

    test('rejects invalid media and hero kinds', () {
      final errors = validateShowcaseMetadata({
        'heroMedia': {'kind': 'gif'},
        'media': [
          {'kind': 'pdf', 'alt': 'Bad'},
        ],
        'contributors': [
          {'role': 'missing name'},
        ],
        'downloads': [
          {'label': 'No URL'},
        ],
      });
      expect(errors.any((e) => e.contains('heroMedia')), isTrue);
      expect(errors.any((e) => e.contains('media')), isTrue);
      expect(errors.any((e) => e.contains('contributors')), isTrue);
      expect(errors.any((e) => e.contains('downloads')), isTrue);
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

    test('maps Phase 2.1 rich fields and gallery fallback', () {
      final rich = ProjectDto.fromJson({
        'id': 'document_platform',
        'name': 'Document Platform',
        'description': 'Docs',
        'version': '0.9.0',
        'status': 'beta',
        'category': 'platform',
        'platforms': ['web'],
        'featured': true,
        'showcase': {
          'heroMedia': {'kind': 'image', 'alt': 'Hero'},
          'features': [
            {
              'title': 'Schemas',
              'icon': 'schema',
              'media': {'kind': 'image', 'alt': 'Schema visual'},
            },
          ],
          'media': [
            {'kind': 'video', 'alt': 'Walkthrough'},
          ],
          'architectureDiagram': {
            'kind': 'diagram',
            'alt': 'Layers',
          },
          'contributors': [
            {'name': 'Roshan', 'role': 'Maintainer'},
          ],
          'downloads': [
            {
              'label': 'Source',
              'url': 'https://example.com',
            },
          ],
        },
      }).toDomain().showcase!;

      expect(rich.heroMedia?.kind, ShowcaseHeroMediaKind.image);
      expect(rich.features.first.icon, 'schema');
      expect(rich.features.first.media?.kind, ShowcaseMediaKind.image);
      expect(rich.galleryItems, hasLength(1));
      expect(rich.galleryItems.first.kind, ShowcaseMediaKind.video);
      expect(rich.architectureDiagram?.kind, ShowcaseMediaKind.diagram);
      expect(rich.contributors.first.name, 'Roshan');
      expect(rich.downloads.first.label, 'Source');

      final legacy = ProjectDto.fromJson({
        'id': 'legacy',
        'name': 'Legacy',
        'description': 'Docs',
        'version': '0.1.0',
        'status': 'beta',
        'category': 'tool',
        'platforms': ['web'],
        'featured': false,
        'showcase': {
          'screenshots': [
            {'alt': 'Shot A', 'caption': 'Legacy gallery'},
          ],
        },
      }).toDomain().showcase!;

      expect(legacy.galleryItems, hasLength(1));
      expect(legacy.galleryItems.first.alt, 'Shot A');
      expect(legacy.galleryItems.first.kind, ShowcaseMediaKind.image);
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
