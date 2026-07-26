# lib/generated

**Why:** Reserved for Dart code produced by code generators (e.g. freezed, json_serializable, assets).

**Owner:** CI / codegen tooling — do not hand-edit generated sources.

**When:** Populated when codegen dependencies and build_runner (or equivalent) are introduced.

## Rules

- Do not commit hand-written business logic here.
- Prefer regenerating via scripts / CI over manual edits.
- Runtime project registry JSON lives at repository root `generated/` (not here).
