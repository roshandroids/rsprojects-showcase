/// Generates `generated/registry.json` from `content/projects/`.
///
/// **Why:** Enables automatic project discovery for the catalog UI.
/// **Owner:** Tooling / CI.
/// **When:** Implement after content metadata schema is stable.
///
/// Usage (future):
/// ```sh
/// dart run scripts/generate_registry.dart
/// ```
library;

Future<void> main(List<String> args) async {
  // TODO(scripts): Scan content/projects/*/metadata.json.
  // TODO(scripts): Validate required fields.
  // TODO(scripts): Write aggregated generated/registry.json.
  throw UnimplementedError(
    'generate_registry.dart is a placeholder — not implemented yet.',
  );
}
