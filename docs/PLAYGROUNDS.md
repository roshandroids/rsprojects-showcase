# Playgrounds

How this repository hosts **generated Flutter Web playgrounds** from private product repos without becoming those products’ source of truth.

Related: [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md), [`DEPLOYMENT.md`](DEPLOYMENT.md), [`CI_CD.md`](CI_CD.md), [ADR 001](adr/001-global-playground-publishing-contract.md).

## Locked Showcase Contract

**Do not add alternative configuration forms without a new architecture decision.**

Consumer configuration (only):

```yaml
deploy:
  showcase:
    enabled: true
    id: document-platform
```

| Field | Owner | Value |
|-------|--------|--------|
| `deploy.showcase.enabled` | consumer | `true` / `false` |
| `deploy.showcase.id` | consumer | kebab-case playground id |
| Public destination | platform | `rsprojects-showcase/generated/<id>/` |
| Base href | platform | `/rsprojects-showcase/generated/<id>/` |
| Metadata | platform | `generated/<id>/showcase.json` |
| Registry | this repo | `assets/generated/registry.json` |
| Secret | private caller | `SHOWCASE_PUSH_TOKEN` (fine-grained, this repo only, Contents: Read and write) |

`deploy.showcase.id` is the **stable identifier** shared between a private project and `rsprojects-showcase`. Consumers do **not** set `repository`, `path`, or `base_href`.

## Purpose

`project_showcase` / GitHub `rsprojects-showcase` is the **public catalog and static host**.

| Piece | Lives here? | Built here? |
|-------|-------------|-------------|
| Showcase Flutter app | yes | yes |
| Playground web artifacts | `generated/<id>/` | **no** — platform-ci |
| Private product source | **never** | n/a |

## Flow

```
PRIVATE PROJECT
       │  deploy.showcase.enabled + id
       ↓
platform-ci
       ├── validate id
       ├── quality
       ├── flutter build web --release --base-href /rsprojects-showcase/generated/<id>/
       └── publish only generated/<id>/
                ↓
rsprojects-showcase/generated/<id>/
                ↓
           GitHub Pages
```

## `generated/<id>/`

Canonical destination. One product writes only its own directory. `showcase.json`:

```json
{
  "id": "document-platform",
  "version": "1.2.0",
  "commit": "abc123",
  "deployedAt": "2026-08-21T..."
}
```

Catalog registry remains `assets/generated/registry.json` (never in root `generated/`).

## Catalog

```json
"playground": {
  "enabled": true,
  "id": "document-platform",
  "demoPath": "/generated/document-platform/",
  "status": "pending"
}
```

`enabled` + no artifact → `pending`. Artifact present → `deployed` (no manual catalog edit required). `unavailable` remains an authored override.

## ID rules

Required when `enabled: true`. Lowercase kebab-case `[a-z0-9]+(-[a-z0-9]+)*`. Reject empty, underscores, slashes, dots, `..`, leading/trailing `-`, `.git`, `.github`.

## Concurrency

`showcase-generated-publish`, `cancel-in-progress: false`. `git add generated/<id>` only. Rebase retry on push.

## Security

Reject `lib/`, `test/`, `.git/`, `.github/`, `pubspec.yaml`, `*.env`, `*.pem`, `*.key`. Require a Flutter Web tree (`index.html`, `flutter.js` or `flutter_bootstrap.js`, `assets/`).

Canonical publisher is platform-ci `deploy-showcase.yml`. Optional same-path receiver in this repo: [`.github/workflows/receive-playground.yml`](../.github/workflows/receive-playground.yml).
