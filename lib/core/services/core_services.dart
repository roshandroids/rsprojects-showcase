/// Core infrastructure services (analytics, logging, remote config, etc.).
///
/// **Why:** Shared side-effectful services consumed by features via DI.
/// **Owner:** Core platform.
/// **When:** Implement when observability / config needs appear.
library;

/// Placeholder for app-level services.
///
/// TODO(core): Define interfaces + implementations (logger, link launcher, etc.).
abstract final class CoreServices {
  CoreServices._();
}
