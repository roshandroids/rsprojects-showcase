/// Unit tests for filesystem-derived playground status.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/content/playground_status.dart';

void main() {
  late Directory tempRoot;

  setUp(() {
    tempRoot = Directory.systemTemp.createTempSync('playground_status_test');
  });

  tearDown(() {
    tempRoot.deleteSync(recursive: true);
  });

  test('reports pending when generated/<id>/ does not exist', () {
    final result = resolvePlaygroundStatus(
      generatedRoot: tempRoot,
      playgroundId: 'document-platform',
    );
    expect(result.status, 'pending');
    expect(result.version, isNull);
    expect(result.commit, isNull);
    expect(result.deployedAt, isNull);
  });

  test('reports pending when the directory exists but has no index.html', () {
    Directory('${tempRoot.path}/document-platform').createSync();
    final result = resolvePlaygroundStatus(
      generatedRoot: tempRoot,
      playgroundId: 'document-platform',
    );
    expect(result.status, 'pending');
  });

  test('reports deployed with no metadata when only index.html exists', () {
    final dir = Directory('${tempRoot.path}/document-platform')..createSync();
    File('${dir.path}/index.html').writeAsStringSync('<html></html>');

    final result = resolvePlaygroundStatus(
      generatedRoot: tempRoot,
      playgroundId: 'document-platform',
    );
    expect(result.status, 'deployed');
    expect(result.version, isNull);
  });

  test(
    'reports deployed with version/commit/deployedAt from showcase.json',
    () {
      final dir = Directory('${tempRoot.path}/document-platform')..createSync();
      File('${dir.path}/index.html').writeAsStringSync('<html></html>');
      File('${dir.path}/showcase.json').writeAsStringSync(
        jsonEncode({
          'id': 'document-platform',
          'version': '1.2.0',
          'commit': 'abc1234',
          'deployedAt': '2026-08-21T12:00:00Z',
        }),
      );

      final result = resolvePlaygroundStatus(
        generatedRoot: tempRoot,
        playgroundId: 'document-platform',
      );
      expect(result.status, 'deployed');
      expect(result.version, '1.2.0');
      expect(result.commit, 'abc1234');
      expect(result.deployedAt, '2026-08-21T12:00:00Z');
    },
  );

  test('does not leak one playground into another (isolation)', () {
    final a = Directory('${tempRoot.path}/document-platform')..createSync();
    File('${a.path}/index.html').writeAsStringSync('<html></html>');
    // 'hcm-requisitions' deliberately has no index.html.
    Directory('${tempRoot.path}/hcm-requisitions').createSync();

    expect(
      resolvePlaygroundStatus(
        generatedRoot: tempRoot,
        playgroundId: 'document-platform',
      ).status,
      'deployed',
    );
    expect(
      resolvePlaygroundStatus(
        generatedRoot: tempRoot,
        playgroundId: 'hcm-requisitions',
      ).status,
      'pending',
    );
  });

  test('deployed despite malformed showcase.json (still a real artifact)', () {
    final dir = Directory('${tempRoot.path}/document-platform')..createSync();
    File('${dir.path}/index.html').writeAsStringSync('<html></html>');
    File('${dir.path}/showcase.json').writeAsStringSync('{not json');

    final result = resolvePlaygroundStatus(
      generatedRoot: tempRoot,
      playgroundId: 'document-platform',
    );
    expect(result.status, 'deployed');
    expect(result.version, isNull);
  });
}
