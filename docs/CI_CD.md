# CI / CD

## Pipelines

| Workflow | Role |
|----------|------|
| `ci.yml` | Quality gates (stubs today; see QUALITY_GATES.md) |
| `deploy.yml` | Build showcase web + copy `generated/` → GitHub Pages |
| `receive-playground.yml` | Callable: publish one `generated/<id>/` from a web artifact |
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
| `SHOWCASE_PUSH_TOKEN` | **Private** product repo (or platform-ci caller) | Fine-grained PAT, Contents: Read and write on this public repo only |
| GitHub Pages `id-token` | this repo | OIDC for `actions/deploy-pages` |

This public repo never stores private-source tokens.

## Concurrency

- `showcase-generated-publish`: serialize playground commits (`cancel-in-progress: false`) + rebase retry.
- `pages-deploy`: latest showcase site deploy wins.

## Branching

TODO: required checks once `ci.yml` is real.
