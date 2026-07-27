# Project Governance

How RSProjects Showcase is **managed**—not a feature list.  
This is a permanent core document for contributors and maintainers.

| Related | Location |
|---------|----------|
| Operational status | [`PROJECT_STATUS.md`](../PROJECT_STATUS.md) |
| Product strategy | [`ROADMAP.md`](../ROADMAP.md) |
| Architecture | [`ARCHITECTURE.md`](../ARCHITECTURE.md) |
| Engineering rules | [`PROJECT_RULES.md`](../PROJECT_RULES.md) |
| Quality foundation | [`docs/quality/`](quality/README.md) |

---

## 1. Project Philosophy

- **Build reusable platform capabilities** — prefer shared templates, domain models, and content shapes over one-off product screens.
- **Prefer metadata over hardcoded UI** — products enter through content and the registry; presentation stays generic.
- **Keep architecture modular** — UI → State → Domain → Data; features stay isolated unless shared in `core/` / `shared/` / `design_system/`.
- **Cross-platform by design** — Web is primary; Android, iOS, macOS, Windows, and Linux must remain healthy.
- **Quality is a feature** — testing, diagnostics, accessibility, and regression discipline ship with the product.
- **Documentation is part of development** — no milestone is done until docs and status reflect reality.

---

## 2. Roadmap Governance

- **Phases** describe long-term purpose (Experience → Excellence → Automation → Ecosystem → Portal). Their purpose stays stable; internal milestones may reorder.
- **The roadmap is considered stable.** Revise it only when priorities change, milestones complete, major capabilities emerge, or architectural direction changes—not during routine feature implementation.
- **Milestone reordering** is allowed when user value or maintainer cost changes. Record material shifts in `PROJECT_STATUS.md` Recent Changes.
- **New phases** require a short written proposal (vision, dependencies, exit criteria) and a Decision row if they change architecture or sequencing. Do not invent phases casually.
- **Completed phases** remain in `ROADMAP.md` as historical strategy; detailed briefs stay under `docs/` / `docs/roadmap/` as living references.
- **Planning documents guide implementation; they are not rigid contracts.** Prefer updating the plan when reality diverges over forcing a bad fit.

Long-term briefs (Phases 3–5) inform architecture only where necessary. They must not delay Phase 2 delivery.

---

## 2a. Execution-First Planning Policy

The project has reached **planning maturity**. Do **not** create new roadmap phases or large planning documents by default.

**Principle:** Planning is **feature-driven**, not project-driven.

### Default workflow

```
Roadmap
  → Select next milestone
  → Lightweight feature planning
  → Implementation
  → Testing
  → Documentation
  → Review
  → Merge
  → Repeat
```

When starting work: review the existing roadmap → select the next milestone → plan **only** that feature → implement → test → update docs → move on.

### When to create new planning or architecture documents

Create new planning/architecture writing **only** if one of the following is true:

- A significant architectural change is required
- A new reusable platform capability is introduced
- The content model requires structural changes
- A new domain model affects multiple features
- A major engineering decision requires a Decision / ADR
- Existing documentation becomes inaccurate or incomplete

Do **not** create planning documents merely to describe upcoming features.

### Lightweight feature planning

A feature plan should answer only:

| Question | Intent |
|----------|--------|
| Goal | What ships |
| User value | Why it matters |
| Dependencies | What must already exist |
| Technical approach | How (brief) |
| Reusable abstractions | Shared models/widgets/ports, if any |
| Acceptance criteria | Done when… |
| Testing strategy | What proves it |
| Documentation updates | Which files must stay in sync |

Avoid long-term speculative planning inside feature work.

### Documentation evolves with implementation

Every completed feature updates relevant docs as needed:

- `PROJECT_STATUS.md` (always for milestones)
- `CHANGELOG.md` (when releases begin)
- Feature / content-model / API docs
- Architecture docs **only if architecture changed**

### Focus

Deliver high-quality, demonstrable milestones while keeping documentation synchronized with implementation—**not** expanding planning surface area.

---

## 3. Architectural Decisions

Record decisions in `PROJECT_STATUS.md` **Decisions** (`D-xxx`). Use a new Decision when changing:

- Layering or feature boundaries
- New domain models with cross-feature impact
- New infrastructure ports or packages
- Content / registry schema (required fields, enums, indexes)
- Public routes or contributor-facing APIs

**Do not** require a Decision for routine UI polish, local refactors, or bug fixes that preserve existing contracts.

Reference Decision IDs from PRs and milestone notes when relevant.

---

## 4. Definition of Done

A milestone is complete only when all applicable items hold:

- [ ] Implementation complete for the stated exit criteria
- [ ] Tests passing (`flutter analyze` / `flutter test` as applicable)
- [ ] Documentation updated (feature docs, content model, roadmap notes)
- [ ] Regression tests added when fixing defects (D-020)
- [ ] `PROJECT_STATUS.md` updated (milestones, features, recent changes)
- [ ] Roadmap progress updated when phase/milestone status changes
- [ ] Examples / reference project content updated when the template or schema changes (e.g. Document Platform)

**No milestone is complete until documentation reflects reality.**

---

## 5. Quality Expectations

Reinforce the Quality Engineering Foundation (`docs/quality/`):

| Area | Expectation |
|------|-------------|
| Testing | Unit/widget coverage for domain and critical UI; AsyncValue paths covered |
| Accessibility | Semantics, contrast, focus—default in components, not retrofit-only |
| Performance | Respect budgets in `PERFORMANCE_BUDGET.md`; avoid regressions on Web |
| Diagnostics | Crash/feedback hooks remain usable; no silent failures in core flows |
| Cross-platform | Prefer portable APIs; isolate Web-only surfaces (e.g. embeds) behind abstractions |
| Regression | No bug fix without a regression test when practical |

---

## 6. Versioning & Compatibility (policy — planning)

Future policy (enforce as schema and tooling mature):

- **Metadata schema** — additive fields preferred; breaking removals need a Decision, migration note, and validator version bump.
- **Registry** — generated artifacts must remain loadable by the current app; drift checks belong in CI (Phase 3).
- **Content migrations** — provide scripts or documented steps when renaming fields (e.g. `screenshots` → `media`).
- **Deprecation** — mark fields deprecated in `CONTENT_MODEL.md`, keep reading them for at least one release cycle, then remove.

---

## 7. Release Process

Target lifecycle (full automation in Phase 3):

```
Development → Testing → Documentation → Release Candidate → Public Release → Post-Release Review
```

Until hosting (D-011) and release workflows land, “release” means: green tests, docs/status current, and tagged commits when maintainers choose.

---

## 8. Documentation Standards

- Every user-facing capability updates the relevant doc (`CONTENT_MODEL`, showcase framework, feature notes).
- Material Decisions are referenced from status/roadmap/PRs.
- Roadmap milestones carry status; `PROJECT_STATUS.md` is the operational SSOT.
- Architecture docs stay synchronized with shipped structure.
- Obsolete docs are archived or clearly marked superseded—do not leave contradictory guidance.
- Prefer updating existing docs over creating new ones (see §2a).

---

## 9. Contributor Workflow

```
Select next roadmap milestone
  → Lightweight feature plan (goal, approach, acceptance, tests, docs)
  → Decision / ADR (only if required — §3)
  → Implementation
  → Testing
  → Documentation
  → Review
  → Merge
  → Release (when applicable)
```

Keep PRs focused. Prefer Conventional Commits. Do not expand scope into later phases without explicit agreement. Do not open large planning docs for the next feature by default.

---

## 10. Guiding Principles

- Architecture before optimization.
- Reuse before duplication.
- Automation before manual work.
- Platform before feature.
- Content before presentation.
- Simplicity over cleverness.
- Every phase should increase value while reducing maintenance.
- **Execution before speculative planning** — plan the next milestone, ship it, then plan the next.

---

## Execution stance

Roadmap planning for Phases 0–5 is complete. The primary objective is **delivering demonstrable milestones** (currently Phase 2) while keeping documentation synchronized. Future phases influence design only where necessary—they do not block shipping. New work follows §2a (execution-first).
