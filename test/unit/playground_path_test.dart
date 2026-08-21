/// Unit tests for the playground demoPath -> site-path join.
///
/// This is the exact join that produced the original bug report: a
/// leading-slash demoPath resolved naively against `Uri.base` drops the
/// GitHub Pages repo segment. Assert against the literal expected string,
/// not just "resolves without throwing".
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/shared/playground/playground_path.dart';

void main() {
  test('joins demoPath onto the fixed Pages base path', () {
    expect(
      buildPlaygroundAbsolutePath('/generated/document-platform/'),
      '/rsprojects-showcase/generated/document-platform/',
    );
  });

  test('resolves correctly regardless of current route depth', () {
    final atRoot = Uri.parse(
      'https://roshandroids.github.io/rsprojects-showcase/',
    );
    final deepRoute = Uri.parse(
      'https://roshandroids.github.io/rsprojects-showcase/projects/document-platform',
    );

    for (final base in [atRoot, deepRoute]) {
      final resolved = resolvePlaygroundUri(
        base,
        '/generated/document-platform/',
      );
      expect(
        resolved.toString(),
        'https://roshandroids.github.io/rsprojects-showcase/generated/document-platform/',
      );
    }
  });
}
