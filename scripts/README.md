# scripts/

**Why:** Developer and CI tooling for content discovery, validation, registry generation, and publish.

**Owner:** Tooling / platform.

**When:** Implement scripts when content pipeline and deploy target are defined.

## Scripts

| Script | Future responsibility |
|--------|------------------------|
| `fetch_projects.dart` | Pull / sync project sources into content |
| `generate_registry.dart` | Build `assets/generated/registry.json` from content |
| `validate_content.dart` | Validate metadata + asset references |
| `publish.dart` | Build and deploy the Flutter web app |

## TODO

- [ ] Agree CLI flags and exit codes
- [ ] Wire scripts into GitHub Actions workflows
- [ ] Document local usage in `docs/GETTING_STARTED.md`
