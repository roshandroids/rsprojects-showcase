/// Settings feature — portal preferences (theme, locale, etc.).
///
/// **Why:** User-facing configuration separate from product catalog.
/// **Owner:** Settings feature team.
/// **When:** Implement when preference persistence is required.
library;

/// Settings feature marker / future exports.
///
/// TODO(settings): Export presentation screens and settings providers.
abstract final class SettingsFeature {
  SettingsFeature._();
}
