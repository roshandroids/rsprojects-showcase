# scripts/

**Why:** Developer and CI tooling for content validation, registry generation, and playground/Pages staging.

**Owner:** Tooling / platform.

## Scripts

| Script | Responsibility |
|--------|----------------|
| `fetch_projects.dart` | Pull / sync project sources into content (placeholder) |
| `generate_registry.dart` | Build `assets/generated/registry.json` (projects, examples, playgrounds) |
| `validate_content.dart` | Validate metadata + generated playground manifests |
| `publish.dart` | Stage `generated/` into `build/web/generated` for Pages |
| `playground_io.dart` | Test helper: copy one web tree into `generated/<id>/` without touching siblings |

## Local usage

```sh
dart run scripts/validate_content.dart
dart run scripts/generate_registry.dart
dart run scripts/publish.dart --web-build build/web --generated generated
```
