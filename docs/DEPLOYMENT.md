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
--base-href /<repo>/generated/<project-id>/
```

## Publish playgrounds

This repo does not build private products. See [`PLAYGROUNDS.md`](PLAYGROUNDS.md).

- Receive: [`.github/workflows/receive-playground.yml`](../.github/workflows/receive-playground.yml)
- Local: `dart run scripts/publish_playground.dart --id <id> --source <web-dir>`

## Environments

Production = `main` → `deploy.yml`. No preview environment yet.

## Rollback

Revert the playground commit under `generated/<id>/` (does not revert other products) or revert the showcase app commit, then re-run deploy.

## Concurrency

Playground publishes share `showcase-generated-publish` (queue, no cancel). Pages deploys share `pages-deploy`.
