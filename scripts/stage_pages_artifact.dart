/// Stages `generated/<id>/` playground builds into a Flutter Web build
/// output for a single combined GitHub Pages artifact.
///
/// Usage: `dart run scripts/stage_pages_artifact.dart --generated generated --build build/web`
library;

import 'dart:io';

import 'package:rsprojects_showcase/core/build/stage_pages_artifact.dart';

Future<void> main(List<String> args) async {
  String? generatedPath;
  String? buildPath;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--generated':
        generatedPath = args[++i];
      case '--build':
        buildPath = args[++i];
    }
  }

  generatedPath ??= 'generated';
  buildPath ??= 'build/web';

  try {
    stagePlaygroundsIntoBuild(
      generatedRoot: Directory(generatedPath),
      buildWebRoot: Directory(buildPath),
    );
  } on StateError catch (e) {
    stderr.writeln('::error::${e.message}');
    exitCode = 1;
    return;
  }

  stdout.writeln('Staged $generatedPath/ into $buildPath/generated/');
}
