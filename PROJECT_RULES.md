# Project Rules

## Architecture

- Feature-first Clean Architecture: UI → State → Domain → Data.
- UI must not access APIs or filesystems directly.
- DTOs stay in infrastructure; map to domain before UI.

## Scope discipline

- Do not implement business logic in bootstrap placeholders until a feature is scheduled.
- No dead folders; every directory has a documented purpose.
- Prefer refactoring existing structure over inventing parallel patterns.

## Dependencies

- Do not add packages unless required by an active feature.
- Prefer Flutter SDK primitives until routing / state / markdown needs are real.

## Content

- Project source of truth lives under `content/projects/`.
- `generated/registry.json` is produced by tooling/CI, not hand-edited for releases.

## Commits

TODO: Conventional Commits; keep PRs focused.
