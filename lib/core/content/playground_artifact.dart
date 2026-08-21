/// Validation helpers for playground artifacts (no dart:io — web-safe).
///
/// **Why:** Flutter Web compiles all of `lib/`. Copy/publish IO lives in `scripts/`.
library;

import 'package:rsprojects_showcase/core/content/playground_paths.dart';

/// File or directory names that indicate source / secrets, not a web build.
const Set<String> kForbiddenPlaygroundNames = {
  'lib',
  'test',
  'tests',
  '.git',
  '.github',
  'pubspec.yaml',
  'pubspec.lock',
  'analysis_options.yaml',
  'ci.yaml',
  '.env',
  '.env.local',
  'secrets',
  'credentials.json',
  'google-services.json',
  'GoogleService-Info.plist',
};

/// True when a path segment is forbidden in a published playground tree.
bool isForbiddenPlaygroundName(String name) {
  if (kForbiddenPlaygroundNames.contains(name)) return true;
  final lower = name.toLowerCase();
  return lower.endsWith('.env') ||
      lower.endsWith('.pem') ||
      lower.endsWith('.key');
}

/// Validates a decoded `generated/<id>/showcase.json` deployment record.
List<String> validatePlaygroundDeploymentManifest(
  Map<String, Object?> data, {
  String? expectedId,
}) {
  final errors = <String>[];
  final id = data['id'];
  if (id is! String || !isValidPlaygroundId(id)) {
    errors.add(
      'Deployment manifest "id" must be kebab-case '
      '(e.g. document-platform)',
    );
  } else if (expectedId != null && id != expectedId) {
    errors.add(
      'Deployment manifest id "$id" does not match directory "$expectedId"',
    );
  }

  final version = data['version'];
  if (version != null && (version is! String || version.trim().isEmpty)) {
    errors.add('Deployment manifest "version" must be a non-empty string');
  }

  final commit = data['commit'];
  if (commit != null && (commit is! String || commit.trim().isEmpty)) {
    errors.add('Deployment manifest "commit" must be a non-empty string');
  }

  final deployedAt = data['deployedAt'];
  if (deployedAt != null &&
      (deployedAt is! String || deployedAt.trim().isEmpty)) {
    errors.add('Deployment manifest "deployedAt" must be a non-empty string');
  }

  return errors;
}
