# Content Model

Project and example schemas for the portal cache and generated registry.

**Project Integration:** Product projects own source, docs, examples, and `showcase/metadata.json`. The showcase holds **Integration Definitions** (`content/integrations/`) describing **Project Providers**, plus a **derived cache** under `content/projects/` and `content/examples/` until sync automation lands. See [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md).

## Project metadata

Each project cache entry lives at `content/projects/<id>/metadata.json` (mirrored from the product project’s `showcase/metadata.json` when integrated).

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
| `repositoryUrl` | string | HTTPS URL — typically the repository **provider** |
| `demoUrl` | string | HTTPS URL — hero Demo action / demo provider |
| `docsUrl` | string | HTTPS URL — hero Documentation / documentation provider |
| `tags` | string[] | Free-form tags |
| `icon` | string | Asset path or icon key |
| `showcase` | object | Canonical presentation sections (see below) |
| `integration` | object | Provenance for Integration Definition–backed cache (see below) |

### Integration provenance (`integration`)

Optional object on cached project metadata:

| Field | Type | Notes |
|-------|------|--------|
| `projectId` | string | Matches `content/integrations/<projectId>.json` |
| `source` | string | `project-cache` (derived from product providers) \| `showcase-authored` (portal-only until contract lands). Legacy: `repository-cache`, `repositoryId` still accepted by validators. |

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
| Examples / Playground | — | — | **Moved:** see [Project examples](#project-examples-implemented) (`content/examples/`). Soft-deprecated nested `showcase.examples[]` is still validated if present but not rendered. |
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

## Project examples (**implemented**)

Examples are **supporting content** for projects — discovered on project pages (not a standalone app feature).

**SSOT:** Product project `examples/<id>/` (via Integration Definition providers — see [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md)).  
**Portal cache today:** `content/examples/<example-id>/` until Phase 3 sync.

```
content/examples/<example-id>/
  metadata.json
  assets/                 # optional media referenced from metadata
```

### Required fields

| Field | Type | Rules |
|-------|------|--------|
| `id` | string | Non-empty; must match folder name |
| `title` | string | Non-empty display title |
| `description` | string | Non-empty |
| `projectId` | string | Must resolve to a known project id |
| `category` | string | One of: `demo`, `tutorial`, `template`, `sample`, `other` |

### Optional fields

| Field | Type | Notes |
|-------|------|--------|
| `tags` | string[] | Free-form tags |
| `featured` | bool | Prefer ordering in galleries |
| `demo` | object | DemoSpec metadata (`kind`, `url` / `embedUrl`, `available`, `note`) |
| `media` | media[] | Same shape as showcase `media` (image/video/diagram) |
| `documentationLinks` | `{label, url}[]` | Example-specific docs |
| `sourceUrl` | string | Source / sample repo URL |
| `demoUrl` | string | Shorthand external demo URL |

Each example belongs to **exactly one** project via `projectId`.

### DemoSpec (`demo`)

| `kind` | Fields | Domain |
|--------|--------|--------|
| `embedded_web` | `embedUrl` | `DemoEmbeddedWeb` |
| `external` | `url` | `DemoExternalLink` |
| `media` | uses `media[]` | `DemoMediaFallback` |
| omit / `available: false` | `note?` | `DemoUnavailable` |

Shared UI: `DemoPane` / `ExampleGallery` under `lib/shared/demos/` and `lib/shared/examples/`.

## Integration Definitions (**implemented**)

Provider maps for integrated projects (not a second copy of product content):

```
content/integrations/<projectId>.json
```

See [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md) for provider keys, ownership layers, and the Document Platform reference. Entries are **not** currently merged into `assets/generated/registry.json` (architecture + future sync input).

New source types (design-system site, API reference, benchmark dashboard, …) are additional keys under `providers` — not new top-level concepts.

## Phase 2.2–2.5 (planned) — not implemented yet

Planning brief: [`PHASE_2_SHOWCASE_EXCELLENCE.md`](PHASE_2_SHOWCASE_EXCELLENCE.md).

These fields and folders are **documented for future work**. Do not treat them as required by current validators or UI.

### Planned showcase extensions

| Field | Type | Notes |
|-------|------|--------|
| `demo.kind` | string | Prefer shared `DemoSpec` (also used by examples). Project showcase demo section may still use legacy `{url, note, available}` until full 2.2 wiring. |
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
  "examples": [ /* project-associated examples — implemented */ ],
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
  "projects": [ /* full metadata objects including showcase */ ],
  "examples": [ /* full example metadata objects */ ]
}
```

## Validation

Run `dart run scripts/validate_content.dart` before generating the registry.

Required catalog fields are always validated. When `showcase` is present, structural types are checked; individual showcase sections remain optional. Example folders under `content/examples/` are validated when present (`projectId` must resolve).

## Ownership

| Layer | Who maintains |
|-------|----------------|
| Product project (`showcase/`, `docs/`, `examples/`, …) | Product owners (SSOT) |
| `content/integrations/<projectId>.json` | Showcase maintainers (Integration Definition / providers) |
| `content/projects/<id>/`, `content/examples/<id>/` | Derived cache — sync from product providers; portal-only until contract lands |
| `assets/generated/registry.json` | Generated only — do not hand-edit for releases |

See [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md).
