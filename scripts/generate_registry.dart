/// Generates `assets/generated/registry.json` from `content/projects/` and
/// `content/examples/`.
///
/// Usage: `dart run scripts/generate_registry.dart`
library;

import 'dart:convert';
import 'dart:io';

import 'package:rsprojects_showcase/core/content/content_schema.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current;
  final projectsDir = Directory('${root.path}/content/projects');
  final examplesDir = Directory('${root.path}/content/examples');
  final outFile = File('${root.path}/assets/generated/registry.json');

  if (!projectsDir.existsSync()) {
    stderr.writeln('Missing content/projects directory');
    exitCode = 1;
    return;
  }

  final projects = <Map<String, Object?>>[];
  final knownProjectIds = <String>{};
  final projectDirs = projectsDir
      .listSync()
      .whereType<Directory>()
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final dir in projectDirs) {
    final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final metaFile = File('${dir.path}/metadata.json');
    if (!metaFile.existsSync()) {
      stderr.writeln('Skipping $id — missing metadata.json');
      continue;
    }

    final decoded = jsonDecode(metaFile.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      stderr.writeln('Skipping $id — metadata is not an object');
      exitCode = 1;
      continue;
    }
    final map = decoded.map((k, v) => MapEntry(k, v as Object?));
    final errors = validateProjectMetadata(map, expectedId: id);
    if (errors.isNotEmpty) {
      stderr.writeln('Invalid metadata for $id:');
      for (final e in errors) {
        stderr.writeln(' - $e');
      }
      exitCode = 1;
      continue;
    }
    projects.add(map);
    knownProjectIds.add(id);
  }

  final examples = <Map<String, Object?>>[];
  if (examplesDir.existsSync()) {
    final exampleDirs = examplesDir
        .listSync()
        .whereType<Directory>()
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final dir in exampleDirs) {
      final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      final metaFile = File('${dir.path}/metadata.json');
      if (!metaFile.existsSync()) {
        stderr.writeln('Skipping example $id — missing metadata.json');
        continue;
      }

      final decoded = jsonDecode(metaFile.readAsStringSync());
      if (decoded is! Map<String, dynamic>) {
        stderr.writeln('Skipping example $id — metadata is not an object');
        exitCode = 1;
        continue;
      }
      final map = decoded.map((k, v) => MapEntry(k, v as Object?));
      final errors = validateExampleMetadata(
        map,
        expectedId: id,
        knownProjectIds: knownProjectIds,
      );
      if (errors.isNotEmpty) {
        stderr.writeln('Invalid example metadata for $id:');
        for (final e in errors) {
          stderr.writeln(' - $e');
        }
        exitCode = 1;
        continue;
      }
      examples.add(map);
    }
  }

  if (exitCode != 0) {
    stderr.writeln('Registry generation aborted due to validation errors.');
    return;
  }

  final registry = <String, Object?>{
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'projects': projects,
    'examples': examples,
  };

  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(registry),
  );
  stdout.writeln(
    'Wrote ${outFile.path} with ${projects.length} projects '
    'and ${examples.length} examples.',
  );
}
