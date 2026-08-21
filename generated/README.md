# generated/

**Why:** Hosted static build output for playgrounds — the **playground hosting pipeline**, not the catalog. See [`docs/DEPLOYMENT.md`](../docs/DEPLOYMENT.md) for the full architecture.

**Owner:** `platform-ci`, publishing from private source repos via a scoped push token. Not hand-maintained here.

## Contents

```
generated/<playground-id>/    # one directory per kebab-case playground id
  index.html
  flutter.js (or flutter_bootstrap.js)
  main.dart.js
  assets/
  showcase.json                # {id, version, commit, deployedAt}
```

## Rules

- Never hand-edit — each `generated/<id>/` is owned exclusively by the private source repo that publishes it.
- This directory is **not** read at runtime by the Flutter app, and is **not** scanned to discover playgrounds. The catalog only ever reads `assets/generated/registry.json`; a project's `content/projects/<id>/metadata.json` must separately declare `playground.enabled` + `playground.id` before it appears in the catalog at all (see [`docs/DEPLOYMENT.md`](../docs/DEPLOYMENT.md)).
- `scripts/generate_registry.dart` *does* probe `generated/<id>/index.html` at generation time, purely to compute `playground.status` (`pending` vs `deployed`) — that is filesystem presence-checking, not directory-scan discovery.
- `.github/workflows/deploy.yml` copies this directory into `build/web/generated/` before uploading the Pages artifact (via `scripts/stage_pages_artifact.dart`) — `flutter build web` has no knowledge of it otherwise.
- The registry's `assets/generated/registry.json` (Flutter-bundled catalog data) is unrelated to this directory beyond that one status probe — do not confuse the two. See [`assets/generated/README.md`](../assets/generated/README.md).
