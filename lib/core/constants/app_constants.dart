/// App-wide constant values (URLs, keys, limits).
///
/// **Why:** Avoids magic strings/numbers scattered across features.
/// **Owner:** Core platform.
/// **When:** Populate as real config values are introduced.
library;

/// Global constants for RSProjects Showcase.
///
/// TODO(core): Add content paths, registry asset path, analytics keys, etc.
abstract final class AppConstants {
  AppConstants._();

  // TODO(core): static const String appName = 'RSProjects Showcase';
  // TODO(core): static const String registryAssetPath = 'generated/registry.json';
}
