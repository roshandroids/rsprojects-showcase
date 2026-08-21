/// Unit tests for content schema validation.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/content/content_schema.dart';

void main() {
  Map<String, Object?> valid({String id = 'document_platform'}) => {
    'id': id,
    'name': 'Document Platform',
    'description': 'A real description',
    'version': '0.9.0',
    'status': 'beta',
    'category': 'platform',
    'platforms': ['web', 'macos'],
    'featured': true,
  };

  test('accepts complete valid metadata', () {
    expect(validateProjectMetadata(valid()), isEmpty);
  });

  test('validates nested showcase when present', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'showcase': {
        'features': [
          {'description': 'no title'},
        ],
      },
    });
    expect(errors.any((e) => e.contains('showcase.features')), isTrue);
  });

  test('rejects missing required fields and bad enums', () {
    final errors = validateProjectMetadata({
      'id': '',
      'name': 'X',
      'status': 'unknown',
      'category': 'tool',
      'platforms': ['web'],
      'featured': true,
    });
    expect(errors, isNotEmpty);
    expect(
      errors.any((e) => e.contains('description') || e.contains('version')),
      isTrue,
    );
    expect(errors.any((e) => e.contains('status')), isTrue);
  });

  test('enforces folder id match', () {
    final errors = validateProjectMetadata(
      valid(id: 'wrong'),
      expectedId: 'document_platform',
    );
    expect(errors.any((e) => e.contains('does not match folder')), isTrue);
  });

  test('accepts soft-deprecated showcase.examples shape', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'showcase': {
        'examples': [
          {'title': 'Legacy list item'},
        ],
      },
    });
    expect(errors, isEmpty);
  });

  test('accepts integration provenance object', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'integration': {
        'projectId': 'document_platform',
        'source': 'project-cache',
      },
    });
    expect(errors, isEmpty);
  });

  test('accepts legacy integration.repositoryId and repository-cache', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'integration': {
        'repositoryId': 'document_platform',
        'source': 'repository-cache',
      },
    });
    expect(errors, isEmpty);
  });

  test('accepts optional playground metadata', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'playground': {
        'enabled': true,
        'id': 'document-platform',
        'demoPath': '/generated/document-platform/',
        'status': 'pending',
      },
    });
    expect(errors, isEmpty);
  });

  test('rejects invalid playground metadata on a project', () {
    final errors = validateProjectMetadata({
      ...valid(),
      'playground': {'enabled': true, 'id': 'not valid', 'status': 'nope'},
    });
    expect(errors.any((e) => e.contains('playground')), isTrue);
  });
}
