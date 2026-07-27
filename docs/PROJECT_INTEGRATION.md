# Project Integration

How RSProjects Showcase integrates **projects** through a provider-driven **Integration Definition** — without becoming the authoritative source of project information.

Related: [`CONTENT_MODEL.md`](CONTENT_MODEL.md), [`SHOWCASE_FRAMEWORK.md`](SHOWCASE_FRAMEWORK.md), Phase 3 automation in [`roadmap/PHASE_3_AUTOMATION.md`](roadmap/PHASE_3_AUTOMATION.md).

## Goal

The showcase integrates **projects**, not only Git repositories.

A repository is **one Project Provider** among many. Future information may also come from documentation sites, demo hosts, pub.dev, GitHub Releases, benchmarks, websites, generated assets, design-system surfaces, API references, and other sources — each as another provider in the **same** integration record.

Automation (`fetch_projects`, GitHub Actions) is **not** required for this architecture. Manual sync is the current bridge.

```
Product Project (SSOT)
  → Integration Definition (content/integrations/<projectId>.json)
  → Showcase cache (content/projects/, content/examples/)
  → Generated registry (assets/generated/registry.json)
  → Presentation (ProjectShowcaseTemplate, ExampleGallery, …)
```

## Pattern — reusable, provider-extensible

**Project Integration** is a reusable architectural pattern:

1. Identify a **project** (stable `projectId`).
2. Declare an **Integration Definition** listing available **Project Providers**.
3. Let the showcase **consume** derived/generated data — never own the narrative SSOT.
4. Add new capability types (design-system site, API reference, benchmark dashboard, …) by adding a **provider key** to the same record — not by inventing a parallel concept.

```
Project
  └── Providers
        ├── repository
        ├── documentation
        ├── demo
        ├── package
        ├── website
        ├── releases
        ├── benchmarks
        └── (future keys)
```

Omit any provider until it exists. No provider is required except what the project actually has.

## Ownership (three layers)

```
Product Project
      ↓
Integration Definition
      ↓
Showcase
```

### Product Project

Owns (wherever it lives — typically a product codebase):

- source code
- documentation
- showcase contract (`showcase/`)
- examples
- media
- releases / changelogs

### Integration Definition

Describes (in the showcase repo under `content/integrations/`):

- which providers are available
- where each provider’s information comes from
- sync strategy notes (manual today; fetch later)
- provenance for the portal cache

### Showcase

Consumes:

- generated registry
- provider-backed cache entries
- presentation models / templates

**The showcase must never become the authoritative source of project information.**

## Showcase contract (in the product project)

Every **integrated** project should expose:

```
showcase/
  metadata.json     # required — catalog + showcase sections
  README.md         # required — points at this contract
  media/            # required root — assets optional until available
  schema.json       # future — shared validation schema
  examples.json     # future — example index for gallery sync
```

Initially implement only `metadata.json`, `README.md`, and `media/`. Document the rest as future capabilities.

`metadata.json` shape matches portal project metadata in [`CONTENT_MODEL.md`](CONTENT_MODEL.md). Prefer a `repositoryUrl` (or other provider URLs) that point at the **product**, not the showcase app.

### Shared schema (documented only)

Future: `showcase/schema.json` in each product (or a shared published schema) to:

- validate showcase metadata
- enforce consistency across projects
- enable CI validation
- keep projects aligned

**Do not implement validation against `schema.json` in this milestone.** Portal validation remains [`content_schema.dart`](../lib/core/content/content_schema.dart) on the showcase cache.

## Integration Definition

Authoritative provider map (not a second README):

```
content/integrations/
  README.md
  <projectId>.json
```

### Record shape

```json
{
  "projectId": "document_platform",
  "displayName": "Document Platform",
  "status": "integrated",
  "providers": {
    "repository": {
      "gitUrl": "https://github.com/roshandroids/Document_Platform",
      "defaultBranch": "main",
      "localDevPath": "../research_projects/Document_Platform",
      "paths": {
        "readme": "README.md",
        "license": "LICENSE",
        "pubspec": "pubspec.yaml",
        "docs": "docs/",
        "examples": "examples/",
        "showcaseMetadata": "showcase/metadata.json",
        "media": "showcase/media/",
        "changelog": "docs/release/"
      }
    },
    "documentation": {
      "docsUrl": "https://github.com/roshandroids/Document_Platform/blob/main/docs/INDEX.md",
      "wikiUrl": "https://github.com/roshandroids/Document_Platform/wiki"
    },
    "demo": {},
    "package": {},
    "website": {},
    "releases": {},
    "benchmarks": {}
  },
  "notes": "…"
}
```

| Field | Required | Notes |
|-------|----------|--------|
| `projectId` | yes | Stable id; matches portal `project.id` |
| `displayName` | yes | Human name |
| `status` | yes | `registered` \| `integrated` \| `deferred` |
| `providers` | yes | Map of provider id → config object (may be empty `{}` as a stub) |
| `notes` | no | Integration caveats |

**Status**

- `registered` — integration defined; product showcase contract and/or providers incomplete
- `integrated` — product `showcase/` present; portal cache provenance-aware; core providers populated
- `deferred` — known project, integration postponed

### Known provider keys

| Provider | Role | Examples of config |
|----------|------|-------------------|
| `repository` | Git / source tree | `gitUrl`, `paths`, `localDevPath`, `packagePath` |
| `documentation` | Docs hub / sites | `docsUrl`, `wikiUrl`, site base URL |
| `demo` | Live / hosted demos | `demoUrl`, `embedUrl`, DemoSpec hints |
| `package` | Package indexes | pub.dev name, version URL |
| `website` | Marketing / product site | `url` |
| `releases` | Release artifacts | GitHub Releases API, download index |
| `benchmarks` | Perf / quality dashboards | report URL, artifact path |

Add new keys in the same `providers` object when a new source type appears (e.g. `designSystem`, `apiReference`). No new top-level integration concept required.

Entries under `content/integrations/` are **not** merged into `assets/generated/registry.json` today (architecture + future sync input).

## Portal cache provenance

Cached project metadata may include:

```json
"integration": {
  "projectId": "document_platform",
  "source": "project-cache"
}
```

| Field | Notes |
|-------|--------|
| `projectId` | Matches `content/integrations/<projectId>.json` |
| `source` | `project-cache` (derived from product providers) \| `showcase-authored` (portal-only until contract lands) |

Legacy value `repository-cache` remains accepted by validators as an alias of `project-cache`. Legacy `repositoryId` is accepted as an alias of `projectId`.

## Document Platform reference

**Status:** `integrated`

- Integration Definition: [`content/integrations/document_platform.json`](../content/integrations/document_platform.json)
- Product contract: Document_Platform `showcase/`
- Portal cache: [`content/projects/document_platform/metadata.json`](../content/projects/document_platform/metadata.json)

Localization Analyzer and AI Tray are **registered** (providers partially filled; product `showcase/` not required yet).

## Checklist — integrating another project

1. Add `content/integrations/<projectId>.json` with the providers you know
2. Add product `showcase/metadata.json` (+ README + media/) when ready to mark `integrated`
3. Mirror into `content/projects/<projectId>/metadata.json` with `integration` provenance
4. Optionally cache examples under `content/examples/` until provider sync lands
5. Run `dart run scripts/validate_content.dart` and `dart run scripts/generate_registry.dart`

## Out of scope (this refinement)

- Implementing fetch / GitHub Actions
- Runtime consumption of `content/integrations/`
- Implementing `showcase/schema.json` validation
- Changing app presentation behavior
