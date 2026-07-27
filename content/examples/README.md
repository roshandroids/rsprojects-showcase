# content/examples

**Why:** Portal cache of example metadata associated with a project via `projectId`.

**Owner:** Showcase maintainers (derived cache). **Long-term SSOT:** each product project’s `examples/` folder (via Integration Definition providers) — see [`docs/PROJECT_INTEGRATION.md`](../../docs/PROJECT_INTEGRATION.md).

Examples are supporting content for project pages — not a standalone app feature. Users discover them through `ExampleGallery` on project detail screens.

## Layout

```
content/examples/<example_id>/
  metadata.json
  assets/          # optional media referenced from metadata
```

## Authoring

1. Prefer adding runnable examples in the **product** project under `examples/`
2. Mirror portal cards here until Phase 3 provider sync lands
3. Create a folder matching the example `id`
4. Fill required fields: `id`, `title`, `description`, `projectId`, `category`
5. Run `dart run scripts/validate_content.dart`
6. Run `dart run scripts/generate_registry.dart`
