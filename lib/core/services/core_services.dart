/// Core infrastructure services (analytics, logging, remote config, etc.).
///
/// **Why:** Shared side-effectful services consumed by features via DI.
/// **Owner:** Core platform.
library;

export 'package:rsprojects_showcase/core/quality/quality.dart';

/// Placeholder for app-level services registry.
///
/// Quality services live under `lib/core/quality/` and are exported above.
///
/// TODO(core): Add logger / link launcher ports when needed.
abstract final class CoreServices {
  CoreServices._();
}
