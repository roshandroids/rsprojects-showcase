/// Unit tests for staging `generated/<id>/` playgrounds into `build/web/`.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/build/stage_pages_artifact.dart';

void main() {
  late Directory tempRoot;
  late Directory generatedRoot;
  late Directory buildWebRoot;

  setUp(() {
    tempRoot = Directory.systemTemp.createTempSync('stage_pages_artifact_test');
    generatedRoot = Directory('${tempRoot.path}/generated')..createSync();
    buildWebRoot = Directory('${tempRoot.path}/build/web')
      ..createSync(recursive: true);
    File(
      '${buildWebRoot.path}/index.html',
    ).writeAsStringSync('<html>showcase</html>');
    File(
      '${buildWebRoot.path}/main.dart.js',
    ).writeAsStringSync('// showcase js');
  });

  tearDown(() {
    tempRoot.deleteSync(recursive: true);
  });

  void writePlayground(String id) {
    final dir = Directory('${generatedRoot.path}/$id')
      ..createSync(recursive: true);
    File('${dir.path}/index.html').writeAsStringSync('<html>$id</html>');
    Directory('${dir.path}/assets').createSync();
    File('${dir.path}/assets/main.dart.js').writeAsStringSync('// $id js');
  }

  test(
    'copies generated/<id>/index.html to build/web/generated/<id>/index.html',
    () {
      writePlayground('document-platform');

      stagePlaygroundsIntoBuild(
        generatedRoot: generatedRoot,
        buildWebRoot: buildWebRoot,
      );

      final copied = File(
        '${buildWebRoot.path}/generated/document-platform/index.html',
      );
      expect(copied.existsSync(), isTrue);
      expect(copied.readAsStringSync(), '<html>document-platform</html>');
      expect(
        File(
          '${buildWebRoot.path}/generated/document-platform/assets/main.dart.js',
        ).existsSync(),
        isTrue,
      );
    },
  );

  test('does not touch the showcase app\'s own build output', () {
    writePlayground('document-platform');

    stagePlaygroundsIntoBuild(
      generatedRoot: generatedRoot,
      buildWebRoot: buildWebRoot,
    );

    expect(
      File('${buildWebRoot.path}/index.html').readAsStringSync(),
      '<html>showcase</html>',
    );
    expect(
      File('${buildWebRoot.path}/main.dart.js').readAsStringSync(),
      '// showcase js',
    );
  });

  test('publishing one playground does not disturb a sibling (isolation)', () {
    writePlayground('document-platform');
    writePlayground('hcm-requisitions');

    stagePlaygroundsIntoBuild(
      generatedRoot: generatedRoot,
      buildWebRoot: buildWebRoot,
    );

    expect(
      File(
        '${buildWebRoot.path}/generated/document-platform/index.html',
      ).readAsStringSync(),
      '<html>document-platform</html>',
    );
    expect(
      File(
        '${buildWebRoot.path}/generated/hcm-requisitions/index.html',
      ).readAsStringSync(),
      '<html>hcm-requisitions</html>',
    );
  });

  test('skips non-directory entries under generated/ (e.g. README.md)', () {
    File('${generatedRoot.path}/README.md').writeAsStringSync('# generated');
    writePlayground('document-platform');

    stagePlaygroundsIntoBuild(
      generatedRoot: generatedRoot,
      buildWebRoot: buildWebRoot,
    );

    expect(
      File('${buildWebRoot.path}/generated/README.md').existsSync(),
      isFalse,
    );
    expect(Directory('${buildWebRoot.path}/generated').listSync().length, 1);
  });

  test('no-ops when generated/ does not exist', () {
    generatedRoot.deleteSync();

    expect(
      () => stagePlaygroundsIntoBuild(
        generatedRoot: generatedRoot,
        buildWebRoot: buildWebRoot,
      ),
      returnsNormally,
    );
    expect(Directory('${buildWebRoot.path}/generated').existsSync(), isFalse);
  });

  test('refuses to stage into a build directory with no index.html', () {
    final badBuild = Directory('${tempRoot.path}/not-a-build')..createSync();
    writePlayground('document-platform');

    expect(
      () => stagePlaygroundsIntoBuild(
        generatedRoot: generatedRoot,
        buildWebRoot: badBuild,
      ),
      throwsStateError,
    );
  });
}
