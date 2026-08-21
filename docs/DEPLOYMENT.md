# Deployment

This is the canonical, locked description of how this app and its hosted
playgrounds reach GitHub Pages. If any other doc, comment, or workflow
disagrees with this file, this file wins — fix the other one.

## Two complementary pipelines, not one

```
CATALOG PIPELINE                          PLAYGROUND PIPELINE

content/projects/<id>/metadata.json       private project (elsewhere)
        ↓                                         ↓
scripts/generate_registry.dart            platform-ci
        ↓                                   ├── build private playground
assets/generated/registry.json              ├── flutter build web --release
        ↓                                   └── publish generated artifact
Flutter rootBundle                                 ↓
        ↓                                  roshandroids/rsprojects-showcase
showcase catalog UI                                ↓
        ↑                                  generated/<id>/
        └──── playground.demoPath ─────────────────┘
                                                    ↓
                                             GitHub Pages
```

The catalog **references** a playground by id and shows an "Open playground"
action when `playground.status == "deployed"`. It never discovers
playgrounds by scanning `generated/` at runtime, and it never replaces
`content/` → `registry.json` as the source of catalog metadata — see
[`CONTENT_MODEL.md`](CONTENT_MODEL.md) and
[`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md), which this does not
change.

## Full architecture

```
Private project
    ↓
platform-ci
    ↓
Flutter Web release artifact
    ↓
roshandroids/rsprojects-showcase
    ↓
generated/<id>/
    ↓
GitHub Pages
```

`roshandroids/rsprojects-showcase` is the **only** canonical repository
name for this project. Never `project_showcase` or
`roshandroids/project_showcase` in configuration, docs, workflows, or
examples — that name does not exist and was the root cause of an earlier
"green CI, nothing displayed" architecture mismatch.

## Two ids, never conflated

- **Project id** — snake_case, e.g. `document_platform`. The
  `content/projects/<id>/` folder name, `registry.json` `projects[].id`,
  `content/integrations/<id>.json`.
- **Playground id** — kebab-case, e.g. `document-platform`. Used only for
  `generated/<id>/`, the base href, and the private project's
  `deploy.showcase.id` in `ci.yaml`.

`playground.id` inside a project's metadata is the join key between the
two namespaces — it is supplied verbatim by the publishing platform-ci
config and never derived from the project id by string transformation.

## Registering a playground (catalog side — this repo)

Before platform-ci can publish anything useful, the project must declare
intent in `content/projects/<id>/metadata.json`:

```json
{
  "playground": {
    "enabled": true,
    "id": "document-platform",
    "demoPath": "/generated/document-platform/"
  }
}
```

`enabled`, `id`, and `demoPath` are the only author-supplied fields.
`status`, `version`, `commit`, and `deployedAt` are **computed** by
`scripts/generate_registry.dart` from whatever actually exists under
`generated/<id>/` at generation time — never hand-authored, so a project
can never be falsely marked `deployed` before a real artifact exists. Until
`generated/<id>/index.html` exists, `status` is `pending`; the catalog
shows a disabled "Playground pending" control instead of a working link.

Validated by [`content_schema.dart`](../lib/core/content/content_schema.dart)
(`validatePlaygroundMetadata`) and
[`playground_status.dart`](../lib/core/content/playground_status.dart)
(the pending/deployed probe).

## Publishing an artifact (hosting side — platform-ci)

Consumer `ci.yaml` in the **private** project:

```yaml
deploy:
  showcase:
    enabled: true
    id: document-platform
```

That is the entire consumer contract. platform-ci owns and computes:

- destination repository (`roshandroids/rsprojects-showcase`, fixed)
- destination path (`generated/<id>/`, fixed)
- base href (`/rsprojects-showcase/generated/<id>/`, fixed)
- artifact generation, validation, and publishing

No consumer sets `repository`, `path`, or `base_href` directly.

The private project does **not** deploy itself to GitHub Pages. It
publishes a build artifact through platform-ci, which pushes it into
`generated/<id>/` here using a token scoped to this repository only. See
platform-ci's own `docs/SHOWCASE.md` for the publish-side workflow.

### Required secret

`SHOWCASE_PUSH_TOKEN` in the **private** project's repo (or org) secrets —
a fine-grained PAT scoped exclusively to `roshandroids/rsprojects-showcase`,
**Contents: Read and write**, nothing broader. Not a classic PAT. This repo
does not hold or generate that token; it only accepts pushes made with it.

## Canonical playground URL

For `id = document-platform`:

```
repo-relative:  generated/document-platform/
site path:      /rsprojects-showcase/generated/document-platform/
production URL: https://roshandroids.github.io/rsprojects-showcase/generated/document-platform/
```

The showcase app's own site path (`/rsprojects-showcase`) is fixed in
[`AppConstants.pagesBasePath`](../lib/core/constants/app_constants.dart) and
joined against a playground's `demoPath` by
[`buildPlaygroundAbsolutePath`](../lib/shared/playground/playground_path.dart)
— a pure, unit-tested function, not ad hoc string concatenation at each call
site.

The playground's **own** Flutter Web build must be built with
`--base-href /rsprojects-showcase/generated/<id>/` — platform-ci computes
and passes this; the private project's `web/index.html` only needs to keep
the default `<base href="$FLUTTER_BASE_HREF">` placeholder.

## GitHub Pages deployment (this repo)

[`​.github/workflows/deploy.yml`](../.github/workflows/deploy.yml) builds
and deploys on every push to `main` that touches `lib/`, `web/`, `content/`,
`generated/`, `assets/`, or `pubspec.*`, plus manual dispatch:

```
pub get → validate_content → generate_registry (fresh) → flutter build web
  → stage generated/ into build/web/generated/ → upload-pages-artifact
  → deploy-pages
```

Registry regeneration runs again immediately before build so the deployed
site reflects whatever is actually present under `generated/` at that
moment, even if a prior commit's committed `registry.json` is stale.
`flutter build web` has no knowledge of the repository-root `generated/`
directory and never includes it automatically —
[`scripts/stage_pages_artifact.dart`](../scripts/stage_pages_artifact.dart)
is what makes playgrounds actually reachable on the deployed site; it only
ever adds `build/web/generated/`, never touching the showcase app's own
build output or a sibling playground.

Uses the current GitHub Pages mechanism (`upload-pages-artifact` →
`deploy-pages`), not a `gh-pages` branch. Requires the repository's Pages
source set to **GitHub Actions** (Settings → Pages) — already the case for
this repo as of this writing.

```yaml
permissions:
  contents: read
  pages: write
  id-token: write
```

## Receiving a playground push (this repo)

[`.github/workflows/receive-playground.yml`](../.github/workflows/receive-playground.yml)
runs whenever anything under `generated/` changes on `main`:

1. Re-validates every `generated/<id>/` independently of platform-ci's own
   checks — rejects `lib/`, `test/`, `.git/`, `.github/`, `pubspec.yaml`,
   `.env`, `*.pem`, `*.key`, and requires `index.html` + (`flutter.js` or
   `flutter_bootstrap.js`) + `assets/`. This exists because a leaked push
   token could push directly to this repo, bypassing platform-ci's own
   validation entirely — defense in depth, not redundancy.
2. Regenerates `assets/generated/registry.json` so `pending` → `deployed`
   transitions are reflected in the committed catalog, not only in the next
   deploy's ephemeral rebuild.
3. Commits **only** `assets/generated/registry.json` (never `git add -A`)
   and pushes with a bounded fetch/rebase/retry loop.

This workflow never builds or deploys the site — `deploy.yml` does, and
regenerates the registry fresh at build time regardless, so the deployed
site is correct even if these two workflows' commits race each other.

## Isolation and concurrency

- `generated/<id>/` is owned exclusively by the private repo that publishes
  it; platform-ci's `showcase-sync` action clears and rewrites only that
  one subdirectory and commits with `git add generated/<id>` (never
  `git add .`).
- Two projects publishing at the same time do not corrupt each other's
  directory — verified by [`stage_pages_artifact_test.dart`](../test/unit/stage_pages_artifact_test.dart)
  (local staging) and, on the publish side, platform-ci's
  `showcase-sync-isolation` self-test (scoped write + sibling untouched).
- The `showcase-generated-publish` concurrency group is per-repository — it
  serializes `receive-playground.yml` runs against each other, but does
  **not** by itself prevent two different private projects from racing a
  concurrent push. That race is instead handled by platform-ci's own
  fetch/rebase/retry loop on push rejection, verified only by code
  inspection, not by a live concurrent-push test.

## What is and isn't verified

Locally verifiable and actually run as part of this work: content
validation, registry generation (including the pending → deployed
transition against a real fixture), the `demoPath` → site-path join against
a literal expected string, the `generated/` → `build/web/generated/` copy
and its sibling-isolation behavior, artifact-rejection rules, and
`flutter analyze` / `flutter test`.

Not verifiable without a live deploy: the actual GitHub Pages deploy
succeeding end to end, a playground actually running from its nested URL in
a browser, and a real cross-repo push from platform-ci racing against
another one. Treat those as open until a real `document-platform` artifact
has been published and the site checked in a browser.
