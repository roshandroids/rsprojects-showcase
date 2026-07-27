# PROJECT_STATUS.md

> **Canonical operational dashboard and project source of truth.**  
> Share this file for planning, architecture reviews, and progress sync.  
> Update whenever significant work lands so reviews stay accurate without scanning the whole repo.

| Meta | Value |
|------|--------|
| **Last updated** | 2026-07-26 |
| **Document owner** | Project maintainers |
| **Status vocabulary** | `Not Started` · `In Progress` · `Blocked` · `Complete` |
| **Supporting docs** | `ARCHITECTURE.md`, `ROADMAP.md`, `PROJECT_RULES.md`, `docs/*` (not status SSOT) |

---

# Project Overview

## Vision

RSProjects Showcase is the public portal for discovering and presenting all RSProjects products. **Web is the primary deployment target**, but the app is architected as a **cross-platform Flutter application** (Web, Android, iOS, macOS, Windows, Linux). It should scale to dozens of projects via content-driven discovery (metadata → generated registry → catalog UI), not hardcoded product lists.

## Current objective

Quality Engineering Foundation is in place (architecture + docs). Next: content model + registry pipeline, then deepen quality gate implementations.

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
| Latest remote commit | `6a0c3a5` — `chore: bootstrap RSProjects Showcase architecture` |
| Latest local milestone | Quality Engineering Foundation — pending commit/push |
| Working tree | Dirty with shell + design system + platforms + quality foundation (as of last update) |

---

# Milestones

| Phase | Name | Status | Outcome |
|-------|------|--------|---------|
| 0 | Architecture bootstrap | **Complete** | Folders, placeholders, docs, scripts, workflow stubs, tests, GitHub connected |
| 1 | Application shell | **Complete** | `go_router`, `MaterialApp.router`, responsive `AppShell`, nav, placeholders, 404 |
| 1b | Design system / FlexColorScheme | **Complete** | Custom brand palette, token files, light/dark themes, semantic colors |
| 1c | Quality Engineering Foundation | **Complete** | Testing strategy, crash/diagnostics/feedback abstractions, quality docs, CI gate architecture |
| 2 | Content pipeline | **Planned** | Validate content, generate registry, CI sync/fetch |
| 3 | Feature surfaces | **Planned** | Real home/projects/search/settings/about content + catalog wiring |
| 4 | Polish and scale | **Planned** | Markdown, motion, SEO/perf, automatic discovery of many projects |

**Long-term:** Adding a project is primarily a content change under `content/projects/`; CI produces the registry the app consumes.

---

# Current Sprint

> One active focus at a time. Keep this section short; move finished items into Recent Changes / Milestones.

| Field | Value |
|-------|--------|
| **Sprint name** | Content pipeline foundation |
| **Goal** | Finalize content schema and implement validate + generate registry scripts |
| **Status** | Not Started |

## Active tasks

| Task | Status | Owner |
|------|--------|-------|
| Finalize `metadata.json` schema in `docs/CONTENT_MODEL.md` | Not Started | — |
| Fill sample project metadata with real placeholder values | Not Started | — |
| Implement `validate_content.dart` | Not Started | — |
| Implement `generate_registry.dart` | Not Started | — |

## Exit criteria

Sprint is done when all of the following are true:

- [ ] Content schema documented and agreed in `docs/CONTENT_MODEL.md`
- [ ] Three sample projects have complete metadata fields (no empty required strings)
- [ ] `dart run scripts/validate_content.dart` passes on sample content
- [ ] `dart run scripts/generate_registry.dart` writes a non-empty `generated/registry.json`
- [ ] This dashboard updated (Milestones / Features / Content / Recent Changes)

---

# Current Status

## Complete

- Flutter Web project scaffold (`pubspec.yaml`, `web/`, analysis/lints)
- Feature-first folder architecture under `lib/`
- App entry: `main` → `bootstrap` → `RsProjectsShowcaseApp`
- Feature placeholders: home, projects (+ detail route), search, settings, about
- Full layer stubs for `projects` (presentation / application / domain / infrastructure)
- Core/shared modules (breakpoints, spacing, shell, placeholder page body)
- Content stubs for three projects under `content/projects/`
- Generated registry placeholder (`generated/registry.json`)
- Tooling script stubs (`scripts/*.dart`)
- Docs templates (`docs/*`, root architecture/rules/roadmap)
- GitHub workflow stubs (ci / deploy / fetch-projects)
- Unit tests for app shell navigation + feature placeholders
- Repository connected and pushed to GitHub (`main`) — bootstrap commit
- `PROJECT_STATUS.md` established as operational SSOT
- **Milestone 1 — Application shell:** routing, responsive shell, navigation, placeholder pages
- **Design system foundation:** `flex_color_scheme` + `lib/design_system/*` token files (colors, typography, spacing, radius, breakpoints, motion, theme)
- **Cross-platform foundation:** Android, iOS, macOS, Windows, Linux runners added alongside Web; architecture constraint documented (D-018)
- **Quality Engineering Foundation:** `lib/core/quality/*`, `docs/quality/*`, CI gate stub pipeline, GitHub issue templates, unit tests for report builders

## In Progress

- None

## Blocked

- None

## Not Started

- Content schema finalization and validation
- Registry generation implementation
- Full CI quality gate implementation (real format/analyze/test/build steps)
- Friendly error UI wiring beyond placeholder presenter
- Clipboard / URL launcher ports for diagnostics & feedback
- Feature business logic / project loading / metadata parsing
- Riverpod (or other) state management
- Real assets and filled project metadata
- CI quality gates and deploy automation
- Hosting selection and production deploy
- Optional further brand polish (bundled font assets) beyond design-system foundation

---

# Architecture

## Folder structure summary

```
lib/
  app/           bootstrap, root app, router, theme re-export
  design_system/ FlexColorScheme theme + tokens (colors, typography, spacing, radius, breakpoints, motion)
  core/          constants, quality (crash/diagnostics/feedback/a11y/perf/devtools), extensions, services, errors, utilities, widgets
  features/
    home/        presentation
    projects/    presentation, application, domain, infrastructure
    search/      presentation
    settings/    presentation
    about/       presentation
  shared/        models, widgets, layouts, markdown, animations
  generated/     reserved for Dart codegen (README only)

assets/          branding, icons, images, screenshots (READMEs only)
content/projects/<id>/metadata.json
generated/       registry.json (CI/tooling output; not hand-edited for releases)
scripts/         fetch / generate / validate / publish (unimplemented stubs)
.github/workflows/  ci.yml, deploy.yml, fetch-projects.yml (placeholders)
docs/            vision, getting started, structure, deploy, CI/CD, content model
tool/            reserved for non-CLI developer tooling
test/            placeholder widget tests
integration_test/ placeholder
```

## Dependencies

**Runtime**

- `flutter` (SDK)
- `go_router: ^17.3.0`
- `flex_color_scheme: ^8.4.0` (only theming dependency)

**Dev**

- `flutter_test` (SDK)
- `flutter_lints: ^6.0.0`

**Explicitly deferred**

- State management (e.g. `flutter_riverpod`)
- Markdown rendering
- `integration_test` SDK package
- Optional bundled brand fonts (typography currently uses web-safe stacks)

## Current routing

| Field | Value |
|-------|--------|
| Status | Complete |
| Notes | `MaterialApp.router` + `go_router`. Routes: `/`, `/projects`, `/projects/:id`, `/about`, `/settings`, plus 404 via `errorBuilder`. ShellRoute hosts `AppShell`. |

## Theme status

| Field | Value |
|-------|--------|
| Status | Complete (foundation) |
| Notes | `lib/design_system/` — custom RSProjects brand palette fed into FlexColorScheme (no predefined Flex schemes). Light/dark from same seeds. Semantic colors via `AppSemanticColors` ThemeExtension (`success`/`warning`/`info`/…). Tokens: `app_colors`, `app_typography`, `app_spacing`, `app_radius`, `app_breakpoints`, `app_motion`, `app_theme`. Extractable later as `rsprojects_design_system`. |

---

# Decisions

> Canonical decision log. Append rows; do not rewrite history. Open items stay in **Open questions** until decided.

| ID | Date | Decision | Rationale | Status |
|----|------|----------|-----------|--------|
| D-001 | 2026-07-26 | Feature-first Clean Architecture (UI → State → Domain → Data) | Scales per-product work; matches RSProjects Flutter standards | Final |
| D-002 | 2026-07-26 | Content-driven discovery: `content/projects` → `generate_registry` → `generated/registry.json` | Adding products should be content + CI, not hardcoded lists | Final |
| D-003 | 2026-07-26 | No premature dependencies; add packages only when a feature needs them | Keeps bootstrap lean; avoids speculative architecture | Final |
| D-004 | 2026-07-26 | No business logic in bootstrap placeholders | Structure first; implement incrementally | Final |
| D-005 | 2026-07-26 | `projects` gets full layers first; other features start at presentation | Catalog is the primary surface; avoid empty layer trees elsewhere | Final |
| D-006 | 2026-07-26 | DTOs never used directly in UI; mapping layer mandatory | Clean Architecture boundary | Final |
| D-007 | 2026-07-26 | `PROJECT_STATUS.md` is the single source of truth for project operational state | One file for planning/reviews; other docs are supporting | Final |
| D-008 | 2026-07-26 | Dual generated locations: `lib/generated/` (Dart codegen) vs root `generated/` (registry JSON) | Separates codegen from content registry | Final |
| D-009 | — | Riverpod (Notifier / AsyncNotifier / AsyncValue) for application state | Aligns with RSProjects standards | Proposed (not added to pubspec yet) |
| D-010 | 2026-07-26 | Use `go_router` with `MaterialApp.router` + `ShellRoute` | Declarative routing, deep links, shared shell | Final |
| D-011 | — | Hosting target (GitHub Pages / Firebase / Cloudflare / other) | Required before real deploy | Open |
| D-012 | — | Repository license | Public repo needs a chosen license | Open |
| D-013 | 2026-07-26 | Theme tokens centralized (superseded by D-015 location) | No hardcoded colors/magic layout numbers in features | Final |
| D-014 | 2026-07-26 | Top nav: Home / Projects / About; Settings via footer | Keeps primary nav focused | Final |
| D-015 | 2026-07-26 | Use FlexColorScheme as Material 3 theme engine with custom brand `FlexSchemeColor` (no predefined Flex schemes) | Scalable theming; light/dark from one palette | Final |
| D-016 | 2026-07-26 | Design system lives in `lib/design_system/` (token files + barrel) for future `rsprojects_design_system` extraction | Reuse across RSProjects | Final |
| D-017 | 2026-07-26 | Semantic colors exposed via `AppSemanticColors` ThemeExtension + ColorScheme | Prefer semantics over raw Flutter colors | Final |
| D-018 | 2026-07-26 | **Cross-platform architecture (Web-first)** — support Web, Android, iOS, macOS, Windows, Linux; Web is primary deploy target | Showcase must compile on all Flutter platforms; isolate platform code behind abstractions; evaluate deps for multi-platform support | Final |
| D-019 | 2026-07-26 | **Quality Engineering Foundation** — testing strategy, regression policy, CI quality gates, crash/diagnostics/feedback, a11y, performance budgets | Quality is a core product feature; GitHub Issues primary; email fallback; no SaaS crash reporters yet | Final |
| D-020 | 2026-07-26 | **Regression policy** — no bug fix without a regression test | Prevents defect recurrence | Final |
| D-021 | 2026-07-26 | **Friendly error experience** — never ship default Flutter release red screen as UX | Restart / diagnostics / report actions; thank-you after feedback | Final |
| D-022 | 2026-07-26 | Accessibility is a default quality requirement | Build a11y into components; do not retrofit only | Final |

---

# Features

Status values: `Not Started` · `In Progress` · `Blocked` · `Complete`

| Feature | Status | Layers present | Notes |
|---------|--------|----------------|-------|
| home | In Progress | presentation | Shell-hosted polished placeholder (brand eyebrow + CTAs). Real hero/featured content Not Started. |
| projects | In Progress | presentation, application, domain, infrastructure | Shell-hosted catalog + `/projects/:id` placeholders. Domain/infra/loading Not Started. |
| search | Not Started | presentation | `SearchScreen` stub only; not in top nav yet. |
| settings | In Progress | presentation | Shell-hosted placeholder; linked from footer. Persistence Not Started. |
| about | In Progress | presentation | Shell-hosted polished placeholder. Final copy Not Started. |
| 404 | Complete | shared | `NotFoundPage` via router `errorBuilder`, wrapped in `AppShell`. |

---

# Content

## Metadata schema status

| Item | Status | Notes |
|------|--------|-------|
| Schema finalization (`docs/CONTENT_MODEL.md`) | Not Started | Headings + TODOs only |
| Placeholder fields present | Complete | `id`, `name`, `description`, `version`, `status`, `category` |
| `generated/registry.json` | Not Started | Empty shell: `{ "generatedAt": "", "projects": [] }` |
| Validation / generation scripts | Not Started | Throw `UnimplementedError` |

## Assets status

| Folder / item | Status | Notes |
|---------------|--------|-------|
| `assets/branding/` | Not Started | README only — no brand assets |
| `assets/icons/` | Not Started | README only |
| `assets/images/` | Not Started | README only |
| `assets/screenshots/` | Not Started | README only |
| `pubspec.yaml` assets | Not Started | Commented out — not registered |
| `web/` icons / favicon | Complete | Default from `flutter create` (separate from `assets/`) |

---

# Integration Matrix

Track each RSProjects product toward full showcase integration.  
Cell values: `Not Started` · `In Progress` · `Blocked` · `Complete`

| Project ID | Metadata | Assets | Demo | Documentation | Integration Status |
|------------|----------|--------|------|---------------|--------------------|
| `document_platform` | Not Started | Not Started | Not Started | Not Started | Not Started |
| `localization_analyzer` | Not Started | Not Started | Not Started | Not Started | Not Started |
| `ai_tray` | Not Started | Not Started | Not Started | Not Started | Not Started |

**Folder map (stubs exist):**

| ID | Folder |
|----|--------|
| `document_platform` | `content/projects/document_platform/` |
| `localization_analyzer` | `content/projects/localization_analyzer/` |
| `ai_tray` | `content/projects/ai_tray/` |

Metadata files exist with empty string fields (except `id` seeded to the folder name).

---

# Definition of Done

A project is **fully integrated** into the showcase when all items below are checked:

### Content

- [ ] `content/projects/<id>/metadata.json` exists and passes `validate_content`
- [ ] All required schema fields populated (no empty required values)
- [ ] Project appears in generated `generated/registry.json` via tooling (not hand-edited for release)

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
| Content model + sample metadata filled | Unblocks registry and catalog |
| Projects catalog + detail UI | Primary showcase surface |
| Home landing (brand-first) | Portal entry; depends on brand direction |
| ~~App shell: theme + router wired to features~~ | **Complete** (Milestone 1) |

### Medium

| Item | Notes |
|------|-------|
| Search across catalog | Needed as project count grows |
| About page with org/product copy | Credibility / context |
| Settings (theme / locale preferences) | Nice-to-have early; not blocking catalog |
| Per-project demo embeds or deep links | Enrich Integration Matrix “Demo” column |
| In-app markdown project documentation | Enrich “Documentation” column |

### Low

| Item | Notes |
|------|-------|
| Featured / highlighted projects on home | After catalog exists |
| Categories / filters UX | After taxonomy finalized in content model |
| Multi-language showcase UI | After settings/locale story exists |

---

# Technical Backlog

Engineering improvements (platform, quality, delivery).

### High

| Item | Notes |
|------|-------|
| Implement `validate_content.dart` | Gate bad metadata early |
| Implement `generate_registry.dart` | Enable discovery |
| Register registry/assets in `pubspec.yaml` | Runtime load path |
| Real CI quality gates (format → deploy pipeline) | Replace placeholder steps in `ci.yml` (see QUALITY_GATES.md) |
| Wire ErrorExperience UI + clipboard/URL ports | Complete crash/feedback UX |
| Golden test baselines for shell surfaces | When UI stabilizes |
| Choose hosting + deploy path | Unblocks production |

### Medium

| Item | Notes |
|------|-------|
| Add Riverpod when application layer starts | Aligns with D-009 |
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
| Motion / shared animations | After UI exists |
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
| `scripts/generate_registry.dart` | Build `generated/registry.json` | Not Started |
| `scripts/validate_content.dart` | Validate metadata/assets | Not Started |
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

1. Final content metadata schema (required fields, enums for `status` / `category`)?
2. Hosting target (GitHub Pages, Firebase, Cloudflare, other)?
3. Confirm Riverpod as state management when application layer starts? (see D-009)
4. How will remote project discovery work (APIs, git remotes, manual content only)?
5. License selection for the public repository?
6. Should `proposal.md` remain in the repo or move to docs/archive?

Promote answers into the **Decisions** log (new `D-xxx` row) and remove from this list.

---

# Risks

| ID | Risk | Impact | Likelihood | Mitigation |
|----|------|--------|------------|------------|
| R-001 | Content schema churn after registry/UI built | Rework of scripts, DTOs, UI | Medium | Lock schema (Phase 2 / content pipeline) before catalog UI |
| R-002 | Premature package adoption | Dependency churn, unused abstractions | Medium | Keep D-003; add deps only with active feature |
| R-003 | Hosting undecided delays launch | No public URL | Medium | Decide D-011 before polish phase |
| R-004 | Confusion between `lib/generated` and `generated/` | Wrong edit paths, broken CI | Low | Keep D-008; document in onboarding |
| R-005 | SSH account mismatch on contributor machines | Failed pushes | Low | Document host alias in getting started |
| R-006 | Empty metadata shipped as “registered” projects | Misleading catalog | Medium | DoD + validate_content before listing |
| R-007 | Scope creep into full product apps inside showcase | Slow portal delivery | Medium | Showcase = discover/present; deep demos optional |
| R-008 | Accidental web-only APIs or deps break mobile/desktop builds | Platform drift; CI gaps | Medium | Enforce D-018 / PROJECT_RULES Platform Support; prefer portable packages |

---

# Next Priorities

Ordered implementation sequence (promote into Current Sprint when starting work):

1. Finalize content model — lock schema in `docs/CONTENT_MODEL.md`; fill three sample projects
2. Implement `validate_content.dart` + `generate_registry.dart`
3. Register assets / registry in `pubspec.yaml`
4. Implement `projects` domain + infrastructure (registry → DTO → domain → repository)
5. Add Riverpod application layer for projects (AsyncValue: loading / empty / error / data)
6. Build minimal projects catalog + detail UI on existing routes
7. Implement home landing content (after brand direction)
8. Turn on real CI (analyze + test + content validation)
9. Choose hosting and implement deploy (`publish.dart` / `deploy.yml`)

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

---

# Future Vision

1. **Phase 0 — Architecture bootstrap** — Complete  
2. **Phase 1 — Application shell** — Complete  
3. **Phase 2 — Content pipeline** — Planned  
4. **Phase 3 — Feature surfaces** — Planned  
5. **Phase 4 — Polish and scale** — Planned  

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
