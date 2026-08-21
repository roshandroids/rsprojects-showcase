# ADR 001 — Global Playground Publishing Contract

**Status:** Accepted (architecture lock)  
**Date:** 2026-08-21

This records a lock, not a menu of alternatives.

## Decisions

1. **platform-ci is the sole publisher** of private playground builds (quality, Flutter Web `--release`, artifact validation, `showcase.json`, push to `generated/<id>/`).
2. **rsprojects-showcase never accesses private source** and **does not implement a playground receiver workflow**.
3. **rsprojects-showcase is the public catalog and GitHub Pages host.**
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

- `rsprojects-showcase` has no `receive-playground` workflow. Callers use platform-ci `deploy-showcase.yml`.
- `deploy.demos` / `pages` / `firebase` remain separate sinks.
