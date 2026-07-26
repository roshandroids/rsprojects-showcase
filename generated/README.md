# generated/

**Why:** Holds machine-generated artifacts consumed at build/runtime (especially the project registry).

**Owner:** CI workflows (`fetch-projects.yml`, generate scripts) — not hand-maintained.

**When:** Produced by `scripts/generate_registry.dart` (and related CI) after content discovery exists.

## Contents

| File | Purpose |
|------|---------|
| `registry.json` | Aggregated catalog of all projects discovered under `content/projects/` |

## Rules

- Do not hand-edit `registry.json` for production; regenerate from content.
- Treat this folder as CI output; local generation is for development only.
- Dart codegen output belongs under `lib/generated/`, not here.
