# lib/generated

**Why:** Reserved for Dart code produced by code generators (e.g. freezed, json_serializable, assets).

**Owner:** CI / codegen tooling — do not hand-edit generated sources.

**When:** Populated when codegen dependencies and build_runner (or equivalent) are introduced.

## Rules

- Do not commit hand-written business logic here.
- Prefer regenerating via scripts / CI over manual edits.
- Runtime project registry JSON lives at `assets/generated/registry.json` (Flutter-bundled asset, loaded via `rootBundle`) — unrelated to this directory.
- Repository-root `generated/` is a different thing entirely: hosted static playground build artifacts published by `platform-ci`, served by GitHub Pages. See [`generated/README.md`](../../generated/README.md) and [`docs/DEPLOYMENT.md`](../../docs/DEPLOYMENT.md).
