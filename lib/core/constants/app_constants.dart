/// App-wide constant values (URLs, keys, limits).
///
/// **Why:** Avoids magic strings/numbers scattered across features.
/// **Owner:** Core platform.
library;

/// Global constants for RSProjects Showcase.
abstract final class AppConstants {
  AppConstants._();

  static const String appName = 'RSProjects';
  static const String appTagline = 'Showcase';
  static const String fullTitle = 'RSProjects Showcase';

  /// Mirrors `pubspec.yaml` version name (keep in sync manually for now).
  static const String appVersion = '0.0.1';

  /// Mirrors `pubspec.yaml` build number (keep in sync manually for now).
  static const String buildNumber = '1';

  /// Canonical public repository (issues tracker).
  static const String githubRepoUrl =
      'https://github.com/roshandroids/rsprojects-showcase';

  /// Fallback maintainer contact for mailto reports.
  /// TODO(quality): Confirm public contact address.
  static const String maintainerEmail = 'maintainers@rsprojects.dev';

  /// Bundled project registry (must match `pubspec.yaml` assets entry).
  static const String registryAssetPath = 'assets/generated/registry.json';
}
