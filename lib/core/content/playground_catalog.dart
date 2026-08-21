/// Merges authored playground metadata with generated deployment records.
///
/// **Why:** Catalog stays content-driven; version/commit come from CI artifacts.
/// Adding one playground must not mutate another.
library;

import 'package:rsprojects_showcase/core/content/playground_paths.dart';

/// Allowed `playground.status` / catalog status values.
const Set<String> kAllowedPlaygroundStatuses = {
  'deployed',
  'pending',
  'unavailable',
  // Legacy alias of deployed.
  'live',
};

/// Deployment record from `generated/<id>/showcase.json` plus `index.html` presence.
class GeneratedPlaygroundRecord {
  const GeneratedPlaygroundRecord({
    required this.id,
    required this.hasIndexHtml,
    this.version,
    this.commit,
    this.deployedAt,
  });

  final String id;
  final bool hasIndexHtml;
  final String? version;
  final String? commit;
  final String? deployedAt;
}

/// One catalog row for a hosted playground (UI-safe after mapping).
class PlaygroundCatalogEntry {
  const PlaygroundCatalogEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.demoPath,
    required this.status,
    this.projectId,
    this.repository,
    this.version,
    this.commit,
    this.deployedAt,
  });

  final String id;
  final String? projectId;
  final String name;
  final String description;
  final String category;
  final String? repository;
  final String demoPath;
  final String status;
  final String? version;
  final String? commit;
  final String? deployedAt;

  bool get canOpen => status == 'deployed' || status == 'live';

  Map<String, Object?> toJson() {
    return {
      'id': id,
      if (projectId != null) 'projectId': projectId,
      'name': name,
      'description': description,
      'category': category,
      if (repository != null) 'repository': repository,
      'demoPath': demoPath,
      'status': status,
      if (version != null) 'version': version,
      if (commit != null) 'commit': commit,
      if (deployedAt != null) 'deployedAt': deployedAt,
    };
  }
}

/// Authoring slice from `content/projects/<id>/metadata.json` → `playground`.
class AuthoredPlayground {
  const AuthoredPlayground({
    required this.projectId,
    required this.playgroundId,
    required this.enabled,
    required this.name,
    required this.description,
    required this.category,
    this.repository,
    this.demoPath,
    this.status,
  });

  final String projectId;
  final String playgroundId;
  final bool enabled;
  final String name;
  final String description;
  final String category;
  final String? repository;
  final String? demoPath;
  final String? status;
}

/// Parses optional `playground` on project metadata. Null when absent/disabled.
AuthoredPlayground? authoredPlaygroundFromProject(
  Map<String, Object?> project,
) {
  final raw = project['playground'];
  if (raw is! Map) return null;
  final map = raw.map((k, v) => MapEntry(k.toString(), v as Object?));
  final enabled = map['enabled'] as bool? ?? false;
  if (!enabled) return null;

  final projectId = (project['id'] as String? ?? '').trim();
  final explicitId = (map['id'] as String?)?.trim();
  final playgroundId = (explicitId != null && explicitId.isNotEmpty)
      ? explicitId
      : playgroundIdFromProjectId(projectId);

  return AuthoredPlayground(
    projectId: projectId,
    playgroundId: playgroundId,
    enabled: true,
    name: (project['name'] as String? ?? playgroundId).trim(),
    description: (project['description'] as String? ?? '').trim(),
    category: (project['category'] as String? ?? 'other').trim(),
    repository:
        (map['repository'] as String?)?.trim() ??
        (project['repositoryUrl'] as String?)?.trim(),
    demoPath: (map['demoPath'] as String?)?.trim(),
    status: (map['status'] as String?)?.trim(),
  );
}

GeneratedPlaygroundRecord? generatedRecordFromManifest(
  Map<String, Object?> manifest, {
  required bool hasIndexHtml,
}) {
  final id = (manifest['id'] as String?)?.trim();
  if (id == null || !isValidPlaygroundId(id)) return null;
  return GeneratedPlaygroundRecord(
    id: id,
    hasIndexHtml: hasIndexHtml,
    version: (manifest['version'] as String?)?.trim(),
    commit: (manifest['commit'] as String?)?.trim(),
    deployedAt: (manifest['deployedAt'] as String?)?.trim(),
  );
}

GeneratedPlaygroundRecord generatedRecordFromDirectory({
  required String playgroundId,
  required bool hasIndexHtml,
  Map<String, Object?>? manifest,
}) {
  if (manifest != null) {
    final fromManifest = generatedRecordFromManifest(
      manifest,
      hasIndexHtml: hasIndexHtml,
    );
    if (fromManifest != null) return fromManifest;
  }
  return GeneratedPlaygroundRecord(
    id: playgroundId,
    hasIndexHtml: hasIndexHtml,
  );
}

String _effectiveStatus({
  required AuthoredPlayground? authored,
  required GeneratedPlaygroundRecord? generated,
}) {
  if (authored?.status == 'unavailable') return 'unavailable';
  if (generated != null && generated.hasIndexHtml) return 'deployed';
  if (authored != null) {
    final authoredStatus = authored.status;
    if (authoredStatus == 'live') return 'pending';
    if (authoredStatus != null &&
        kAllowedPlaygroundStatuses.contains(authoredStatus) &&
        authoredStatus != 'deployed') {
      return authoredStatus;
    }
    return 'pending';
  }
  return generated != null && generated.hasIndexHtml ? 'deployed' : 'pending';
}

PlaygroundCatalogEntry _entry({
  required String id,
  AuthoredPlayground? authored,
  GeneratedPlaygroundRecord? generated,
}) {
  final demoPath = authored?.demoPath?.isNotEmpty == true
      ? authored!.demoPath!
      : playgroundDemoPath(id);
  return PlaygroundCatalogEntry(
    id: id,
    projectId: authored?.projectId,
    name: authored?.name ?? id,
    description: authored?.description ?? '',
    category: authored?.category ?? 'other',
    repository: authored?.repository,
    demoPath: demoPath,
    status: _effectiveStatus(authored: authored, generated: generated),
    version: generated?.version,
    commit: generated?.commit,
    deployedAt: generated?.deployedAt,
  );
}

/// Merges authored project playgrounds with generated directories.
///
/// Keys are playground ids. Inserting or updating one id never rewrites others.
List<PlaygroundCatalogEntry> mergePlaygroundCatalog({
  required List<AuthoredPlayground> authored,
  required List<GeneratedPlaygroundRecord> generated,
}) {
  final authoredById = <String, AuthoredPlayground>{};
  for (final item in authored) {
    authoredById[item.playgroundId] = item;
  }
  final generatedById = <String, GeneratedPlaygroundRecord>{};
  for (final item in generated) {
    generatedById[item.id] = item;
  }

  final ids = {...authoredById.keys, ...generatedById.keys}.toList()..sort();
  return [
    for (final id in ids)
      _entry(id: id, authored: authoredById[id], generated: generatedById[id]),
  ];
}

/// Nested `playground` object written back onto a project registry entry.
Map<String, Object?>? playgroundJsonForProject({
  required String projectId,
  required List<PlaygroundCatalogEntry> catalog,
}) {
  for (final entry in catalog) {
    if (entry.projectId == projectId) {
      return entry.toJson();
    }
  }
  return null;
}
