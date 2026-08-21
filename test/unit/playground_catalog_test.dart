/// Unit tests for playground catalog merge, paths, and metadata validation.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/content/content_schema.dart';
import 'package:rsprojects_showcase/core/content/playground_artifact.dart';
import 'package:rsprojects_showcase/core/content/playground_catalog.dart';
import 'package:rsprojects_showcase/core/content/playground_paths.dart';
import 'package:rsprojects_showcase/core/content/showcase_contract.dart';
import 'package:rsprojects_showcase/features/projects/infrastructure/projects_infrastructure.dart';

import '../../scripts/playground_io.dart';

void main() {
  group('playground paths', () {
    test('maps snake project ids to kebab playground ids', () {
      expect(
        playgroundIdFromProjectId('document_platform'),
        'document-platform',
      );
      expect(isValidPlaygroundId('document-platform'), isTrue);
      expect(isValidPlaygroundId('document_platform'), isFalse);
      expect(isValidPlaygroundId('../etc'), isFalse);
    });

    test('accepts locked kebab ids and rejects invalid ids', () {
      const valid = ['document-platform', 'hcm-requisitions', 'a', 'a1'];
      const invalid = [
        'DocumentPlatform',
        'document_platform',
        'document/platform',
        '../document-platform',
        '.git',
        '.github',
        '',
        '-leading',
        'trailing-',
      ];
      for (final id in valid) {
        expect(isValidPlaygroundId(id), isTrue, reason: id);
      }
      for (final id in invalid) {
        expect(isValidPlaygroundId(id), isFalse, reason: id);
      }
    });

    test('canonical base href is /rsprojects-showcase/generated/<id>/', () {
      expect(
        canonicalPlaygroundBaseHref('document-platform'),
        '/rsprojects-showcase/generated/document-platform/',
      );
      expect(
        canonicalGeneratedPath('document-platform'),
        'generated/document-platform',
      );
    });

    test('resolves site-relative demo paths under Pages prefix', () {
      expect(
        resolvePlaygroundUrl(
          '/generated/document-platform/',
          pagesBaseHref: '/rsprojects-showcase/',
        ),
        '/rsprojects-showcase/generated/document-platform/',
      );
      expect(
        resolvePlaygroundUrl('https://example.com/live'),
        'https://example.com/live',
      );
    });

    test('public URL uses owner/repo/generated/<id>/', () {
      expect(
        playgroundPublicUrl(
          owner: 'roshandroids',
          repository: 'rsprojects-showcase',
          playgroundId: 'hcm-requisitions',
        ),
        'https://roshandroids.github.io/rsprojects-showcase'
        '/generated/hcm-requisitions/',
      );
    });

    test('path isolation rejects sibling generated directories', () {
      expect(
        isPathInsidePlayground(
          playgroundId: 'document-platform',
          candidate: 'generated/document-platform/index.html',
        ),
        isTrue,
      );
      expect(
        isPathInsidePlayground(
          playgroundId: 'document-platform',
          candidate: 'generated/hcm-requisitions/index.html',
        ),
        isFalse,
      );
    });
  });

  group('playground metadata validation', () {
    test('accepts valid project playground object', () {
      expect(
        validateProjectPlaygroundMetadata({
          'enabled': true,
          'id': 'document-platform',
          'demoPath': '/generated/document-platform/',
          'status': 'pending',
        }, projectId: 'document_platform'),
        isEmpty,
      );
    });

    test('rejects malformed playground metadata', () {
      final errors = validateProjectPlaygroundMetadata({
        'enabled': 'yes',
        'id': 'Not Valid',
        'demoPath': '/demos/other/',
        'status': 'shipping',
      });
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('enabled')), isTrue);
      expect(errors.any((e) => e.contains('kebab-case')), isTrue);
      expect(errors.any((e) => e.contains('generated/')), isTrue);
      expect(errors.any((e) => e.contains('status')), isTrue);
    });

    test('rejects malformed catalog entries', () {
      final errors = validatePlaygroundCatalogMetadata({
        'id': '',
        'name': '',
        'demoPath': '/nope',
        'status': 'live',
      });
      expect(errors, isNotEmpty);
    });

    test('rejects mismatched deployment manifest', () {
      final errors = validatePlaygroundDeploymentManifest({
        'id': 'hcm-requisitions',
        'version': '',
      }, expectedId: 'document-platform');
      expect(errors.any((e) => e.contains('does not match')), isTrue);
      expect(errors.any((e) => e.contains('version')), isTrue);
    });
  });

  group('playground catalog merge', () {
    AuthoredPlayground authored(String id, {String? projectId}) {
      return AuthoredPlayground(
        projectId: projectId ?? id.replaceAll('-', '_'),
        playgroundId: id,
        enabled: true,
        name: id,
        description: 'desc $id',
        category: 'library',
      );
    }

    test('loads multiple playgrounds independently', () {
      final catalog = mergePlaygroundCatalog(
        authored: [authored('document-platform'), authored('hcm-requisitions')],
        generated: const [
          GeneratedPlaygroundRecord(
            id: 'document-platform',
            hasIndexHtml: true,
            version: '1.2.0',
            commit: 'abc123',
            deployedAt: '2026-08-21T00:00:00Z',
          ),
        ],
      );

      expect(catalog, hasLength(2));
      final document = catalog.firstWhere((e) => e.id == 'document-platform');
      final hcm = catalog.firstWhere((e) => e.id == 'hcm-requisitions');
      expect(document.status, 'deployed');
      expect(document.version, '1.2.0');
      expect(document.commit, 'abc123');
      expect(document.canOpen, isTrue);
      expect(hcm.status, 'pending');
      expect(hcm.canOpen, isFalse);
    });

    test('adding one playground does not rewrite existing entries', () {
      final first = mergePlaygroundCatalog(
        authored: [authored('document-platform')],
        generated: const [
          GeneratedPlaygroundRecord(
            id: 'document-platform',
            hasIndexHtml: true,
            version: '1.0.0',
          ),
        ],
      );
      final second = mergePlaygroundCatalog(
        authored: [
          authored('document-platform'),
          authored('localization-analyzer'),
        ],
        generated: const [
          GeneratedPlaygroundRecord(
            id: 'document-platform',
            hasIndexHtml: true,
            version: '1.0.0',
          ),
          GeneratedPlaygroundRecord(
            id: 'localization-analyzer',
            hasIndexHtml: true,
            version: '0.9.0',
          ),
        ],
      );

      final original = first.single;
      final stillThere = second.firstWhere((e) => e.id == 'document-platform');
      expect(stillThere.version, original.version);
      expect(stillThere.demoPath, original.demoPath);
      expect(second, hasLength(2));
    });

    test('missing generated artifact stays pending', () {
      final catalog = mergePlaygroundCatalog(
        authored: [authored('document-platform')],
        generated: const [],
      );
      expect(catalog.single.status, 'pending');
      expect(catalog.single.canOpen, isFalse);
    });

    test('orphan generated directory still appears', () {
      final catalog = mergePlaygroundCatalog(
        authored: const [],
        generated: const [
          GeneratedPlaygroundRecord(
            id: 'navigation-voice',
            hasIndexHtml: true,
            version: '2.0.0',
          ),
        ],
      );
      expect(catalog.single.id, 'navigation-voice');
      expect(catalog.single.status, 'deployed');
      expect(catalog.single.name, 'navigation-voice');
    });
  });

  group('showcase consumer config', () {
    test('enabled + valid id is valid', () {
      expect(
        validateShowcaseConsumerConfig(enabled: true, id: 'document-platform'),
        isEmpty,
      );
    });

    test('enabled + missing id is invalid', () {
      expect(
        validateShowcaseConsumerConfig(enabled: true, id: null),
        isNotEmpty,
      );
      expect(validateShowcaseConsumerConfig(enabled: true, id: ''), isNotEmpty);
    });

    test('disabled + no id is valid', () {
      expect(validateShowcaseConsumerConfig(enabled: false, id: null), isEmpty);
    });

    test('enabled + invalid id is invalid', () {
      expect(
        validateShowcaseConsumerConfig(enabled: true, id: 'document_platform'),
        isNotEmpty,
      );
    });
  });

  group('PlaygroundDto', () {
    test('maps registry playground JSON to domain', () {
      final playground = PlaygroundDto.fromJson({
        'id': 'document-platform',
        'projectId': 'document_platform',
        'name': 'Document Platform',
        'description': 'Editor playground',
        'category': 'platform',
        'demoPath': '/generated/document-platform/',
        'status': 'deployed',
        'version': '1.2.0',
        'commit': 'abc123',
        'deployedAt': '2026-08-21T12:00:00Z',
      }).toDomain();

      expect(playground.canOpen, isTrue);
      expect(playground.resolvedUrl, contains('generated/document-platform/'));
      expect(playground.version, '1.2.0');
    });
  });

  group('publishPlaygroundArtifact', () {
    late Directory root;
    late Directory sourceA;
    late Directory sourceB;

    void writeWebBuild(Directory dir, String marker) {
      dir.createSync(recursive: true);
      File('${dir.path}/index.html').writeAsStringSync('<html>$marker</html>');
      File('${dir.path}/flutter.js').writeAsStringSync('flutter');
      File('${dir.path}/main.dart.js').writeAsStringSync(marker);
      Directory('${dir.path}/assets').createSync();
    }

    setUp(() {
      root = Directory.systemTemp.createTempSync('showcase-');
      sourceA = Directory('${root.path}/web-a');
      sourceB = Directory('${root.path}/web-b');
      writeWebBuild(sourceA, 'a');
      writeWebBuild(sourceB, 'b');
    });

    tearDown(() {
      if (root.existsSync()) root.deleteSync(recursive: true);
    });

    test('publishes one id without deleting a sibling playground', () {
      publishPlaygroundArtifact(
        showcaseRoot: root,
        playgroundId: 'document-platform',
        sourceDir: sourceA,
        version: '1.0.0',
        commit: 'aaa',
        deployedAt: DateTime.utc(2026, 8, 21),
      );
      publishPlaygroundArtifact(
        showcaseRoot: root,
        playgroundId: 'hcm-requisitions',
        sourceDir: sourceB,
        version: '2.0.0',
        commit: 'bbb',
        deployedAt: DateTime.utc(2026, 8, 21),
      );

      expect(
        File(
          '${root.path}/generated/document-platform/index.html',
        ).existsSync(),
        isTrue,
      );
      expect(
        File('${root.path}/generated/hcm-requisitions/index.html').existsSync(),
        isTrue,
      );
      expect(
        File(
          '${root.path}/generated/document-platform/showcase.json',
        ).readAsStringSync(),
        contains('"id": "document-platform"'),
      );
      expect(
        File(
          '${root.path}/generated/document-platform/showcase.json',
        ).readAsStringSync(),
        contains('"version": "1.0.0"'),
      );

      File('${sourceA.path}/main.dart.js').writeAsStringSync('a-updated');
      publishPlaygroundArtifact(
        showcaseRoot: root,
        playgroundId: 'document-platform',
        sourceDir: sourceA,
        version: '1.1.0',
      );

      expect(
        File(
          '${root.path}/generated/hcm-requisitions/main.dart.js',
        ).readAsStringSync(),
        'b',
      );
      expect(
        File(
          '${root.path}/generated/document-platform/main.dart.js',
        ).readAsStringSync(),
        'a-updated',
      );
    });

    test('refuses source trees that contain lib/ or pubspec.yaml', () {
      File('${sourceA.path}/pubspec.yaml').writeAsStringSync('name: secret');
      expect(
        () => publishPlaygroundArtifact(
          showcaseRoot: root,
          playgroundId: 'document-platform',
          sourceDir: sourceA,
        ),
        throwsStateError,
      );
    });

    test('refuses artifacts without index.html', () {
      File('${sourceA.path}/index.html').deleteSync();
      expect(
        () => publishPlaygroundArtifact(
          showcaseRoot: root,
          playgroundId: 'document-platform',
          sourceDir: sourceA,
        ),
        throwsStateError,
      );
    });

    test(
      'Pages staging copies generated trees under build/web/generated',
      () async {
        publishPlaygroundArtifact(
          showcaseRoot: root,
          playgroundId: 'document-platform',
          sourceDir: sourceA,
          version: '1.2.0',
          commit: 'abc123',
        );
        publishPlaygroundArtifact(
          showcaseRoot: root,
          playgroundId: 'hcm-requisitions',
          sourceDir: sourceB,
          version: '9.9.9',
          commit: 'def456',
        );

        final web = Directory('${root.path}/site')..createSync();
        File(
          '${web.path}/index.html',
        ).writeAsStringSync('<html>showcase</html>');
        File('${web.path}/flutter.js').writeAsStringSync('js');
        Directory('${web.path}/assets').createSync();

        final result = await Process.run('dart', [
          'run',
          'scripts/publish.dart',
          '--web-build',
          web.path,
          '--generated',
          '${root.path}/generated',
        ]);
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
        expect(
          File(
            '${web.path}/generated/document-platform/showcase.json',
          ).existsSync(),
          isTrue,
        );
        expect(
          File(
            '${web.path}/generated/hcm-requisitions/index.html',
          ).existsSync(),
          isTrue,
        );
        expect(
          File('${web.path}/index.html').readAsStringSync(),
          contains('showcase'),
        );
      },
    );
  });
}
