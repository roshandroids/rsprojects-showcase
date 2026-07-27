# PROJECT_STATUS.md

> **Canonical operational dashboard and project source of truth.**  
> Share this file for planning, architecture reviews, and progress sync.  
> Update whenever significant work lands so reviews stay accurate without scanning the whole repo.

| Meta | Value |
|------|--------|
| **Last updated** | 2026-07-26 |
| **Document owner** | Project maintainers |
| **Status vocabulary** | `Not Started` · `In Progress` · `Blocked` · `Complete` |
| **Supporting docs** | `docs/GOVERNANCE.md` (core), `ARCHITECTURE.md`, `ROADMAP.md`, `PROJECT_RULES.md`, `docs/*` (not status SSOT) |

---

# Project Overview

## Vision

RSProjects Showcase is the public portal for discovering and presenting all RSProjects products. **Web is the primary deployment target**, but the app is architected as a **cross-platform Flutter application** (Web, Android, iOS, macOS, Windows, Linux). It should scale to dozens of projects via content-driven discovery (metadata → generated registry → catalog UI), not hardcoded product lists.

## Current objective

Phase 2.1 Rich Project Pages and project example infrastructure are **Complete**. **Project Integration Framework** is **Complete** (provider-driven Integration Definitions + Document Platform validated). Next: Phase 2.2 Interactive Demos — wire project showcase demo section through `DemoSpec`/`DemoPane` under the execution-first policy ([`docs/GOVERNANCE.md`](docs/GOVERNANCE.md) §2a). Provider sync automation remains Phase 3. Long-term Phases 3–5 remain planning-only under [`docs/roadmap/`](docs/roadmap/).

## Repository information

| Field | Value |
|-------|--------|
| Package name | `rsprojects_showcase` |
| Version | `0.0.1+1` |
| Platforms | Web (primary), Android, iOS, macOS, Windows, Linux |
| Flutter / Dart | Flutter 3.44.x / Dart SDK `^3.12.2` |
| GitHub | https://github.com/roshandroids/rsprojects-showcase |
| Remote | `git@roshandroids.github.com:roshandroids/rsprojects-showcase.git` |
| Default branch | `main` |
| Latest remote commit | See git log / GitHub |
| Latest local milestone | Project Integration Framework |
| Working tree | See Recent Changes |

---

# Milestones

| Phase | Name | Status | Outcome |
|-------|------|--------|---------|
| 0 | Architecture bootstrap | **Complete** | Folders, placeholders, docs, scripts, workflow stubs, tests, GitHub connected |
| 1 | Application shell | **Complete** | `go_router`, `MaterialApp.router`, responsive `AppShell`, nav, placeholders, 404 |
| 1b | Design system / FlexColorScheme | **Complete** | Custom brand palette, token files, light/dark themes, semantic colors |
| 1c | Quality Engineering Foundation | **Complete** | Testing strategy, crash/diagnostics/feedback abstractions, quality docs, CI gate architecture |
| 1d | Experience Foundation | **Complete** | Design-system components, content pipeline, Riverpod catalog/detail, Home sections, Document Platform featured |
| 1.5 | Showcase Content Framework | **Complete** | Canonical project page template; conditional sections from `showcase` metadata; automation-ready schema |
| 2.0 | Showcase Excellence — planning | **Complete** | Roadmap + Phase 2 brief + planned schema/abstractions (no feature UI yet) |
| 2.1 | Rich Project Pages | **Complete** | `heroMedia`, `media[]`, architecture diagram, feature icons/media, contributors, downloads; Document Platform reference |
| 2.1b | Project example infrastructure | **Complete** | `content/examples/` → registry `examples[]`; shared `DemoSpec`/`DemoPane`/`ExampleGallery`; Document Platform + Localization Analyzer |
| 2.1c | Project Integration Framework | **Complete** | Provider-driven Integration Definitions (`content/integrations/`); Document Platform `showcase/` SSOT; Localization Analyzer + AI Tray registered |
| 2.2–2.5 | Showcase Excellence — remaining | **Planned** | Project demo section via DemoSpec, docs hub, search/discovery, ecosystem navigation |
| 3 | Automation & Publishing | **Planned** | Self-maintaining generate/validate/publish; see `docs/roadmap/PHASE_3_AUTOMATION.md` |
| 4 | Ecosystem Intelligence | **Planned** | Graphs, explorers, timeline; see `docs/roadmap/PHASE_4_ECOSYSTEM.md` |
| 5 | Community & Developer Portal | **Planned** | Community + develop portal; see `docs/roadmap/PHASE_5_DEVELOPER_PORTAL.md` |

**Long-term:** Adding a product is primarily Project Integration (`content/integrations/` providers + product `showcase/`) plus a derived content cache; CI produces the registry the app consumes. Provider sync automation is Phase 3.

---

# Current Sprint

> One active focus at a time. Keep this section short; move finished items into Recent Changes / Milestones.

| Field | Value |
|-------|--------|
| **Sprint name** | Project Integration Framework |
| **Goal** | Provider-driven Project Integration; validate Document Platform as SSOT |
| **Status** | Complete |

## Active tasks

| Task | Status | Owner |
|------|--------|-------|
| Write `docs/PROJECT_INTEGRATION.md` (providers + ownership) | Complete | — |
| Add `content/integrations/` for three products | Complete | — |
| Place Document Platform `showcase/` contract + align portal cache | Complete | — |
| Refactor terminology (Repository → Project Integration) | Complete | — |
| Update ARCHITECTURE / CONTENT_MODEL / PROJECT_STATUS | Complete | — |

## Exit criteria

Sprint is done when all of the following are true:

- [x] Project Integration contract, providers, and ownership documented
- [x] Three projects registered under `content/integrations/`
- [x] Document Platform contains `showcase/` and accurate git URL
- [x] Portal Document Platform entry is provenance-aware (`integration`)
- [x] No fetch automation / GitHub Actions implemented
- [x] Local content still validates and regenerates the registry

---

# Current Status

## Complete

- Flutter Web project scaffold (`pubspec.yaml`, `web/`, analysis/lints)
- Feature-first folder architecture under `lib/`
- App entry: `main` → `bootstrap` → `RsProjectsShowcaseRoot` (`ProviderScope` + app)
- **Milestone 1 — Application shell:** routing, responsive shell, navigation, 404
- **Design system foundation:** FlexColorScheme + tokens + reusable components (`AppButton`, `AppCard`, `AppBadge`, `AppChip`, `AppSectionHeader`, async states, `AppNavBar`/`AppFooter`, `AppPage`/`AppGrid`)
- **Cross-platform foundation:** Android, iOS, macOS, Windows, Linux runners (D-018)
- **Quality Engineering Foundation:** `lib/core/quality/*`, `docs/quality/*`, CI gate stubs
- **Content pipeline:** locked `CONTENT_MODEL`, `validate_content` / `generate_registry`, three filled projects, `assets/generated/registry.json` asset
- **Projects stack:** domain + DTO/mapper + `AssetRegistryProjectRepository` + Riverpod catalog/detail (search/filter/sort)
- **Home landing:** brand-first hero, featured from registry, principles/tech/open source/community/CTA
- **Showcase Content Framework:** `ProjectShowcase` domain, nested metadata, generic template with conditional sections (hero → contributing)
- Unit + widget tests green (`flutter test`)
- **Phase 2.0 planning lock:** `ROADMAP.md`, `docs/PHASE_2_SHOWCASE_EXCELLENCE.md`, planned schema notes, decisions D-023–D-026
- **Long-term roadmap Phases 3–5:** Automation & Publishing, Ecosystem Intelligence, Community & Developer Portal (`docs/roadmap/`)
- **Project governance:** `docs/GOVERNANCE.md` (core how-we-manage doc)
- **Phase 2.1 Rich Project Pages:** hero media, unified gallery, architecture diagram, feature icons/media, contributors, downloads; Document Platform reference fill
- **Project example infrastructure:** `content/examples/`, registry `examples[]`, shared `DemoSpec`/`DemoPane`/`ExampleGallery`; Document Platform + Localization Analyzer samples
- **Project Integration Framework:** provider-driven Integration Definitions (`content/integrations/`), Document Platform `showcase/` SSOT + portal provenance cache
- **UI refresh (D-028):** FlexScheme.tealM3 Material 3 theme, elevated cards/home/detail surfaces, hover motion

## In Progress

- None

## Blocked

- None

## Not Started

- Phase 2.2–2.5 remaining (project demo section via DemoSpec, docs hub, search, ecosystem)
- Full CI quality gate implementation (real format/analyze/test/build steps)
- Friendly error UI wiring beyond placeholder presenter
- Clipboard / URL launcher ports for diagnostics & feedback
- Theme persistence settings UI
- Hosting selection and production deploy
- Optional bundled brand font assets
- Remote `fetch_projects` automation

---

# Architecture

## Folder structure summary

```
lib/
  app/           bootstrap, root app, router, theme re-export
  design_system/ FlexColorScheme theme + tokens (colors, typography, spacing, radius, breakpoints, motion)
  core/          constants, content schema, quality, extensions, services, errors, utilities
  features/
    home/        presentation
    projects/    presentation, application, domain, infrastructure
    search/      presentation
    settings/    presentation
    about/       presentation
  shared/        demos (DemoSpec/DemoPane), examples (gallery), layouts, widgets, animations
  generated/     reserved for Dart codegen (README only)

assets/generated/registry.json   # projects[] + examples[]
content/projects/<id>/metadata.json   # derived cache
content/examples/<id>/metadata.json   # derived cache
content/integrations/<projectId>.json  # Integration Definition + providers (D-029)
scripts/         validate_content, generate_registry (+ fetch/publish stubs)
.github/workflows/  ci.yml, deploy.yml, fetch-projects.yml
docs/            CONTENT_MODEL, PROJECT_INTEGRATION, SHOWCASE_FRAMEWORK, governance, quality, roadmap
test/            unit + widget tests
```

## Dependencies

**Runtime**

- `flutter` (SDK)
- `go_router: ^17.3.0`
- `flex_color_scheme: ^8.4.0`
- `flutter_riverpod: ^3.4.1`

**Dev**

- `flutter_test` (SDK)
- `flutter_lints: ^6.0.0`

**Explicitly deferred**

- Markdown rendering
- `integration_test` SDK package
- Optional bundled brand fonts (typography currently uses cross-platform stacks)
- `url_launcher` (detail links shown as selectable URLs for Phase 1)

## Current routing

| Field | Value |
|-------|--------|
| Status | Complete |
| Notes | `MaterialApp.router` + `go_router`. Routes: `/`, `/projects`, `/projects/:id`, `/about`, `/settings`, plus 404 via `errorBuilder`. ShellRoute hosts `AppShell`. |

## Theme status

| Field | Value |
|-------|--------|
| Status | Complete (foundation + components) |
| Notes | `lib/design_system/` — FlexScheme.tealM3 + FlexColorScheme M3 sub-themes (D-028); semantic colors via `AppSemanticColors`. Reusable components under `components/`. Brand guidance in `docs/BRAND.md`. |

---

# Decisions

> Canonical decision log. Append rows; do not rewrite history. Open items stay in **Open questions** until decided.

| ID | Date | Decision | Rationale | Status |
|----|------|----------|-----------|--------|
| D-001 | 2026-07-26 | Feature-first Clean Architecture (UI → State → Domain → Data) | Scales per-product work; matches RSProjects Flutter standards | Final |
| D-002 | 2026-07-26 | Content-driven discovery: `content/projects` → `generate_registry` → registry JSON asset | Adding products should be content + CI, not hardcoded lists | Final |
| D-003 | 2026-07-26 | No premature dependencies; add packages only when a feature needs them | Keeps bootstrap lean; avoids speculative architecture | Final |
| D-004 | 2026-07-26 | No business logic in bootstrap placeholders | Structure first; implement incrementally | Final |
| D-005 | 2026-07-26 | `projects` gets full layers first; other features start at presentation | Catalog is the primary surface; avoid empty layer trees elsewhere | Final |
| D-006 | 2026-07-26 | DTOs never used directly in UI; mapping layer mandatory | Clean Architecture boundary | Final |
| D-007 | 2026-07-26 | `PROJECT_STATUS.md` is the single source of truth for project operational state | One file for planning/reviews; other docs are supporting | Final |
| D-008 | 2026-07-26 | Dual generated locations: `lib/generated/` (Dart codegen) vs registry JSON under `assets/generated/` (was root `generated/`) | Separates codegen from bundled content registry | Final |
| D-009 | 2026-07-26 | Riverpod (Notifier / AsyncNotifier / AsyncValue) for application state | Aligns with RSProjects standards; catalog uses AsyncNotifier + AsyncValue | Final |
| D-010 | 2026-07-26 | Use `go_router` with `MaterialApp.router` + `ShellRoute` | Declarative routing, deep links, shared shell | Final |
| D-011 | — | Hosting target (GitHub Pages / Firebase / Cloudflare / other) | Required before real deploy | Open |
| D-012 | — | Repository license | Public repo needs a chosen license | Open |
| D-013 | 2026-07-26 | Theme tokens centralized (superseded by D-015 location) | No hardcoded colors/magic layout numbers in features | Final |
| D-014 | 2026-07-26 | Top nav: Home / Projects / About; Settings via footer | Keeps primary nav focused | Final |
| D-015 | 2026-07-26 | Use FlexColorScheme as Material 3 theme engine with custom brand `FlexSchemeColor` (no predefined Flex schemes) | Scalable theming; light/dark from one palette | **Superseded by D-028** |
| D-016 | 2026-07-26 | Design system lives in `lib/design_system/` (token files + barrel) for future `rsprojects_design_system` extraction | Reuse across RSProjects | Final |
| D-017 | 2026-07-26 | Semantic colors exposed via `AppSemanticColors` ThemeExtension + ColorScheme | Prefer semantics over raw Flutter colors | Final |
| D-018 | 2026-07-26 | **Cross-platform architecture (Web-first)** — support Web, Android, iOS, macOS, Windows, Linux; Web is primary deploy target | Showcase must compile on all Flutter platforms; isolate platform code behind abstractions; evaluate deps for multi-platform support | Final |
| D-019 | 2026-07-26 | **Quality Engineering Foundation** — testing strategy, regression policy, CI quality gates, crash/diagnostics/feedback, a11y, performance budgets | Quality is a core product feature; GitHub Issues primary; email fallback; no SaaS crash reporters yet | Final |
| D-020 | 2026-07-26 | **Regression policy** — no bug fix without a regression test | Prevents defect recurrence | Final |
| D-021 | 2026-07-26 | **Friendly error experience** — never ship default Flutter release red screen as UX | Restart / diagnostics / report actions; thank-you after feedback | Final |
| D-022 | 2026-07-26 | Accessibility is a default quality requirement | Build a11y into components; do not retrofit only | Final |
| D-023 | 2026-07-26 | **DemoSpec** sealed variants: `embedded_web` / `external` / `media` / unavailable | Generic demos; never hardcode product iframes | Final (shared impl shipped; project showcase demo section wiring remains 2.2) |
| D-024 | 2026-07-26 | Docs hub **local-first** under `content/projects/<id>/docs/` (+ media/); registry holds docs index only | Content-driven hub; automation-ready | Final (implement in 2.3) |
| D-025 | 2026-07-26 | Dedicated `/search` with shared **DiscoveryQuery** (catalog + search) | One query model; scalable discovery | Final (implement in 2.4) |
| D-026 | 2026-07-26 | Typed ecosystem **relations[]** + soft links from shared tech/tags | Reusable ecosystem navigation | Final (implement in 2.5) |
| D-027 | 2026-07-26 | **Examples** on project pages via `ExampleGallery` (supporting content). Portal `content/examples/` is cache; long-term SSOT: product `examples/` via providers | Projects stay primary UX | Final |
| D-028 | 2026-07-26 | **UI theme:** FlexScheme.`tealM3` + Material 3 FlexSubThemes (blend ~14–16, surface app bar, standard density, card/button/chip radii) | Premium developer-centric showcase; stay within Material 3 / FlexColorScheme | Final |
| D-029 | 2026-07-26 | **Project Integration** (provider-driven): product projects own SSOT; Integration Definitions in `content/integrations/` declare providers (repository is one of many); showcase consumes derived cache until Phase 3 sync | Extensible without new concepts per source type; Document Platform is the reference integrate | Final |

---

# Features

Status values: `Not Started` · `In Progress` · `Blocked` · `Complete`

| Feature | Status | Layers present | Notes |
|---------|--------|----------------|-------|
| home | Complete | presentation | Brand-first hero, featured from registry, principles/tech/open source/community/CTA |
| projects | Complete | presentation, application, domain, infrastructure | Registry catalog + generic `ProjectShowcaseTemplate` detail (conditional sections) |
| search | Not Started | presentation | Catalog-local today; Phase 2.4 plans dedicated `/search` + DiscoveryQuery |
| settings | In Progress | presentation | Shell-hosted placeholder; linked from footer. Persistence Not Started. |
| about | In Progress | presentation | Shell-hosted polished placeholder. Final copy Not Started. |
| 404 | Complete | shared | Restyled with design-system empty/error patterns via `errorBuilder` |
| docs hub | Not Started | — | Phase 2.3 — `/projects/:id/docs` |
| demos | In Progress | shared | `DemoSpec` + `DemoPane` shipped; project showcase demo section still legacy until 2.2 |
| examples | Complete | shared | `content/examples/` + gallery on project pages; not a standalone feature |
| collections | Not Started | — | Phase 2.4 — `content/collections/` |

---

# Content

## Metadata schema status

| Item | Status | Notes |
|------|--------|-------|
| Schema finalization (`docs/CONTENT_MODEL.md`) | Complete | Required + showcase + examples shipped; Phase 2 remaining extensions documented as planned |
| Placeholder fields present | Complete | All three projects have complete required fields + showcase (full or partial) |
| `assets/generated/registry.json` | Complete | Generated from projects + examples |
| Validation / generation scripts | Complete | Validates projects + examples (`projectId` must resolve) |
| Showcase framework docs | Complete | `docs/SHOWCASE_FRAMEWORK.md` + example gallery notes |
| Phase 2 planned schema | Complete (docs only) | Remaining 2.2–2.5 items still planned |
| `content/examples/` | Complete | Document Platform (2) + Localization Analyzer (1) — portal cache; product `examples/` is long-term SSOT |
| `content/integrations/` | Complete | document_platform (integrated), localization_analyzer + ai_tray (registered) |

## Assets status

| Folder / item | Status | Notes |
|---------------|--------|-------|
| `assets/branding/` | Not Started | README only — no brand assets |
| `assets/icons/` | Not Started | README only |
| `assets/images/` | Not Started | README only |
| `assets/screenshots/` | Not Started | README only |
| `pubspec.yaml` assets | Complete | `assets/generated/registry.json` registered |
| `web/` icons / favicon | Complete | Default from `flutter create` (separate from `assets/`) |

---

# Integration Matrix

Track each RSProjects product toward full showcase integration.  
Cell values: `Not Started` · `In Progress` · `Blocked` · `Complete`

| Project ID | Metadata | Assets | Demo | Documentation | Integration Status |
|------------|----------|--------|------|---------------|--------------------|
| `document_platform` | Complete | Not Started | Not Started | In Progress (repo docs links) | **Integrated** — product `showcase/` SSOT + portal cache |
| `localization_analyzer` | Complete | Not Started | Not Started | Not Started | **Registered** — package in MBO; portal cache only |
| `ai_tray` | Complete | Not Started | Not Started | Not Started | **Registered** — AI_Tray remote; portal cache only |

**Folder map:**

| ID | Folder |
|----|--------|
| `document_platform` | `content/projects/document_platform/` + `content/integrations/document_platform.json` (+ product `showcase/`) |
| `localization_analyzer` | `content/projects/localization_analyzer/` + `content/integrations/localization_analyzer.json` |
| `ai_tray` | `content/projects/ai_tray/` + `content/integrations/ai_tray.json` |

Metadata files are fully populated for required fields; Document Platform is `featured: true`.

---

# Definition of Done

A project is **fully integrated** into the showcase when all items below are checked:

### Content

- [ ] `content/projects/<id>/metadata.json` exists and passes `validate_content`
- [ ] All required schema fields populated (no empty required values)
- [ ] Project appears in generated `assets/generated/registry.json` via tooling (not hand-edited for release)

### Assets

- [ ] Branding / icons / screenshots referenced by metadata exist under `assets/` (or agreed content paths)
- [ ] Assets registered in `pubspec.yaml` (or loaded via documented content pipeline)
- [ ] Screenshots optimized for web and stable filenames

### Product surface

- [ ] Visible in projects catalog with correct name, description, status, category
- [ ] Detail view (or equivalent) renders description and linked assets
- [ ] Demo / external link works if the product provides one (or explicitly marked N/A in metadata)
- [ ] Documentation link or in-app markdown renders if provided (or explicitly marked N/A)

### Quality

- [ ] Loading / empty / error / success states handled for catalog and detail paths that touch this project
- [ ] No analyzer issues introduced by the integration
- [ ] Relevant tests updated or added
- [ ] Integration Matrix row updated to **Complete** for all columns (or N/A documented)
- [ ] `PROJECT_STATUS.md` updated (Integration Matrix + Recent Changes)

---

# Product Backlog

Future product/features work (not the current sprint unless promoted).

### High

| Item | Notes |
|------|-------|
| ~~Content model + sample metadata filled~~ | **Complete** |
| ~~Projects catalog + detail UI~~ | **Complete** |
| ~~Home landing (brand-first)~~ | **Complete** |
| ~~App shell: theme + router wired to features~~ | **Complete** (Milestone 1) |

### Medium

| Item | Notes |
|------|-------|
| Search across catalog | Dedicated `/search` route; catalog-local search already shipped |
| About page with org/product copy | Credibility / context |
| Settings (theme / locale preferences) | Nice-to-have early; not blocking catalog |
| Per-project demo embeds or deep links | Enrich Integration Matrix “Demo” column |
| In-app markdown project documentation | Enrich “Documentation” column |

### Low

| Item | Notes |
|------|-------|
| ~~Featured / highlighted projects on home~~ | **Complete** (registry `featured`) |
| ~~Categories / filters UX~~ | **Complete** (catalog chips) |
| Multi-language showcase UI | After settings/locale story exists |

---

# Technical Backlog

Engineering improvements (platform, quality, delivery).

### High

| Item | Notes |
|------|-------|
| Implement `validate_content.dart` | **Complete** |
| Implement `generate_registry.dart` | **Complete** |
| Register registry/assets in `pubspec.yaml` | **Complete** (`assets/generated/registry.json`) |
| Real CI quality gates (format → deploy pipeline) | Replace placeholder steps in `ci.yml` (see QUALITY_GATES.md) |
| Wire ErrorExperience UI + clipboard/URL ports | Complete crash/feedback UX |
| Golden test baselines for shell surfaces | When UI stabilizes |
| Choose hosting + deploy path | Unblocks production |

### Medium

| Item | Notes |
|------|-------|
| ~~Add Riverpod when application layer starts~~ | **Complete** (D-009 Final) |
| ~~Add router package when navigation starts~~ | **Complete** (`go_router`, D-010) |
| `fetch_projects` automation + workflow | Remote discovery / sync |
| Enable `integration_test` properly | File exists; package not in pubspec |
| Choose and apply LICENSE | Public repo hygiene |

### Low

| Item | Notes |
|------|-------|
| Flutter Web SEO / indexing strategy | Phase 3 |
| Performance budgets (bundle size, LCP) | Phase 3 |
| Accessibility pass (semantics, focus, contrast) | Phase 3 |
| ~~Motion / shared animations~~ | **Complete** (page fade/slide via `AppMotion`) |
| Archive or relocate `proposal.md` | Repo hygiene |

---

# CI/CD

## Current workflows

| Workflow | File | Status | Notes |
|----------|------|--------|-------|
| CI | `.github/workflows/ci.yml` | Not Started | Placeholder job (`echo` only) |
| Deploy | `.github/workflows/deploy.yml` | Not Started | Placeholder; `workflow_dispatch` only |
| Fetch projects | `.github/workflows/fetch-projects.yml` | Not Started | Placeholder; `workflow_dispatch` only |

## Deployment status

| Item | Status | Notes |
|------|--------|-------|
| Hosting target | Not Started | Not chosen |
| `scripts/publish.dart` | Not Started | Unimplemented |
| Production / preview deploy | Not Started | Not configured |

## Automation status

| Script | Responsibility | Status |
|--------|----------------|--------|
| `scripts/fetch_projects.dart` | Sync remote project sources | Not Started |
| `scripts/generate_registry.dart` | Build `assets/generated/registry.json` | Complete |
| `scripts/validate_content.dart` | Validate metadata/assets | Complete |
| `scripts/publish.dart` | Build + deploy web | Not Started |

---

# Known Issues

## Bugs

- None known (`flutter analyze` clean; shell navigation tests passing)

## Technical debt

- Dual “generated” concepts: `lib/generated/` (Dart codegen) vs root `generated/` (registry JSON) — documented but easy to confuse
- SSH remote uses host alias `roshandroids.github.com` (personal key); plain `git@github.com:...` on this machine auth as a different GitHub account
- `proposal.md` is in the repo from earlier planning — may or may not belong long-term
- `LICENSE` is a placeholder (“TODO: choose license”)
- Integration test file exists but `integration_test` package is not enabled in `pubspec.yaml`
- Typography uses Material baseline + cross-platform display fallbacks; dedicated brand font assets not yet bundled
- Multi-platform runner folders exist; CI does not yet matrix-build every platform

## Open questions

1. Hosting target (GitHub Pages, Firebase, Cloudflare, other)?
2. How will remote project discovery work (APIs, git remotes, manual content only)?
3. License selection for the public repository?
4. Should `proposal.md` remain in the repo or move to docs/archive?

Promote answers into the **Decisions** log (new `D-xxx` row) and remove from this list.

---

# Risks

| ID | Risk | Impact | Likelihood | Mitigation |
|----|------|--------|------------|------------|
| R-001 | Content schema churn after registry/UI built | Rework of scripts, DTOs, UI | Medium | Phase 1.5 schema locked; Phase 2 extensions documented before coding |
| R-002 | Premature package adoption | Dependency churn, unused abstractions | Medium | Keep D-003; add deps only with active feature |
| R-003 | Hosting undecided delays launch | No public URL | Medium | Decide D-011 before polish phase |
| R-004 | Confusion between `lib/generated` and registry asset path | Wrong edit paths, broken CI | Low | Keep D-008; registry lives under `assets/generated/` |
| R-005 | SSH account mismatch on contributor machines | Failed pushes | Low | Document host alias in getting started |
| R-006 | Empty metadata shipped as “registered” projects | Misleading catalog | Medium | DoD + validate_content before listing |
| R-007 | Scope creep into full product apps inside showcase | Slow portal delivery | Medium | Showcase = discover/present; demos via DemoSpec only |
| R-008 | Accidental web-only APIs or deps break mobile/desktop builds | Platform drift; CI gaps | Medium | Enforce D-018 / PROJECT_RULES Platform Support; prefer portable packages |
| R-009 | Phase 2 embeds break non-web platforms | Platform regressions | Medium | DemoSpec: iframe on Web only; CTA fallback elsewhere |

---

# Next Priorities

Ordered implementation sequence (promote into Current Sprint when starting work):

1. Phase 2.2 — Wire project showcase Interactive Demo through DemoSpec + DemoPane
2. Phase 2.3 — Docs hub + markdown viewer (consume product `docs/` via documentation provider)
3. Phase 2.4 — `/search` + collections
4. Phase 2.5 — Ecosystem relations UI
5. Phase 3 automation — sync from Integration Definitions (`content/integrations/`), CI gates, publish/release (see `docs/roadmap/PHASE_3_AUTOMATION.md`)
6. Phase 4–5 when Phase 2–3 primitives are stable

---

# Recent Changes

| Date | Change |
|------|--------|
| 2026-07-26 | Architecture bootstrap created (folders, placeholders, docs, scripts, workflow stubs, tests) |
| 2026-07-26 | Git repository initialized; connected to GitHub; pushed `main` (`6a0c3a5`) |
| 2026-07-26 | `PROJECT_STATUS.md` introduced as canonical status SSOT |
| 2026-07-26 | `PROJECT_STATUS.md` revised into operational dashboard (milestones, sprint, decisions, backlogs, integration matrix, DoD, risks) |
| 2026-07-26 | **Milestone 1 — Application shell** complete: `go_router`, theme system, responsive `AppShell`, placeholder pages, nav + 404, tests green |
| 2026-07-26 | **Design system foundation:** FlexColorScheme + `lib/design_system/` tokens; removed `google_fonts`; semantic colors ThemeExtension |
| 2026-07-26 | **Cross-platform architecture (Web-first)** finalized (D-018): enabled Android/iOS/macOS/Windows/Linux runners; Platform Support rules in `PROJECT_RULES.md` |
| 2026-07-26 | **Quality Engineering Foundation** (D-019–D-022): quality module, docs, CI gate architecture, feedback/crash/diagnostics abstractions |
| 2026-07-26 | **Phase 1 Experience Foundation:** design-system components, shell polish, content pipeline, Riverpod projects catalog/detail, Home landing, Document Platform featured; D-009 Final |
| 2026-07-26 | **Phase 1.5 Showcase Content Framework:** `showcase` schema, `ProjectShowcaseTemplate`, conditional sections, Document Platform reference fill, docs + tests |
| 2026-07-26 | **Phase 2.0 Showcase Excellence planning:** rewritten `ROADMAP.md`, `docs/PHASE_2_SHOWCASE_EXCELLENCE.md`, planned schema notes, D-023–D-026 |
| 2026-07-26 | **Long-term Phases 3–5 planning:** `docs/roadmap/PHASE_{3,4,5}_*.md`; ROADMAP strategy for Automation, Ecosystem, Community & Developer Portal |
| 2026-07-26 | **Project governance:** `docs/GOVERNANCE.md` as permanent core management doc; linked from ROADMAP / docs README / PROJECT_STATUS |
| 2026-07-26 | **Phase 2.1 Rich Project Pages:** schema/domain/DTO/UI for hero media, `media[]`, architecture diagram, feature icons/media, contributors, downloads; Document Platform reference; registry + tests |
| 2026-07-26 | **Execution-first planning policy** in `docs/GOVERNANCE.md` §2a; **D-027** examples direction recorded |
| 2026-07-26 | **UI refresh (D-028):** FlexScheme.tealM3 Material 3 theme, elevated cards/home/project surfaces, hover motion, brand docs |
| 2026-07-26 | **Project example infrastructure:** `content/examples/` + registry `examples[]`; shared `DemoSpec`/`DemoPane`/`ExampleGallery`; Document Platform + Localization Analyzer; D-027 shape finalized |
| 2026-07-26 | **Project Integration Framework:** provider-driven Integration Definitions (`content/integrations/`), Document Platform `showcase/` contract, portal provenance; D-029; Localization Analyzer + AI Tray registered |
| 2026-07-26 | **Refactor:** Repository Integration → Project Integration (docs rename, `content/integrations/`, provider model); no runtime/automation changes |

---

# Future Vision

1. **Phase 0 — Architecture bootstrap** — Complete  
2. **Phase 1 — Experience Foundation** — Complete  
2b. **Phase 1.5 — Showcase Content Framework** — Complete  
3. **Phase 2 — Showcase Excellence** — 2.0–2.1 + examples + project integration Complete; next 2.2 project DemoSpec wiring  
4. **Phase 3 — Automation & Publishing** — Planned  
5. **Phase 4 — Ecosystem Intelligence** — Planned  
6. **Phase 5 — Community & Developer Portal** — Planned  

Maintainable public showcase: new products land mainly as content under `content/projects/`, with CI producing the registry the app consumes. Detail also tracked in `ROADMAP.md`.

---

# Maintenance Checklist

Update this file after significant work. Prefer editing tables/status cells over rewriting prose.

| When | Update |
|------|--------|
| Starting work | **Current Sprint** (goal, tasks, exit criteria) |
| Finishing a task | Task status → Complete; move notes to **Recent Changes** if milestone-worthy |
| Finishing a phase | **Milestones** status; **Current Status** lists |
| Feature work | **Features** table status + notes |
| Product content | **Integration Matrix** + **Content** |
| Architecture/product choice | Append **Decisions** (`D-xxx`); clear matching **Open questions** |
| New risk discovered | **Risks** |
| Backlog change | **Product Backlog** / **Technical Backlog** |
| Always | **Last updated** date at top |

Do not invent completion percentages. Use only: `Not Started` · `In Progress` · `Blocked` · `Complete`.
