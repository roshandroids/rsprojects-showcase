/// Application routing configuration.
///
/// **Why:** Single source of truth for navigation paths across features.
/// **Owner:** App layer (coordinates with feature presentation owners).
/// **When:** Implement when home / projects / search / settings / about routes exist.
library;

/// Route path constants and navigator configuration.
///
/// TODO(app): Choose router package (e.g. go_router) and register feature routes.
abstract final class AppRouter {
  AppRouter._();

  // TODO(app): Define path constants (/, /projects, /search, /settings, /about).
  // TODO(app): Expose router instance used by [RsProjectsShowcaseApp].
}
