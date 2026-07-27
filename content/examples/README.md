# content/examples

**Why:** Independently authored example metadata associated with a project via `projectId`.

**Owner:** Content authors + `scripts/generate_registry.dart` / CI.

Examples are supporting content for project pages — not a standalone app feature. Users discover them through `ExampleGallery` on project detail screens.

## Layout

```
content/examples/<example_id>/
  metadata.json
  assets/          # optional media referenced from metadata
```

## Authoring

1. Create a folder matching the example `id`
2. Fill required fields: `id`, `title`, `description`, `projectId`, `category`
3. Run `dart run scripts/validate_content.dart`
4. Run `dart run scripts/generate_registry.dart`
