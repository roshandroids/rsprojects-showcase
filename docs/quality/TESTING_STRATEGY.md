# Testing Strategy

Testing is part of development, not a separate phase. Every feature should define its testing approach when planned.

## Pyramid

| Layer | Location | Intent |
|-------|----------|--------|
| Unit | `test/unit/` | Domain models, parsers, metadata validation, registry generation, utilities, services |
| Widget | `test/widget/` (+ existing `test/*_test.dart`) | Reusable widgets, cards, navigation, layouts, responsive behavior, theme switching |
| Golden | `test/golden/` | Visual regression: Home, Projects, nav, footer, cards, light/dark, responsive |
| Integration | `integration_test/` | Startup, routing, navigation, project loading, search, error handling |
| E2E smoke | `integration_test/smoke/` | Automated smoke paths for releases (architecture reserved) |
| Regression | `test/regression/` | Bug-fix tests keyed to issues / changelogs |

## Unit tests

Cover pure logic without UI:

- Domain entities and value objects
- Metadata parsers / validators (`scripts/validate_content.dart` logic when extracted)
- Registry generation helpers
- Diagnostics / feedback URL builders
- Utilities and services

## Widget tests

Cover UI composition with `flutter_test`:

- Shared layouts (`AppShell`, `ResponsiveContent`)
- Design-system consumers (theme switching)
- Navigation chrome and route destinations
- Future project cards and filters

## Integration tests

Drive the real app (or a wired subset) across flows:

- Application startup / bootstrap
- Routing and deep links
- Project loading (when registry lands)
- Search
- Error / crash experience paths

## Golden tests

Reserved for visual regression. Add goldens when UI surfaces stabilize:

- Home, Projects, Navigation, Footer, Cards
- Light mode and dark mode
- Compact / medium / expanded breakpoints

Use `matchesGoldenFile` and store baselines under `test/golden/`.

## End-to-end smoke

`integration_test/smoke/` holds future automated smoke suites for release candidates. Prefer a short critical path: launch → home → projects → detail → about.

## Feature checklist

When adding a feature, document:

1. Which layers need tests
2. Happy path + empty + error cases
3. Accessibility considerations
4. Whether goldens are warranted
