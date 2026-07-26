# tool/

**Why:** Reserved for Dart developer tooling that is not part of the app or `scripts/` CLI entrypoints (e.g. custom analyzers, generators helpers).

**Owner:** Platform / tooling.

**When:** Add tools when a need cannot live cleanly under `scripts/`.

## Rules

- Prefer `scripts/` for CI-invoked CLIs.
- Keep this folder empty of app/business logic.
