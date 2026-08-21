# ADR 001 — Global Playground Publishing Contract

**Status:** Accepted (architecture lock)  
**Date:** 2026-08-21

This records a lock, not a menu of alternatives.

## Decisions

1. **platform-ci builds private playgrounds.** Quality, Flutter Web `--release`, and publish belong there.
2. **project_showcase never accesses private source.** No checkout of private repos, no private CI logic.
3. **project_showcase is the public catalog and GitHub Pages host.**
4. **`generated/<id>/` is the canonical hosted artifact location** in `rsprojects-showcase`.
5. **`deploy.showcase.id` is the stable cross-repository identifier.**
6. **Consumers do not configure repository, path, or base href.** Only `deploy.showcase.enabled` and `deploy.showcase.id`.
7. **platform-ci calculates the base href:** `/rsprojects-showcase/generated/<id>/`.
8. **Each deployment may modify only its own `generated/<id>/` directory.**
9. **`showcase.json` is the deployment metadata record** (`id`, `version`, `commit`, `deployedAt`).
10. **GitHub Pages hosts both the showcase application and the playgrounds.**

## Consumer contract

```yaml
deploy:
  showcase:
    enabled: true
    id: <kebab-id>
```

## Consequences

- Changing destination, path layout, metadata shape, or consumer fields requires a new ADR.
- `deploy.demos` / `pages` / `firebase` remain separate sinks.
