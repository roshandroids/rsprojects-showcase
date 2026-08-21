/// Playground id, path, and public URL helpers.
///
/// **Why:** Nested Flutter Web apps must resolve under GitHub Pages, not the
/// Flutter asset bundle. Keep id ↔ directory mapping in one place.
/// **Owner:** Content / hosting.
library;

/// GitHub Pages site prefix (`/` locally, `/<repo>/` in production).
///
/// Set at web build time: `--dart-define=PAGES_BASE_HREF=/rsprojects-showcase/`
const String kPagesBaseHref = String.fromEnvironment(
  'PAGES_BASE_HREF',
  defaultValue: '/',
);

/// Kebab-case playground directory ids (`document-platform`).
final RegExp kPlaygroundIdPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

/// Maps a portal project id (`document_platform`) to a playground directory id.
String playgroundIdFromProjectId(String projectId) {
  return projectId.trim().replaceAll('_', '-').toLowerCase();
}

/// Returns true when [id] is a valid `generated/<id>/` directory name.
bool isValidPlaygroundId(String id) {
  return kPlaygroundIdPattern.hasMatch(id.trim());
}

/// Site-relative demo path with trailing slash, e.g. `/generated/document-platform/`.
///
/// This is the canonical stored path (not including the GitHub Pages repo prefix).
String playgroundDemoPath(String playgroundId) {
  final id = playgroundId.trim();
  return '/generated/$id/';
}

/// Directory under the showcase repo root: `generated/<id>`.
String playgroundRepoDirectory(String playgroundId) {
  return 'generated/${playgroundId.trim()}';
}

/// Normalizes a Pages base href to start and end with `/`.
String normalizePagesBaseHref(String raw) {
  var value = raw.trim();
  if (value.isEmpty) return '/';
  if (!value.startsWith('/')) value = '/$value';
  if (!value.endsWith('/')) value = '$value/';
  return value;
}

/// Flutter `--base-href` for a nested playground on GitHub Pages.
String playgroundFlutterBaseHref({
  required String pagesBaseHref,
  required String playgroundId,
}) {
  final base = normalizePagesBaseHref(pagesBaseHref);
  return '${base}generated/${playgroundId.trim()}/';
}

/// Absolute public URL for a playground (GitHub Pages).
String playgroundPublicUrl({
  required String owner,
  required String repository,
  required String playgroundId,
}) {
  return 'https://$owner.github.io/$repository'
      '${playgroundDemoPath(playgroundId)}';
}

/// Resolves a stored demo path against the hosted site prefix.
///
/// Absolute `http(s)` URLs pass through. Site-relative `/generated/...` paths
/// are prefixed with [pagesBaseHref] so they work under `/<repo>/` on Pages.
String resolvePlaygroundUrl(
  String demoPath, {
  String pagesBaseHref = kPagesBaseHref,
}) {
  final trimmed = demoPath.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  final base = normalizePagesBaseHref(pagesBaseHref);
  var path = trimmed;
  if (path.startsWith('/')) {
    path = path.substring(1);
  }
  return '$base$path';
}

/// True when [candidate] is inside `generated/<playgroundId>/` and not a sibling.
bool isPathInsidePlayground({
  required String playgroundId,
  required String candidate,
}) {
  final root = '${playgroundRepoDirectory(playgroundId)}/';
  final normalized = candidate.replaceAll('\\', '/');
  return normalized == playgroundRepoDirectory(playgroundId) ||
      normalized.startsWith(root);
}
