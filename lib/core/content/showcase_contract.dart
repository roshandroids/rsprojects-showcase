/// Locked cross-repository playground publishing contract.
///
/// Consumer `ci.yaml` may only set `deploy.showcase.enabled` and
/// `deploy.showcase.id`. Destination, path, and base href are platform-owned.
library;

import 'package:rsprojects_showcase/core/content/playground_paths.dart';

/// Public showcase GitHub repository (`owner/name`).
const String kCanonicalShowcaseRepository = 'roshandroids/rsprojects-showcase';

/// GitHub Pages repo name (path prefix).
const String kCanonicalShowcaseRepoName = 'rsprojects-showcase';

/// Destination prefix inside the showcase repo.
const String kCanonicalGeneratedPrefix = 'generated';

/// Validates consumer `deploy.showcase` fields.
///
/// [enabled] + valid [id] → empty.
/// [enabled] without [id] → error.
/// disabled without [id] → empty.
List<String> validateShowcaseConsumerConfig({
  required bool enabled,
  String? id,
}) {
  final errors = <String>[];
  if (!enabled) return errors;

  final trimmed = id?.trim() ?? '';
  if (trimmed.isEmpty) {
    errors.add('deploy.showcase.id is required when enabled is true');
    return errors;
  }
  if (!isValidPlaygroundId(trimmed)) {
    errors.add(
      'deploy.showcase.id must be kebab-case [a-z0-9-] '
      '(got "$trimmed")',
    );
  }
  return errors;
}

/// Canonical git path: `generated/<id>`.
String canonicalGeneratedPath(String playgroundId) {
  return playgroundRepoDirectory(playgroundId);
}

/// Canonical Flutter `--base-href` for GitHub Pages.
String canonicalPlaygroundBaseHref(String playgroundId) {
  return playgroundFlutterBaseHref(
    pagesBaseHref: '/$kCanonicalShowcaseRepoName/',
    playgroundId: playgroundId,
  );
}
