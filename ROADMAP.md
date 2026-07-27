# Roadmap

> Supporting plan for phases and milestones.  
> Operational status lives in [`PROJECT_STATUS.md`](PROJECT_STATUS.md).  
> Phase 2 architecture brief: [`docs/PHASE_2_SHOWCASE_EXCELLENCE.md`](docs/PHASE_2_SHOWCASE_EXCELLENCE.md).

---

## Phase 0 — Architecture bootstrap

**Status:** Complete

- [x] Folder structure and placeholders
- [x] Docs templates, scripts stubs, workflow stubs
- [x] GitHub repository connected
- [ ] Choose hosting target (open — D-011)

---

## Phase 1 — Experience Foundation

**Status:** Complete

- [x] Application shell (`go_router`, `AppShell`, nav, 404)
- [x] Design system (FlexColorScheme tokens + components)
- [x] Quality engineering foundation
- [x] Cross-platform runners (Web-first)
- [x] Content schema + `validate_content` / `generate_registry`
- [x] Riverpod projects catalog + metadata-driven detail
- [x] Home landing (featured from registry)

### Phase 1.5 — Showcase Content Framework

**Status:** Complete

- [x] Canonical `showcase` metadata + [`docs/SHOWCASE_FRAMEWORK.md`](docs/SHOWCASE_FRAMEWORK.md)
- [x] Generic `ProjectShowcaseTemplate` (conditional sections)
- [x] Document Platform as reference fill; siblings partial
- [x] Registry asset under `assets/generated/registry.json`

---

## Phase 2 — Showcase Excellence

**Status:** Planning (2.0) → implementation follows 2.1–2.5  
**Brief:** [`docs/PHASE_2_SHOWCASE_EXCELLENCE.md`](docs/PHASE_2_SHOWCASE_EXCELLENCE.md)

Goal: elevate the portal from a polished catalog into a compelling, reusable developer showcase platform—still content-driven and **never** project-specific UI.

### 2.0 — Planning lock

- [x] Phase 2 brief published
- [x] Roadmap milestones defined
- [x] Planned content-model extensions documented
- [x] Decisions logged (DemoSpec, docs hub, search, ecosystem)

### 2.1 — Rich Project Pages

Elevate the existing generic template (still one page for all products).

- [ ] Hero media (`showcase.heroMedia`)
- [ ] Richer feature highlights (optional icon/media)
- [ ] Architecture diagram support
- [ ] Unified media gallery (images + videos)
- [ ] Contributors + downloads sections
- [ ] Stronger changelog / benchmarks presentation

### 2.2 — Interactive Demos

- [ ] Sealed `DemoSpec` domain model (`embeddedWeb` | `externalLink` | `mediaFallback` | `unavailable`)
- [ ] Generic `DemoPane` renderer (no per-product embeds)
- [ ] Embedded Flutter Web demos where `embedUrl` is provided
- [ ] Screenshot/video fallback for non-web projects

### 2.3 — Documentation Hub

- [ ] Local-first `content/projects/<id>/docs/` (+ `media/`)
- [ ] Generated docs index in registry (not full markdown bodies)
- [ ] Route `/projects/:id/docs` (+ optional path)
- [ ] Shared markdown viewer (`shared/markdown/`)
- [ ] Keep external `documentationLinks` for remote/API docs

### 2.4 — Search & Discovery

- [ ] Dedicated `/search` feature route
- [ ] Shared `DiscoveryQuery` (catalog + search)
- [ ] Advanced filters (tags, tech, collection)
- [ ] Collections content (`content/collections/`) → registry slice
- [ ] Home collection / featured rails remain registry-driven

### 2.5 — Ecosystem Navigation

- [ ] Typed `relations[]` (`related` | `depends_on` | `depended_on_by` | `shares_tech` | `alternative`)
- [ ] Soft edges from shared technologies/tags
- [ ] Reusable rails: related projects, tech chips, (later) ecosystem graph
- [ ] UI never branches on `project.id`

**Suggested implementation order:** schema/index → rich media → DemoSpec → docs hub → search/collections → ecosystem UI.

---

## Phase 3 — Polish and scale

**Status:** Planned (after Phase 2)

- [ ] Motion polish / performance budgets
- [ ] Flutter Web SEO / indexing strategy
- [ ] Automatic discovery of many projects (`fetch_projects` + CI)
- [ ] Real CI quality gates (format → analyze → test → validate content → build)
- [ ] Hosting + production deploy
- [ ] Settings persistence (theme / locale)
- [ ] Accessibility pass beyond foundation defaults

---

## Hard rules (all phases)

1. One generic showcase template for every RSProjects product.
2. Sections render only when content exists.
3. UI never branches on `project.id`.
4. DTOs never reach the UI; mapping layer mandatory.
5. Web-first; all Flutter platforms must stay healthy.
