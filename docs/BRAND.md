# Brand Identity

RSProjects Showcase visual language (Web-first, cross-platform).

## Color

- Brand seeds live in `AppBrand` / `AppColors` (`lib/design_system/app_colors.dart`).
- Semantic status colors (success / warning / info) via `AppSemanticColors`.
- Widgets must use `Theme.of(context).colorScheme` or `context.semanticColors` — never raw hex.

## Typography

- Display: serif fallbacks (`AppTypography.displayFallback`).
- Body: Material 2021 baseline.
- Prefer `Theme.of(context).textTheme` roles (`displaySmall`, `titleLarge`, `bodyLarge`, …).

## Spacing & radius

- `AppSpacing` (4px scale) and `AppRadius` for all layout rhythm and corners.

## Iconography

- Use Material Icons / Symbols (`Icons.*`) for consistency across platforms.
- Prefer rounded variants (`Icons.*_rounded`) in chrome and CTAs.
- Keep icon size aligned to text: 18–20dp inline, 24dp actions, 32–40dp empty states.

## Motion

- Durations and curves: `AppMotion`.
- Page transitions: short fade/slide; avoid noisy motion on catalog grids.

## Breakpoints

- Compact &lt; 600, medium &lt; 905, expanded ≥ 905; content max width 1120 (`AppBreakpoints`).
