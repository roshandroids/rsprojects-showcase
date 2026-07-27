# Content Model

## Project metadata

Each project lives at `content/projects/<id>/metadata.json`.

### Required fields

| Field | Type | Rules |
|-------|------|--------|
| `id` | string | Non-empty; must match folder name |
| `name` | string | Non-empty display name |
| `description` | string | Non-empty long description |
| `version` | string | Non-empty semver-like string |
| `status` | string | One of: `active`, `beta`, `experimental`, `archived` |
| `category` | string | One of: `platform`, `tool`, `library`, `app`, `other` |
| `platforms` | string[] | Non-empty; values from: `web`, `android`, `ios`, `macos`, `windows`, `linux` |
| `featured` | bool | Whether to highlight on Home |

### Optional fields

| Field | Type | Notes |
|-------|------|--------|
| `tagline` | string | Short one-liner (hero) |
| `repositoryUrl` | string | HTTPS URL — hero GitHub action |
| `demoUrl` | string | HTTPS URL — hero Demo action |
| `docsUrl` | string | HTTPS URL — hero Documentation action |
| `tags` | string[] | Free-form tags |
| `icon` | string | Asset path or icon key |
| `showcase` | object | Canonical presentation sections (see below) |

## Showcase framework (`showcase`)

Optional nested object. Every RSProjects product page uses the same template; sections render **only when content is present**. Future automation may populate these from docs and generated metadata.

| Section | Field | Type | Notes |
|---------|-------|------|--------|
| Hero | *(top-level)* | — | `name`, `tagline`, `status`, `platforms`, `demoUrl`, `repositoryUrl`, `docsUrl` |
| Problem Statement | `problem` | string | |
| Solution Overview | `solution` | string | |
| Key Features | `features` | `{title, description}[]` | |
| Interactive Demo | `demo` | `{url?, note?, available?}` | Placeholder when unavailable |
| Screenshots / Gallery | `screenshots` | `{src?, alt, caption?}[]` | `src` optional until assets land |
| Architecture Overview | `architecture` | string | |
| Technologies Used | `technologies` | string[] | |
| Platform Support | `platformSupport` | `{platform, notes?}[]` | Prefer allowed platform ids |
| Installation | `installation` | string | |
| Documentation Links | `documentationLinks` | `{label, url}[]` | Complements `docsUrl` |
| Examples / Playground | `examples` | `{title, description?, url?}[]` | Transitional project-page list. **D-027:** long-term examples are first-class content alongside projects (not project-owned assets only). |
| Benchmarks | `benchmarks` | `{label, value, note?}[]` | Optional |
| Roadmap | `roadmap` | `{item, status?}[]` | `status`: `planned` \| `in_progress` \| `done` |
| Changelog | `changelog` | `{version, date?, notes}[]` | |
| Related RSProjects | `relatedProjectIds` | string[] | Registry `id`s |
| Contributing | `contributing` | string | |

See also [`SHOWCASE_FRAMEWORK.md`](SHOWCASE_FRAMEWORK.md).

## Phase 2.1 — Rich Project Pages (**implemented**)

These showcase fields are validated, mapped, and rendered by `ProjectShowcaseTemplate` when present.

| Field | Type | Notes |
|-------|------|--------|
| `heroMedia` | `{kind, src?, alt?}` | `kind`: `image` \| `video` \| `lottie` — asset path optional (placeholder UI) |
| `media` | `{kind, src?, alt, caption?, poster?}[]` | Unified gallery; `kind`: `image` \| `video` \| `diagram`. Prefers over `screenshots` |
| `architectureDiagram` | `{kind?, src?, alt?, caption?}` | Optional diagram beside `architecture` |
| `features[].icon` | string | Optional icon key (`schema`, `export`, `workflow`, `platform`, …) |
| `features[].media` | media ref | Optional feature visual |
| `contributors` | `{name, role?, url?, avatar?}[]` | People section |
| `downloads` | `{label, url, platform?, checksum?}[]` | Download / release artifacts |

Legacy `screenshots[]` remains supported as a gallery fallback when `media` is empty.

## Phase 2.2–2.5 (planned) — not implemented yet

Planning brief: [`PHASE_2_SHOWCASE_EXCELLENCE.md`](PHASE_2_SHOWCASE_EXCELLENCE.md).

These fields and folders are **documented for future work**. Do not treat them as required by current validators or UI.

### Planned showcase extensions

| Field | Type | Notes |
|-------|------|--------|
| `demo.kind` | string | `embedded_web` \| `external` \| `media` \| omit → unavailable |
| `demo.embedUrl` | string | Used when `kind: embedded_web` |
| `demo.url` | string | Used when `kind: external` (complements top-level `demoUrl`) |
| `relations` | `{targetId, type}[]` | Ecosystem edges; see below |

**Relation `type` enum (planned):** `related` \| `depends_on` \| `depended_on_by` \| `shares_tech` \| `alternative`.

`relatedProjectIds` remains valid; Phase 2.5 prefers `relations[]` and may keep ids as a shorthand for `type: related`.

### Planned content folders

```
content/projects/<id>/
  metadata.json          # required today
  docs/                  # planned: README, guides/, tutorials/, examples/, CHANGELOG, ROADMAP, api/
  media/                 # planned: screenshots, videos, diagrams
```

### Planned collections (discovery)

```
content/collections/<collectionId>.json
```

Example shape (planned):

```json
{
  "id": "flutter-tooling",
  "name": "Flutter tooling",
  "description": "…",
  "projectIds": ["localization_analyzer"]
}
```

### Planned registry additions

```json
{
  "generatedAt": "ISO-8601",
  "projects": [ /* metadata + showcase */ ],
  "collections": [ /* optional */ ],
  "docsIndex": { "<projectId>": [ /* { title, path, type } */ ] }
}
```

Docs/markdown **bodies** stay on disk (or remote URLs); the registry holds indexes only.

### Planned validation additions

- Enum checks for `demo.kind`, `relations[].type` (2.2 / 2.5)
- When media/docs assets are referenced, validate path existence under `content/projects/<id>/media` or registered Flutter assets
- Collection `projectIds` must resolve to known project ids

`heroMedia.kind` and `media[].kind` enum checks are **implemented** (Phase 2.1).

### Later phases (planning only)

- **Phase 3:** authored vs generated boundaries, docs/media/demo artifact pipelines — [`docs/roadmap/PHASE_3_AUTOMATION.md`](roadmap/PHASE_3_AUTOMATION.md)
- **Phase 4:** `Technology`, `PackageReference`, `TimelineEvent`, richer relation indexes — [`docs/roadmap/PHASE_4_ECOSYSTEM.md`](roadmap/PHASE_4_ECOSYSTEM.md)
- **Phase 5:** portal/community content types (contributors, gallery, templates, engineering notes) — [`docs/roadmap/PHASE_5_DEVELOPER_PORTAL.md`](roadmap/PHASE_5_DEVELOPER_PORTAL.md)

## Registry output

`assets/generated/registry.json` (produced by `scripts/generate_registry.dart`, bundled via `pubspec.yaml`):

```json
{
  "generatedAt": "ISO-8601",
  "projects": [ /* full metadata objects including showcase */ ]
}
```

## Validation

Run `dart run scripts/validate_content.dart` before generating the registry.

Required catalog fields are always validated. When `showcase` is present, structural types are checked; individual showcase sections remain optional.

## Ownership

Project owners maintain their `content/projects/<id>/` folder. CI regenerates the registry; do not hand-edit `assets/generated/registry.json` for releases.
