/// Copies hosted playground builds (`generated/<id>/`) into a Flutter Web
/// build output (`build/web/generated/<id>/`) for a single combined GitHub
/// Pages artifact.
///
/// `flutter build web` has no knowledge of the repository-root `generated/`
/// directory and never includes it automatically — this step is what makes
/// playgrounds actually reachable on the deployed site. See
/// docs/DEPLOYMENT.md.
library;

import 'dart:io';

/// Copies every immediate subdirectory of [generatedRoot] (one per
/// playground id; non-directory entries such as `generated/README.md` are
/// skipped) into `<buildWebRoot>/generated/<id>/`.
///
/// Never touches any other path under [buildWebRoot] — the showcase app's
/// own build output and other playgrounds' directories are left exactly as
/// they were.
void stagePlaygroundsIntoBuild({
  required Directory generatedRoot,
  required Directory buildWebRoot,
}) {
  if (!buildWebRoot.existsSync() ||
      !File('${buildWebRoot.path}/index.html').existsSync()) {
    throw StateError(
      'Refusing to stage playgrounds: ${buildWebRoot.path} does not look '
      'like a Flutter web build output (missing index.html). '
      'Run `flutter build web` first.',
    );
  }

  if (!generatedRoot.existsSync()) {
    return;
  }

  final destRoot = Directory('${buildWebRoot.path}/generated');
  destRoot.createSync(recursive: true);

  for (final entry in generatedRoot.listSync()) {
    if (entry is! Directory) continue;
    final id = entry.uri.pathSegments.where((s) => s.isNotEmpty).last;
    _copyDirectory(entry, Directory('${destRoot.path}/$id'));
  }
}

void _copyDirectory(Directory source, Directory destination) {
  destination.createSync(recursive: true);
  for (final entity in source.listSync(recursive: false)) {
    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final destPath = '${destination.path}/$name';
    if (entity is Directory) {
      _copyDirectory(entity, Directory(destPath));
    } else if (entity is File) {
      entity.copySync(destPath);
    }
  }
}
