# CI / CD

## Pipelines

| Workflow | Role |
|----------|------|
| `ci.yml` | Quality gates (format → analyze → tests → content → cross-platform build stubs) |
| `deploy.yml` | Release / hosting (after gates) |
| `fetch-projects.yml` | Content sync / registry generation |

Details: [`docs/quality/QUALITY_GATES.md`](quality/QUALITY_GATES.md).

## Quality gates

Documented architecture:

Format → Analyze → Unit → Widget → Golden → Integration → Content Validation → Cross-Platform Build → Deployment.

Implementation of real commands is TODO; branch protection should eventually require green CI.

## Content pipeline

TODO: fetch → validate → generate registry → PR/commit.

## Secrets

TODO: List required secrets and where they are stored.

## Branching

TODO: Document branch protection and required checks once gates are live.
