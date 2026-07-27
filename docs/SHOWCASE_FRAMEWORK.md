# Showcase Content Framework

Canonical presentation model for every RSProjects product page.

## Principles

1. **One template** — all projects share the same layout and section order.
2. **Conditional sections** — omit empty sections; never invent project-specific UI.
3. **Content-driven** — sections come from `metadata.json` → registry → domain → `ProjectShowcaseTemplate`.
4. **Automation-ready** — field shapes are stable so future tooling can fill them from docs and codegen.
5. **No `project.id` branching** in presentation.

## Section order (current)

1. Hero (+ optional `heroMedia`)
2. Problem Statement
3. Solution Overview
4. Key Features (optional `icon` / `media`)
5. Interactive Demo (or placeholder)
6. Screenshots / Gallery (`media[]`, fallback `screenshots[]`)
7. Architecture Overview (+ optional `architectureDiagram`)
8. Technologies Used
9. Platform Support
10. Installation
11. Documentation Links
12. Examples / Playground (`ExampleGallery` from registry `examples[]` by `projectId`)
13. Benchmarks (optional)
14. Roadmap
15. Changelog
16. Contributors (optional)
17. Downloads (optional)
18. Related RSProjects
19. Contributing

## Implementation (shipped)

- Schema: [`CONTENT_MODEL.md`](CONTENT_MODEL.md) (`showcase` object + Phase 2.1 rich fields + project examples)
- Domain: `Project.showcase` / `ProjectShowcase` (+ media / contributors / downloads)
- Examples: `content/examples/` → registry `examples[]` → shared `ProjectExample` / `ExampleGallery` / `DemoSpec`
- UI: `ProjectShowcaseTemplate` (generic; no per-project widgets); examples via `ExampleGallery(projectId: …)`
- Entry: `ProjectDetailScreen` loads by `:id`, passes related projects + registry examples
- Reference fill: Document Platform + Localization Analyzer examples

## Authoring checklist

For a new project:

1. Fill required catalog fields in `metadata.json`
2. Add `showcase` sections you can support today (leave others out)
3. Optionally add examples under `content/examples/<id>/` with `projectId` set to this project
4. Run `dart run scripts/validate_content.dart`
5. Run `dart run scripts/generate_registry.dart` (writes `assets/generated/registry.json`)

---

## Phase 2.2–2.5 (planned) — Showcase Excellence

Full brief: [`PHASE_2_SHOWCASE_EXCELLENCE.md`](PHASE_2_SHOWCASE_EXCELLENCE.md).  
Remaining planned schema: [`CONTENT_MODEL.md`](CONTENT_MODEL.md) → **Phase 2.2–2.5**.

### Remaining section / capability additions

| Order | Section | Notes |
|------:|---------|--------|
| 5 | Interactive Demo | Shared `DemoSpec` + `DemoPane` exist; project showcase section still uses legacy placeholder UI until full 2.2 wiring |
| 12 | Examples / Playground | **Implemented:** `content/examples/` → registry `examples[]` → `ExampleGallery(projectId)` (no standalone example routes) |
| 11a | Documentation Hub | In-app `/projects/:id/docs` (local `docs/` + index); links remain |
| 16 | Related / ecosystem | Typed `relations[]` + soft tech/tag edges; shared rails |

### Shipped in Phase 2.1

| Order | Section | Notes |
|------:|---------|--------|
| 1a | Hero media | Optional `heroMedia` |
| 4a | Feature media / icons | Optional per-feature visuals |
| 6 | Media gallery | Unified `media[]` (image/video/diagram); `screenshots` fallback |
| 7a | Architecture diagram | Optional `architectureDiagram` |
| 16a | Contributors | `contributors[]` |
| 16b | Downloads | `downloads[]` |

### Hard rules for Phase 2 UI work

- Extend `ProjectShowcaseTemplate` (and shared section widgets) only.
- Map demos through `DemoSpec` — never embed a product by id.
- Examples stay project-scoped in UX (`ExampleGallery`); no standalone example feature/routes unless Phase 4 justifies them.
- Docs hub and discovery UIs consume indexes/registry, not hardcoded project lists.
