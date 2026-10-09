# Playgrounds

How this repository hosts **generated Flutter Web playgrounds** from private product repos without becoming those products’ source of truth.

Related: [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md), [`DEPLOYMENT.md`](DEPLOYMENT.md), [`CI_CD.md`](CI_CD.md), [ADR 001](adr/001-global-playground-publishing-contract.md).

## Locked Showcase Contract

**platform-ci is the sole publisher** of private playground builds.

`rsprojects-showcase` does **not** receive private-project source, does **not** authenticate private projects, and does **not** implement a second playground receiver. It hosts `generated/<id>/` and deploys those trees with the public showcase app through GitHub Pages.

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
| Public destination | platform | `roshandroids/rsprojects-showcase/generated/<id>/` |
| Base href | platform | `/rsprojects-showcase/generated/<id>/` |
| Metadata | platform | `generated/<id>/showcase.json` |
| Registry | this repo | `assets/generated/registry.json` |
| Secret | private caller | `SHOWCASE_PUSH_TOKEN` |

`deploy.showcase.id` is the **stable identifier** shared between a private project and `rsprojects-showcase`. Consumers do **not** set `repository`, `path`, or `base_href`.

Do not add alternative configuration forms without a new architecture decision.

## Flow

```
Private Flutter project
        │  deploy.showcase.enabled + id
        ↓
platform-ci
        ├── validate id
        ├── quality
        ├── flutter build web --release
        ├── --base-href /rsprojects-showcase/generated/<id>/
        ├── validate artifact (web build, no source/secrets)
        ├── write showcase.json
        └── git add generated/<id> only
                ↓
roshandroids/rsprojects-showcase/generated/<id>/
                ↓
GitHub Pages (showcase app + generated/)
```

## This repo owns

1. Showcase application (`content/`, `lib/`, `assets/generated/registry.json`)
2. Generated playground hosting (`generated/<id>/`)
3. GitHub Pages deployment (`.github/workflows/deploy.yml`)

## This repo does not

- Check out private product repositories
- Build those products
- Receive playground artifacts from private CI
- Duplicate platform-ci publish validation
- Replace `platform-ci`

## Pages artifact

`deploy.yml` builds this app, then `scripts/publish.dart` copies `generated/` into `build/web/generated/`:

```
build/web/
├── index.html
├── flutter.js
├── assets/
└── generated/
    ├── document-platform/
    │   ├── index.html
    │   ├── flutter.js
    │   ├── assets/
    │   └── showcase.json
    └── sample-requisitions/
        └── ...
```

## Catalog

```json
"playground": {
  "enabled": true,
  "id": "document-platform",
  "demoPath": "/generated/document-platform/",
  "status": "pending"
}
```

`enabled` + no artifact → `pending`. Artifact present → `deployed`. No manual catalog edit after publish.

## ID rules

Required when `enabled: true`. Lowercase kebab-case `[a-z0-9]+(-[a-z0-9]+)*`. Reject empty, underscores, slashes, dots, `..`, leading/trailing `-`, `.git`, `.github`.
