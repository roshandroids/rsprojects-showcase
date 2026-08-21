/// Stages the showcase Flutter Web build plus hosted playgrounds for Pages.
///
/// Usage:
/// ```sh
/// dart run scripts/publish.dart --web-build build/web --generated generated
/// ```
library;

import 'dart:io';

import 'package:rsprojects_showcase/core/content/playground_paths.dart';

Future<void> main(List<String> args) async {
  var webBuild = 'build/web';
  var generated = 'generated';

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--web-build' && i + 1 < args.length) {
      webBuild = args[++i];
    } else if (arg == '--generated' && i + 1 < args.length) {
      generated = args[++i];
    }
  }

  final webDir = Directory(webBuild);
  if (!webDir.existsSync()) {
    stderr.writeln(
      'Missing web build at $webBuild. Run flutter build web first.',
    );
    exitCode = 1;
    return;
  }

  final generatedDir = Directory(generated);
  final dest = Directory('$webBuild/generated');
  if (dest.existsSync()) {
    dest.deleteSync(recursive: true);
  }

  var copied = 0;
  if (generatedDir.existsSync()) {
    dest.createSync(recursive: true);
    for (final dir in generatedDir.listSync().whereType<Directory>()) {
      final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (!isValidPlaygroundId(id)) continue;
      if (!File('${dir.path}/index.html').existsSync()) continue;
      final target = Directory('${dest.path}/$id');
      _copyDir(dir, target);
      copied++;
    }
  }

  stdout.writeln(
    'Staged $copied playground(s) under $webBuild/generated for GitHub Pages.',
  );
}

void _copyDir(Directory from, Directory to) {
  to.createSync(recursive: true);
  for (final entity in from.listSync(recursive: true, followLinks: false)) {
    final relative = entity.path.substring(from.path.length);
    final destPath = '${to.path}$relative';
    if (entity is Directory) {
      Directory(destPath).createSync(recursive: true);
    } else if (entity is File) {
      File(destPath).parent.createSync(recursive: true);
      entity.copySync(destPath);
    }
  }
}
