# Architecture

## Overview

RSProjects Showcase is a **Flutter Web–first**, cross-platform portal for discovering and presenting RSProjects products.

Layout is **feature-first** with shared core/platform layers. Adding a product is primarily a **content** change under `content/projects/`, not a UI fork.

## Layers

```
lib/
  app/             # bootstrap, router, theme, root widget (ProviderScope)
  design_system/   # FlexColorScheme tokens + reusable components
  core/            # constants, content schema, quality, errors, utilities
  features/        # home, projects, search, settings, about
  shared/          # layouts, animations, (planned) markdown
  generated/       # Dart codegen only — not the JSON registry
```

## Features

| Feature | Layers present | Notes |
|---------|----------------|-------|
| `home` | presentation | Brand-first landing; featured projects from registry |
| `projects` | presentation → application → domain → infrastructure | Catalog + generic `ProjectShowcaseTemplate` detail |
| `search` | presentation | Stub today; Phase 2.4 → `/search` + `DiscoveryQuery` |
| `settings` | presentation | Placeholder; theme persistence later |
| `about` | presentation | Placeholder copy |

## Content & discovery

```
content/projects/<id>/metadata.json
  → scripts/validate_content.dart
  → scripts/generate_registry.dart
  → assets/generated/registry.json
  → AssetRegistryProjectRepository
  → domain Project / ProjectShowcase
  → Riverpod catalog / detail
  → ProjectShowcaseTemplate
```

**Phase 2 (planned):** also `content/projects/<id>/docs/`, `media/`, and `content/collections/` → registry indexes. See [`docs/PHASE_2_SHOWCASE_EXCELLENCE.md`](docs/PHASE_2_SHOWCASE_EXCELLENCE.md).

**Phases 3–5 (planned):** automation/publishing, ecosystem intelligence, community & developer portal — [`docs/roadmap/`](docs/roadmap/).

## State management

**Riverpod** (`Notifier` / `AsyncNotifier` / `AsyncValue`) — D-009 Final.

- `projectsCatalogProvider` — list + filter/sort
- `projectByIdProvider` — detail by route id

Phase 2 planned: `DiscoveryNotifier`, docs/media providers.

## Navigation

`go_router` + `ShellRoute` (`AppShell`): `/`, `/projects`, `/projects/:id`, `/about`, `/settings`, 404.

Phase 2 planned: `/search`, `/projects/:id/docs` (+ optional path).

## Showcase template rule

All product pages share **one** generic template. UI must **never** branch on `project.id`. Demo embedding goes through a sealed `DemoSpec` (planned), not product-specific iframes.

## Non-goals

- No project-specific showcase forks
- No premature dependencies (add packages when a Phase 2 milestone needs them)
- No SaaS crash reporters yet (quality foundation uses GitHub Issues + email fallback)
- Hosting target still open (D-011)
