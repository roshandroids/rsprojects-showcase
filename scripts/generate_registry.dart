/// Generates `assets/generated/registry.json` from `content/` plus playgrounds.
///
/// Usage: `dart run scripts/generate_registry.dart`
library;

import 'dart:convert';
import 'dart:io';

import 'package:rsprojects_showcase/core/content/content_schema.dart';
import 'package:rsprojects_showcase/core/content/playground_catalog.dart';
import 'package:rsprojects_showcase/core/content/playground_paths.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current;
  final projectsDir = Directory('${root.path}/content/projects');
  final examplesDir = Directory('${root.path}/content/examples');
  final generatedDir = Directory('${root.path}/generated');
  final outFile = File('${root.path}/assets/generated/registry.json');

  if (!projectsDir.existsSync()) {
    stderr.writeln('Missing content/projects directory');
    exitCode = 1;
    return;
  }

  final projects = <Map<String, Object?>>[];
  final knownProjectIds = <String>{};
  final authoredPlaygrounds = <AuthoredPlayground>[];
  final projectDirs = projectsDir.listSync().whereType<Directory>().toList()
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
    final authored = authoredPlaygroundFromProject(map);
    if (authored != null) {
      authoredPlaygrounds.add(authored);
    }
  }

  final examples = <Map<String, Object?>>[];
  if (examplesDir.existsSync()) {
    final exampleDirs = examplesDir.listSync().whereType<Directory>().toList()
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

  final generatedRecords = scanGeneratedPlaygrounds(generatedDir);
  final playgrounds = mergePlaygroundCatalog(
    authored: authoredPlaygrounds,
    generated: generatedRecords,
  );

  for (final entry in playgrounds) {
    final errors = validatePlaygroundCatalogMetadata(entry.toJson());
    if (errors.isNotEmpty) {
      stderr.writeln('Invalid playground catalog entry ${entry.id}:');
      for (final e in errors) {
        stderr.writeln(' - $e');
      }
      exitCode = 1;
    }
  }

  if (exitCode != 0) {
    stderr.writeln('Registry generation aborted due to validation errors.');
    return;
  }

  final projectsWithPlayground = <Map<String, Object?>>[];
  for (final project in projects) {
    final copy = Map<String, Object?>.from(project);
    final nested = playgroundJsonForProject(
      projectId: project['id'] as String? ?? '',
      catalog: playgrounds,
    );
    if (nested != null) {
      copy['playground'] = nested;
    }
    projectsWithPlayground.add(copy);
  }

  final registry = <String, Object?>{
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'projects': projectsWithPlayground,
    'examples': examples,
    'playgrounds': [for (final entry in playgrounds) entry.toJson()],
  };

  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(registry),
  );
  stdout.writeln(
    'Wrote ${outFile.path} with ${projects.length} projects, '
    '${examples.length} examples, and ${playgrounds.length} playgrounds.',
  );
}

/// Reads `generated/<id>/` directories (skips README-only placeholders).
List<GeneratedPlaygroundRecord> scanGeneratedPlaygrounds(
  Directory generatedDir,
) {
  if (!generatedDir.existsSync()) return const [];

  final records = <GeneratedPlaygroundRecord>[];
  final dirs = generatedDir.listSync().whereType<Directory>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final dir in dirs) {
    final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
    if (!isValidPlaygroundId(id)) continue;

    final hasIndex = File('${dir.path}/index.html').existsSync();
    final manifestFile = File('${dir.path}/showcase.json');
    Map<String, Object?>? manifest;
    if (manifestFile.existsSync()) {
      final decoded = jsonDecode(manifestFile.readAsStringSync());
      if (decoded is Map<String, dynamic>) {
        manifest = decoded.map((k, v) => MapEntry(k, v as Object?));
      }
    }
    if (!hasIndex && manifest == null) continue;

    records.add(
      generatedRecordFromDirectory(
        playgroundId: id,
        hasIndexHtml: hasIndex,
        manifest: manifest,
      ),
    );
  }
  return records;
}
