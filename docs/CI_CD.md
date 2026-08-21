# CI / CD

## Pipelines

| Workflow | Role |
|----------|------|
| `ci.yml` | Quality gates (stubs today; see QUALITY_GATES.md) |
| `deploy.yml` | Build showcase web + copy `generated/` → GitHub Pages |
| `fetch-projects.yml` | Content sync / registry generation (placeholder) |

Playground hosting: [`PLAYGROUNDS.md`](PLAYGROUNDS.md).

## Quality gates

Format → Analyze → Unit → Widget → Golden → Integration → Content Validation → Cross-Platform Build → Deployment.

Real commands in `ci.yml` are still TODO; `deploy.yml` already validates content and regenerates the registry.

## Content pipeline

1. Authors update `content/projects/` / integrations (manual today).
2. `validate_content.dart` / `generate_registry.dart` (also on Pages deploy).
3. platform-ci publishes playground artifacts into `generated/<id>/` only.

## Secrets

| Secret | Where | Why |
|--------|-------|-----|
| GitHub Pages `id-token` | this repo | OIDC for `actions/deploy-pages` |

Private projects store `SHOWCASE_PUSH_TOKEN` on **their** repos (fine-grained PAT: `roshandroids/rsprojects-showcase` only, Contents: Read and write). This public repo does not receive that secret and does not authenticate private publishers.

## Concurrency

- `pages-deploy`: latest showcase site deploy wins.

## Branching

TODO: required checks once `ci.yml` is real.
