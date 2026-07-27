# Brand Identity

RSProjects Showcase visual language (Web-first, cross-platform, Material 3).

## Color

- **Theme engine:** FlexColorScheme with built-in **`FlexScheme.tealM3`** (Blue stone teal) — D-028.
- Deep teal primary, cool slate surfaces, restrained tertiary; cyan/indigo accents live in semantic chrome where needed.
- Semantic status colors (success / warning / info) via `AppSemanticColors`.
- Widgets must use `Theme.of(context).colorScheme` or `context.semanticColors` — never raw hex.

## Typography

- Material 2021 baseline with strengthened display/headline weights and tighter tracking.
- Prefer `Theme.of(context).textTheme` roles (`displaySmall`, `titleLarge`, `bodyLarge`, …).
- Avoid decorative serif stacks — keep a developer-centric product feel.

## Spacing & radius

- `AppSpacing` (4px scale).
- `AppRadius`: chips ~11, buttons ~14, cards ~18, dialogs ~20.

## Iconography

- Use Material Icons / Symbols (`Icons.*`) for consistency across platforms.
- Prefer rounded variants (`Icons.*_rounded`) in chrome and CTAs.
- Keep icon size aligned to text: 18–20dp inline, 24dp actions, 32–40dp empty states.

## Motion

- Durations and curves: `AppMotion`.
- Page transitions: short fade/slide; card hover elevation on interactive surfaces.
- Avoid noisy motion on catalog grids.

## Breakpoints

- Compact &lt; 600, medium &lt; 905, expanded ≥ 905; content max width 1120 (`AppBreakpoints`).
