/// Shared cross-feature data models (non-feature-specific).
///
/// **Why:** Types reused by multiple features without living in one feature.
/// **Owner:** Shared platform.
/// **When:** Add only when a model is truly cross-feature.
library;

/// Placeholder for shared models.
///
/// TODO(shared): Prefer feature domain models; add here only for true sharing.
abstract final class SharedModels {
  SharedModels._();
}
