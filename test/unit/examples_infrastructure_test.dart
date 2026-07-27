/// Unit tests for example metadata validation and DemoSpec mapping.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/content/content_schema.dart';
import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

void main() {
  group('validateExampleMetadata', () {
    Map<String, Object?> valid({String id = 'product-brief-template'}) => {
          'id': id,
          'title': 'Product brief template',
          'description': 'Starter schema',
          'projectId': 'document_platform',
          'category': 'template',
        };

    test('accepts complete valid example metadata', () {
      expect(
        validateExampleMetadata(
          valid(),
          expectedId: 'product-brief-template',
          knownProjectIds: {'document_platform'},
        ),
        isEmpty,
      );
    });

    test('rejects unknown projectId', () {
      final errors = validateExampleMetadata(
        valid(),
        knownProjectIds: {'ai_tray'},
      );
      expect(errors.any((e) => e.contains('projectId')), isTrue);
    });

    test('rejects invalid category and folder mismatch', () {
      final errors = validateExampleMetadata(
        {
          ...valid(id: 'wrong'),
          'category': 'not-a-category',
        },
        expectedId: 'product-brief-template',
        knownProjectIds: {'document_platform'},
      );
      expect(errors.any((e) => e.contains('category')), isTrue);
      expect(errors.any((e) => e.contains('does not match folder')), isTrue);
    });

    test('validates demo.kind when present', () {
      final errors = validateExampleMetadata(
        {
          ...valid(),
          'demo': {'kind': 'iframe'},
        },
        knownProjectIds: {'document_platform'},
      );
      expect(errors.any((e) => e.contains('demo.kind')), isTrue);
    });
  });

  group('DemoSpec.fromMetadata', () {
    test('maps embedded_web', () {
      final spec = DemoSpec.fromMetadata(
        demo: {'kind': 'embedded_web', 'embedUrl': 'https://example.com/embed'},
      );
      expect(spec, isA<DemoEmbeddedWeb>());
      expect((spec as DemoEmbeddedWeb).embedUrl, 'https://example.com/embed');
    });

    test('maps external', () {
      final spec = DemoSpec.fromMetadata(
        demo: {'kind': 'external', 'url': 'https://example.com/demo'},
      );
      expect(spec, isA<DemoExternalLink>());
    });

    test('maps media fallback from media list', () {
      final spec = DemoSpec.fromMetadata(
        demo: {'kind': 'media'},
        media: const [
          DemoMediaRef(alt: 'Preview', caption: 'Flow'),
        ],
      );
      expect(spec, isA<DemoMediaFallback>());
      expect((spec as DemoMediaFallback).media, hasLength(1));
    });

    test('maps unavailable when available is false', () {
      final spec = DemoSpec.fromMetadata(
        demo: {'available': false, 'note': 'Soon'},
      );
      expect(spec, isA<DemoUnavailable>());
      expect((spec as DemoUnavailable).note, 'Soon');
    });

    test('falls back to demoUrl as external link', () {
      final spec = DemoSpec.fromMetadata(
        demoUrl: 'https://example.com/live',
      );
      expect(spec, isA<DemoExternalLink>());
    });
  });

  group('examplesForProject', () {
    const examples = [
      ProjectExample(
        id: 'a',
        title: 'A',
        description: 'A desc',
        projectId: 'document_platform',
        category: ExampleCategory.template,
      ),
      ProjectExample(
        id: 'b',
        title: 'B',
        description: 'B desc',
        projectId: 'localization_analyzer',
        category: ExampleCategory.sample,
      ),
      ProjectExample(
        id: 'c',
        title: 'C',
        description: 'C desc',
        projectId: 'document_platform',
        category: ExampleCategory.sample,
        featured: true,
      ),
    ];

    test('filters by projectId and prefers featured', () {
      final filtered = examplesForProject(examples, 'document_platform');
      expect(filtered.map((e) => e.id), ['c', 'a']);
    });

    test('returns empty for unknown project', () {
      expect(examplesForProject(examples, 'missing'), isEmpty);
    });
  });
}
