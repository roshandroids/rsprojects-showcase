# assets/generated/

**Why:** Flutter-bundled content artifacts (loaded via `rootBundle`).

**Owner:** `scripts/generate_registry.dart` / CI — not hand-maintained.

## Contents

| File | Purpose |
|------|---------|
| `registry.json` | Aggregated catalog from `content/projects/*/metadata.json` |

## Rules

- Do not hand-edit `registry.json` for releases; regenerate with `dart run scripts/generate_registry.dart`.
- Registered in `pubspec.yaml` as `assets/generated/registry.json`.
- Dart codegen belongs under `lib/generated/`, not here.
