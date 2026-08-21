/// Resolves a playground's hosting status from the filesystem.
///
/// Status is never authored in `content/` — it is always derived from
/// whether `generated/<id>/index.html` exists on disk at registry-generation
/// time, so a project can never be falsely marked `deployed` before its
/// first real artifact has been published (see docs/DEPLOYMENT.md).
library;

import 'dart:convert';
import 'dart:io';

/// Computed playground fields merged into a registry entry's `playground`.
class PlaygroundStatus {
  const PlaygroundStatus({
    required this.status,
    this.version,
    this.commit,
    this.deployedAt,
  });

  /// `pending` | `deployed`.
  final String status;
  final String? version;
  final String? commit;
  final String? deployedAt;

  Map<String, Object?> toJson() => {
    'status': status,
    'version': version,
    'commit': commit,
    'deployedAt': deployedAt,
  };
}

/// Inspects `<generatedRoot>/<playgroundId>/` for a hosted build.
///
/// [generatedRoot] is injectable so tests never depend on the real
/// repository-root `generated/` directory.
PlaygroundStatus resolvePlaygroundStatus({
  required Directory generatedRoot,
  required String playgroundId,
}) {
  final playgroundDir = Directory('${generatedRoot.path}/$playgroundId');
  final indexFile = File('${playgroundDir.path}/index.html');

  if (!indexFile.existsSync()) {
    return const PlaygroundStatus(status: 'pending');
  }

  final metaFile = File('${playgroundDir.path}/showcase.json');
  if (!metaFile.existsSync()) {
    return const PlaygroundStatus(status: 'deployed');
  }

  try {
    final decoded = jsonDecode(metaFile.readAsStringSync());
    if (decoded is! Map) {
      return const PlaygroundStatus(status: 'deployed');
    }
    return PlaygroundStatus(
      status: 'deployed',
      version: decoded['version'] as String?,
      commit: decoded['commit'] as String?,
      deployedAt: decoded['deployedAt'] as String?,
    );
  } on FormatException {
    return const PlaygroundStatus(status: 'deployed');
  }
}
