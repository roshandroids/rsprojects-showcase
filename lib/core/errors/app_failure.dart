/// Shared error / failure types for the application.
///
/// **Why:** Consistent failure modeling across domain and UI layers.
/// **Owner:** Core platform.
/// **When:** Introduce when first repository / use case needs typed failures.
library;

/// Base failure type for RSProjects Showcase.
///
/// TODO(core): Define AppFailure hierarchy (network, parse, notFound, etc.).
sealed class AppFailure {
  const AppFailure();
}
