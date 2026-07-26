# content/projects

**Why:** Source-of-truth content for each RSProjects product shown in the portal.

**Owner:** Content authors + `scripts/generate_registry.dart` / CI.

**When:** Author metadata (and later markdown) before implementing catalog UI.

## Layout

Each project lives in its own folder:

```
content/projects/<project_id>/metadata.json
```

CI will later discover these folders and emit `generated/registry.json`.

## TODO

- [ ] Finalize metadata schema (`docs/CONTENT_MODEL.md`)
- [ ] Add optional `README.md` / body content per project
- [ ] Wire validation via `scripts/validate_content.dart`
