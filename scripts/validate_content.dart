/// Validates project and example content under `content/`.
///
/// Usage: `dart run scripts/validate_content.dart`
library;

import 'dart:convert';
import 'dart:io';

import 'package:rsprojects_showcase/core/content/content_schema.dart';
import 'package:rsprojects_showcase/core/content/playground_artifact.dart';
import 'package:rsprojects_showcase/core/content/playground_paths.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current;
  final projectsDir = Directory('${root.path}/content/projects');
  final examplesDir = Directory('${root.path}/content/examples');

  if (!projectsDir.existsSync()) {
    stderr.writeln('Missing content/projects directory');
    exitCode = 1;
    return;
  }

  final errors = <String>[];
  final knownProjectIds = <String>{};

  final projectDirs = projectsDir.listSync().whereType<Directory>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (projectDirs.isEmpty) {
    errors.add('No project folders found under content/projects');
  }

  for (final dir in projectDirs) {
    final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final metaFile = File('${dir.path}/metadata.json');
    if (!metaFile.existsSync()) {
      errors.add('[$id] missing metadata.json');
      continue;
    }

    try {
      final decoded = jsonDecode(metaFile.readAsStringSync());
      if (decoded is! Map<String, dynamic>) {
        errors.add('[$id] metadata.json must be a JSON object');
        continue;
      }
      final map = decoded.map((k, v) => MapEntry(k, v as Object?));
      for (final err in validateProjectMetadata(map, expectedId: id)) {
        errors.add('[$id] $err');
      }
      knownProjectIds.add(id);
    } on FormatException catch (e) {
      errors.add('[$id] invalid JSON: $e');
    }
  }

  var exampleCount = 0;
  if (examplesDir.existsSync()) {
    final exampleDirs = examplesDir.listSync().whereType<Directory>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final dir in exampleDirs) {
      final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      final metaFile = File('${dir.path}/metadata.json');
      if (!metaFile.existsSync()) {
        errors.add('[example:$id] missing metadata.json');
        continue;
      }

      try {
        final decoded = jsonDecode(metaFile.readAsStringSync());
        if (decoded is! Map<String, dynamic>) {
          errors.add('[example:$id] metadata.json must be a JSON object');
          continue;
        }
        final map = decoded.map((k, v) => MapEntry(k, v as Object?));
        for (final err in validateExampleMetadata(
          map,
          expectedId: id,
          knownProjectIds: knownProjectIds,
        )) {
          errors.add('[example:$id] $err');
        }
        exampleCount++;
      } on FormatException catch (e) {
        errors.add('[example:$id] invalid JSON: $e');
      }
    }
  }

  var generatedPlaygrounds = 0;
  final generatedDir = Directory('${root.path}/generated');
  final livePlaygroundIds = <String>{};
  if (generatedDir.existsSync()) {
    for (final dir in generatedDir.listSync().whereType<Directory>()) {
      final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (!isValidPlaygroundId(id)) continue;
      generatedPlaygrounds++;
      final hasIndex = File('${dir.path}/index.html').existsSync();
      if (hasIndex) livePlaygroundIds.add(id);
      final manifestFile = File('${dir.path}/showcase.json');
      if (manifestFile.existsSync()) {
        try {
          final decoded = jsonDecode(manifestFile.readAsStringSync());
          if (decoded is! Map<String, dynamic>) {
            errors.add('[generated:$id] showcase.json must be a JSON object');
            continue;
          }
          final map = decoded.map((k, v) => MapEntry(k, v as Object?));
          for (final err in validatePlaygroundDeploymentManifest(
            map,
            expectedId: id,
          )) {
            errors.add('[generated:$id] $err');
          }
        } on FormatException catch (e) {
          errors.add('[generated:$id] invalid showcase.json: $e');
        }
      }
    }
  }

  for (final dir in projectDirs) {
    final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final metaFile = File('${dir.path}/metadata.json');
    if (!metaFile.existsSync()) continue;
    try {
      final decoded = jsonDecode(metaFile.readAsStringSync());
      if (decoded is! Map<String, dynamic>) continue;
      final playground = decoded['playground'];
      if (playground is! Map) continue;
      final enabled = playground['enabled'] == true;
      final status = playground['status'] as String?;
      if (!enabled || (status != 'deployed' && status != 'live')) continue;
      final playgroundId =
          (playground['id'] as String?) ?? playgroundIdFromProjectId(id);
      if (!livePlaygroundIds.contains(playgroundId)) {
        errors.add(
          '[$id] playground.status is live but '
          'generated/$playgroundId/index.html is missing',
        );
      }
    } on FormatException {
      // JSON errors already recorded above.
    }
  }

  if (errors.isEmpty) {
    stdout.writeln(
      'Content validation passed '
      '(${projectDirs.length} projects, $exampleCount examples, '
      '$generatedPlaygrounds generated playgrounds).',
    );
    return;
  }

  stderr.writeln('Content validation failed:\n');
  for (final e in errors) {
    stderr.writeln(' - $e');
  }
  exitCode = 1;
}
