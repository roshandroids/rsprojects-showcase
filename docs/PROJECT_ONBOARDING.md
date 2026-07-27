# Project Onboarding

Canonical guide for integrating any RSProjects **project** into the showcase.

Related: [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md) (architecture), [`CONTENT_MODEL.md`](CONTENT_MODEL.md) (metadata schema).

## Guiding question

> Could a brand-new RSProjects project be integrated by following this documentation alone, **without modifying the showcase architecture**?

If the answer is no, stop and revisit the abstraction before inventing project-specific UI or schema forks.

---

## Lifecycle

```
Project created
  → Project Integration Definition (content/integrations/)
  → Showcase contract (product showcase/)
  → Metadata validation
  → Content synchronization (portal cache)
  → Registry generation
  → Visible in showcase
```

No project-specific Flutter widgets, routes, or hardcoded ids.

---

## Prerequisites

Before onboarding, the product should have (or plan):

| Item | Typical location | Notes |
|------|------------------|--------|
| Git repository | Remote HTTPS URL | Required for `providers.repository` |
| README | `README.md` (repo or package) | Pitch + quick start |
| License | `LICENSE` | Strongly recommended; see [Common issues](#common-issues) |
| Documentation | `docs/` and/or package README | Map via documentation provider |
| Showcase folder | `showcase/` or `{packagePath}/showcase/` | Required for `integrated` status |
| Package manifest | `pubspec.yaml` | Version / description SSOT |

Optional but valuable: `CHANGELOG.md`, `examples/`, screenshots, GitHub Releases.

---

## Required structure

### Standalone product repository

```
<product-repo>/
  README.md
  LICENSE                 # recommended
  CHANGELOG.md            # optional
  pubspec.yaml            # or package under packagePath/
  docs/                   # optional
  examples/               # optional — long-term Example Gallery SSOT
  showcase/
    README.md
    metadata.json
    media/
```

### Nested package in a monorepo

When the project is a package (not the monorepo root):

```
<monorepo>/
  packages/<package>/
    README.md
    pubspec.yaml
    showcase/
      README.md
      metadata.json
      media/
```

Set `providers.repository.packagePath` to `packages/<package>` (or equivalent).  
**Default rule:** if `packagePath` is set, the showcase contract lives at `{packagePath}/showcase/` unless `paths.showcaseMetadata` says otherwise.

Future files (document only): `showcase/schema.json`, `showcase/examples.json`.

---

## Integration checklist

Step-by-step — same for every project.

### 1. Create the Integration Definition

Add [`content/integrations/<projectId>.json`](../content/integrations/) with:

- `projectId`, `displayName`, `status` (`registered` → `integrated` when contract is done)
- `providers.repository` (`gitUrl`, `paths`, optional `packagePath`, `localDevPath`)
- Other providers as known (`documentation`, `demo`, `package`, `releases`, …)
- Omit or leave `{}` for unused providers

### 2. Add the product showcase contract

In the product project:

1. Create `showcase/README.md` (points at PROJECT_INTEGRATION / this guide)
2. Create `showcase/metadata.json` (see [`CONTENT_MODEL.md`](CONTENT_MODEL.md))
3. Create `showcase/media/` (README or assets)

Align `version`, `description`, and links with the product README / pubspec — do not invent a second narrative.

### 3. Sync the portal cache

Copy product `showcase/metadata.json` into:

```
content/projects/<projectId>/metadata.json
```

Add provenance:

```json
"integration": {
  "projectId": "<projectId>",
  "source": "project-cache"
}
```

Set portal-only flags carefully (e.g. `featured` for Home). Prefer product SSOT for everything else.

### 4. Optional — example cache

Add `content/examples/<example-id>/` with `projectId` if you need gallery cards before Phase 3 sync. Mark them as cache in descriptions when product `examples/` is the real SSOT.

### 5. Validate and generate

```bash
dart run scripts/validate_content.dart
dart run scripts/generate_registry.dart
```

### 6. Verify in the app

```bash
flutter run -d chrome
# or: flutter test
```

Open `/projects/<projectId>` and confirm sections, links, and examples.

### 7. Update status

Mark the Integration Definition `status: integrated`. Update [`PROJECT_STATUS.md`](../PROJECT_STATUS.md) integration matrix when significant.

---

## Validation checklist

Integration is successful when:

- [ ] `content/integrations/<projectId>.json` exists with accurate providers
- [ ] Product `showcase/metadata.json` (+ README + media/) exists
- [ ] Portal `content/projects/<projectId>/metadata.json` matches product SSOT + `integration` provenance
- [ ] `dart run scripts/validate_content.dart` passes
- [ ] `dart run scripts/generate_registry.dart` emits the project
- [ ] Project appears in catalog / detail without code changes
- [ ] `repositoryUrl` / docs / download links resolve to the **product**, not inventing showcase-only URLs
- [ ] No project-specific widgets or `project.id` UI branches were added

---

## Common issues

Lessons from Document Platform, Localization Analyzer, and AI Tray:

| Issue | What happened | Guidance |
|-------|----------------|----------|
| **Nested package vs repo root** | Localization Analyzer lives under MBO `packages/` | Use `packagePath`; place `showcase/` under the package |
| **Missing LICENSE** | AI Tray (and MBO root) lack a committed LICENSE | Do not block onboarding; set `paths.license` to `null`, note in Integration Definition, add LICENSE when publishing |
| **Portal fiction vs product reality** | Early portal copy did not match AI Tray / Document Platform READMEs | Always sync from product README + pubspec before marking integrated |
| **Version drift** | Portal versions lagged package versions | Treat product `pubspec.yaml` as version SSOT |
| **Screenshots outside showcase/media** | AI Tray screenshots under `docs/assets/screenshots/` | Keep contract `showcase/media/`; document real asset paths on documentation / media providers until assets are copied |
| **Manual dual write** | Product `showcase/metadata.json` + portal cache | Expected until Phase 3 sync; minimize drift by copying, not rewriting |
| **Examples vs product examples/** | Portal `content/examples/` is a cache | Prefer product `examples/` long-term; label portal cards as cache when needed |

---

## Future automation (Phase 3 — do not implement now)

Candidates to automate later:

1. Fetch / sync product `showcase/metadata.json` into `content/projects/`
2. Validate Integration Definition paths against the remote tree
3. Index product `examples/` into registry `examples[]`
4. Pull version/description from pubspec / package provider
5. Drift detection (PR when product showcase changes)
6. Optional LICENSE / README prerequisite checks in CI

See [`roadmap/PHASE_3_AUTOMATION.md`](roadmap/PHASE_3_AUTOMATION.md).

---

## Reference onboardings

| projectId | Status | Notes |
|-----------|--------|--------|
| `document_platform` | integrated | Standalone Melos monorepo; reference implementation |
| `localization_analyzer` | integrated | Nested package under MBO |
| `ai_tray` | integrated | Standalone product; releases provider; LICENSE pending |

If a fourth project needs a **new metadata field** or architecture change:

1. Check whether **at least two** projects benefit
2. Prefer a new **provider** key over a one-off schema field
3. Update [`PROJECT_INTEGRATION.md`](PROJECT_INTEGRATION.md) + this guide together
4. Never add project-specific UI
