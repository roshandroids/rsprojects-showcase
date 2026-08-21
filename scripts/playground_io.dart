/// IO helpers for copying a Flutter Web playground into `generated/<id>/`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:rsprojects_showcase/core/content/playground_artifact.dart';
import 'package:rsprojects_showcase/core/content/playground_paths.dart';

/// Result of staging one playground artifact.
class PlaygroundPublishResult {
  const PlaygroundPublishResult({
    required this.playgroundId,
    required this.destination,
    required this.filesCopied,
  });

  final String playgroundId;
  final String destination;
  final int filesCopied;
}

/// Walks [sourceDir] and returns paths that must not be published.
List<String> findForbiddenPlaygroundEntries(Directory sourceDir) {
  final hits = <String>[];
  if (!sourceDir.existsSync()) {
    return ['Source directory does not exist: ${sourceDir.path}'];
  }

  for (final entity in sourceDir.listSync(
    recursive: true,
    followLinks: false,
  )) {
    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    if (isForbiddenPlaygroundName(name)) {
      hits.add(entity.path);
    }
  }
  return hits;
}

/// Copies a Flutter Web release into `generated/<id>/` without touching siblings.
PlaygroundPublishResult publishPlaygroundArtifact({
  required Directory showcaseRoot,
  required String playgroundId,
  required Directory sourceDir,
  String? version,
  String? commit,
  DateTime? deployedAt,
}) {
  final id = playgroundId.trim();
  if (!isValidPlaygroundId(id)) {
    throw ArgumentError.value(
      playgroundId,
      'playgroundId',
      'Must be kebab-case',
    );
  }
  if (!sourceDir.existsSync()) {
    throw ArgumentError.value(sourceDir.path, 'sourceDir', 'Missing directory');
  }

  final index = File('${sourceDir.path}/index.html');
  if (!index.existsSync()) {
    throw StateError(
      'Playground artifact is missing index.html (not a Flutter Web build)',
    );
  }
  final flutterJs = File('${sourceDir.path}/flutter.js').existsSync();
  final bootstrap = File('${sourceDir.path}/flutter_bootstrap.js').existsSync();
  if (!flutterJs && !bootstrap) {
    throw StateError(
      'Playground artifact is missing flutter.js / flutter_bootstrap.js',
    );
  }
  if (!Directory('${sourceDir.path}/assets').existsSync()) {
    throw StateError('Playground artifact is missing assets/');
  }

  final forbidden = findForbiddenPlaygroundEntries(sourceDir);
  if (forbidden.isNotEmpty) {
    throw StateError(
      'Refusing to publish source or secrets:\n${forbidden.join('\n')}',
    );
  }

  final destination = Directory(
    '${showcaseRoot.path}/${playgroundRepoDirectory(id)}',
  );
  if (destination.existsSync()) {
    destination.deleteSync(recursive: true);
  }
  destination.createSync(recursive: true);

  var copied = 0;
  for (final entity in sourceDir.listSync(
    recursive: true,
    followLinks: false,
  )) {
    final relative = entity.path.substring(sourceDir.path.length);
    final destPath = '${destination.path}$relative';
    if (entity is Directory) {
      Directory(destPath).createSync(recursive: true);
    } else if (entity is File) {
      File(destPath).parent.createSync(recursive: true);
      entity.copySync(destPath);
      copied++;
    }
  }

  final manifest = <String, Object?>{
    'id': id,
    if (version != null && version.trim().isNotEmpty) 'version': version.trim(),
    if (commit != null && commit.trim().isNotEmpty) 'commit': commit.trim(),
    'deployedAt': (deployedAt ?? DateTime.now().toUtc()).toIso8601String(),
  };
  File(
    '${destination.path}/showcase.json',
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  copied++;

  return PlaygroundPublishResult(
    playgroundId: id,
    destination: destination.path,
    filesCopied: copied,
  );
}
