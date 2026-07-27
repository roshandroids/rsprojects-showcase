# Showcase Content Framework

Canonical presentation model for every RSProjects product page.

## Principles

1. **One template** — all projects share the same layout and section order.
2. **Conditional sections** — omit empty sections; never invent project-specific UI.
3. **Content-driven** — sections come from `metadata.json` → registry → domain → `ProjectShowcaseTemplate`.
4. **Automation-ready** — field shapes are stable so future tooling can fill them from docs and codegen.

## Section order

1. Hero (name, tagline, status, platforms, primary actions)
2. Problem Statement
3. Solution Overview
4. Key Features
5. Interactive Demo (or placeholder)
6. Screenshots / Gallery
7. Architecture Overview
8. Technologies Used
9. Platform Support
10. Installation
11. Documentation Links
12. Examples / Playground
13. Benchmarks (optional)
14. Roadmap
15. Changelog
16. Related RSProjects
17. Contributing

## Implementation

- Schema: [`CONTENT_MODEL.md`](CONTENT_MODEL.md) (`showcase` object)
- Domain: `Project.showcase` / `ProjectShowcase`
- UI: `ProjectShowcaseTemplate` (generic; no per-project widgets)
- Entry: `ProjectDetailScreen` loads by `:id` and passes related projects resolved from the registry

## Authoring checklist

For a new project:

1. Fill required catalog fields in `metadata.json`
2. Add `showcase` sections you can support today (leave others out)
3. Run `dart run scripts/validate_content.dart`
4. Run `dart run scripts/generate_registry.dart`
