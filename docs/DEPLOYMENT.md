# Deployment

## Target host

**GitHub Pages** (D-011). Workflow: [`.github/workflows/deploy.yml`](../.github/workflows/deploy.yml).

Public URLs (replace owner/repo with this GitHub repository; currently `roshandroids/rsprojects-showcase`):

- Showcase: `https://<owner>.github.io/<repo>/`
- Playground: `https://<owner>.github.io/<repo>/generated/<project-id>/`

Enable Pages: Settings → Pages → Source **GitHub Actions**.

## Build

```sh
flutter build web --release \
  --base-href /<repo>/ \
  --dart-define=PAGES_BASE_HREF=/<repo>/
dart run scripts/publish.dart --web-build build/web --generated generated
```

Playgrounds must be built **by platform-ci** with:

```text
--base-href /rsprojects-showcase/generated/<id>/
```

This repo does not receive or re-publish those artifacts. platform-ci pushes `generated/<id>/` directly.

## Environments

Production = `main` → `deploy.yml`. No preview environment yet.

## Rollback

Revert the playground commit under `generated/<id>/` (does not revert other products) or revert the showcase app commit, then re-run deploy.

## Concurrency

Pages deploys share `pages-deploy`. Playground publishes are serialized in **platform-ci** (`showcase-generated-publish`).
