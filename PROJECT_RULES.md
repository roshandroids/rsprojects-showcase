# Project Rules

## Architecture

- Feature-first Clean Architecture: UI → State → Domain → Data.
- UI must not access APIs or filesystems directly.
- DTOs stay in infrastructure; map to domain before UI.

## Platform Support

- **Web is the primary deployment target** for RSProjects Showcase.
- The project must remain **cross-platform by architecture**: Web, Android, iOS, macOS, Windows, and Linux must continue to build successfully.
- Platform-specific implementations (plugins, channel code, host UI) must be isolated behind abstractions — never leaked into shared UI, domain, or application layers.
- Avoid web-only or desktop-only APIs in shared layers (`lib/app`, `lib/core`, `lib/features`, `lib/shared`, `lib/design_system`). Prefer Flutter/Dart portable APIs.
- Showcase **content** may be platform-specific (e.g. a project that only ships on mobile), but the **application shell and architecture** must not be.
- Every new dependency must be evaluated for **cross-platform compatibility** before adoption (starting with theming and routing; currently `flex_color_scheme` and `go_router`). Prefer packages that support all Flutter platforms.
- When a capability truly cannot be portable, introduce a thin platform adapter and keep feature code against the abstraction.
- Every public release should be testable on all supported Flutter platforms.

## Quality Engineering

Quality is a **core product feature**. See `docs/quality/` and `lib/core/quality/`.

### Engineering principles

- Testing is part of development, not a separate phase.
- Every feature should define its testing strategy.
- **Every bug fix requires a regression test** (no fix is complete without one).
- Diagnostics should simplify reproducing issues.
- Community feedback is welcomed and encouraged.
- **GitHub Issues** are the primary public feedback system; **email** is the fallback.
- Accessibility is a default expectation.
- Performance regressions should be measurable.
- The showcase should demonstrate engineering excellence as much as visual polish.
- Never expose Flutter’s default release error screen as the user-facing experience.

### Testing

- Follow `docs/quality/TESTING_STRATEGY.md` (unit, widget, integration, golden, E2E smoke).
- Regression policy: `docs/quality/REGRESSION_POLICY.md`.
- Prefer adding tests alongside features and bug fixes.

### Quality gates

- CI pipeline architecture: Format → Analyze → Unit → Widget → Golden → Integration → Content Validation → Cross-Platform Build → Deploy.
- Details: `docs/quality/QUALITY_GATES.md` and `.github/workflows/ci.yml`.
- Future: PRs cannot merge unless required gates pass.

### Crash, diagnostics, feedback

- Crash handling and diagnostics: `docs/quality/CRASH_AND_DIAGNOSTICS.md`.
- Community feedback (GitHub + email): `docs/quality/COMMUNITY_FEEDBACK.md`.
- Do not integrate Crashlytics/Sentry/etc. until explicitly decided.

### Accessibility & performance

- Accessibility: `docs/quality/ACCESSIBILITY.md`.
- Performance budgets (measurement TBD): `docs/quality/PERFORMANCE_BUDGET.md`.

### Cross-platform validation

- `docs/quality/CROSS_PLATFORM_VALIDATION.md`.

## Scope discipline

- Do not implement business logic in bootstrap placeholders until a feature is scheduled.
- No dead folders; every directory has a documented purpose.
- Prefer refactoring existing structure over inventing parallel patterns.
- Do not over-engineer quality foundation stubs — expand capabilities incrementally.

## Dependencies

- Do not add packages unless required by an active feature.
- Prefer Flutter SDK primitives until routing / state / markdown needs are real.
- Before adopting a package, confirm it supports Web + mobile + desktop targets required by Platform Support above.

## Content

- Project source of truth lives under `content/projects/`.
- `assets/generated/registry.json` is produced by tooling/CI, not hand-edited for releases.

## Commits

TODO: Conventional Commits; keep PRs focused. Include changelog notes for user-visible fixes when the release train requires it.
