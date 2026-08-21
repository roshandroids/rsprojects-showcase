/// Stages a Flutter Web playground into `generated/<id>/`.
///
/// Usage:
/// ```sh
/// dart run scripts/publish_playground.dart \
///   --id document-platform \
///   --source path/to/build/web \
///   --version 1.2.0 \
///   --commit abc123
/// ```
library;

import 'dart:io';

import 'playground_io.dart';

Future<void> main(List<String> args) async {
  String? id;
  String? source;
  String? version;
  String? commit;
  var root = Directory.current.path;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    String next() {
      if (i + 1 >= args.length) {
        throw FormatException('Missing value for $arg');
      }
      return args[++i];
    }

    switch (arg) {
      case '--id':
        id = next();
      case '--source':
        source = next();
      case '--version':
        version = next();
      case '--commit':
        commit = next();
      case '--root':
        root = next();
      case '--help':
      case '-h':
        stdout.writeln(
          'Usage: dart run scripts/publish_playground.dart '
          '--id <kebab-id> --source <web-build-dir> '
          '[--version <semver>] [--commit <sha>] [--root <showcase-root>]',
        );
        return;
      default:
        stderr.writeln('Unknown argument: $arg');
        exitCode = 64;
        return;
    }
  }

  if (id == null || source == null) {
    stderr.writeln('Required: --id and --source');
    exitCode = 64;
    return;
  }

  try {
    final result = publishPlaygroundArtifact(
      showcaseRoot: Directory(root),
      playgroundId: id,
      sourceDir: Directory(source),
      version: version,
      commit: commit,
    );
    stdout.writeln(
      'Published ${result.playgroundId} → ${result.destination} '
      '(${result.filesCopied} files). Sibling generated/ dirs were not touched.',
    );
  } catch (e) {
    stderr.writeln(e);
    exitCode = 1;
  }
}
