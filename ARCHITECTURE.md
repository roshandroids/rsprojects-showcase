# Architecture

## Overview

RSProjects Showcase is a **Flutter Web–first**, cross-platform portal for discovering and presenting RSProjects products.

Layout is **feature-first** with shared core/platform layers. Adding a product is primarily a **Project Integration** change (product SSOT → Integration Definition / providers → showcase cache → generated registry), not a UI fork.

## Layers

```
lib/
  app/             # bootstrap, router, theme, root widget (ProviderScope)
  design_system/   # FlexColorScheme tokens + reusable components
  core/            # constants, content schema, quality, errors, utilities
  features/        # home, projects, search, settings, about
  shared/          # layouts, animations, demos (DemoSpec), examples (gallery), (planned) markdown
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

**Project Integration (D-029):** The showcase integrates **projects** via provider-driven **Integration Definitions** under `content/integrations/`. A Git repository is one **Project Provider** among many. Onboarding workflow: [`docs/PROJECT_ONBOARDING.md`](docs/PROJECT_ONBOARDING.md). Architecture: [`docs/PROJECT_INTEGRATION.md`](docs/PROJECT_INTEGRATION.md).

```
Product Project (SSOT: showcase/, docs/, examples/, …)
  → content/integrations/<projectId>.json   # Integration Definition + providers
  → content/projects/ + content/examples/   # derived cache (manual sync today)
  → scripts/validate_content.dart
  → scripts/generate_registry.dart
  → assets/generated/registry.json          # projects[] + examples[]
  → AssetRegistryProjectRepository
  → domain Project / ProjectShowcase + shared ProjectExample
  → Riverpod catalog / detail
  → ProjectShowcaseTemplate + ExampleGallery(projectId)
```

**Phase 2 (remaining):** docs hub, project demo section via DemoSpec, search/collections, relations — see [`docs/PHASE_2_SHOWCASE_EXCELLENCE.md`](docs/PHASE_2_SHOWCASE_EXCELLENCE.md). Local `docs/` / `media/` under projects and `content/collections/` remain planned.

**D-027:** Examples are presented on project pages via shared `ExampleGallery` (supporting content — not a standalone app feature). Portal `content/examples/` is a cache; long-term SSOT is each product’s `examples/` (via providers).

**Phases 3–5 (planned):** automation/publishing (sync from Integration Definitions / providers), ecosystem intelligence, community & developer portal — [`docs/roadmap/`](docs/roadmap/).

## State management

**Riverpod** (`Notifier` / `AsyncNotifier` / `AsyncValue`) — D-009 Final.

- `projectsCatalogProvider` — list + filter/sort
- `projectByIdProvider` — detail by route id

Phase 2 planned: `DiscoveryNotifier`, docs/media providers.

## Navigation

`go_router` + `ShellRoute` (`AppShell`): `/`, `/projects`, `/projects/:id`, `/about`, `/settings`, 404.

Phase 2 planned: `/search`, `/projects/:id/docs` (+ optional path).

## Showcase template rule

All product pages share **one** generic template. UI must **never** branch on `project.id`. Demo embedding goes through a sealed `DemoSpec`, not product-specific iframes.

## Non-goals

- No project-specific showcase forks
- No premature dependencies (add packages when a Phase 2 milestone needs them)
- No SaaS crash reporters yet (quality foundation uses GitHub Issues + email fallback)
- Hosting target still open (D-011)
