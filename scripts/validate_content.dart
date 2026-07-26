/// Validates project content under `content/projects/`.
///
/// **Why:** Catches schema / required-field errors before registry generation or deploy.
/// **Owner:** Tooling / CI.
/// **When:** Implement alongside the content model in `docs/CONTENT_MODEL.md`.
///
/// Usage (future):
/// ```sh
/// dart run scripts/validate_content.dart
/// ```
library;

Future<void> main(List<String> args) async {
  // TODO(scripts): Load each metadata.json and validate against schema.
  // TODO(scripts): Check referenced assets exist.
  // TODO(scripts): Exit non-zero on any validation failure.
  throw UnimplementedError(
    'validate_content.dart is a placeholder — not implemented yet.',
  );
}
