# Brand Identity

RSProjects Showcase visual language (Web-first, cross-platform, Material 3).

Design target: premium product websites (Linear, Vercel, GitHub, Stripe) —
a handcrafted web product that happens to be built with Flutter. Prefer
alignment, spacing, typography, and hierarchy over decorative effects.

## Color

- **Theme engine:** FlexColorScheme with built-in **`FlexScheme.tealM3`** (Blue stone teal) — D-028.
- Deep teal primary, cool slate surfaces, restrained tertiary.
- Low surface blend; clean `surface` / `surfaceContainer*` hierarchy.
- Semantic status colors (success / warning / info) via `AppSemanticColors`.
- Widgets must use `Theme.of(context).colorScheme` or `context.semanticColors` — never raw hex.
- **No glossy gradients, shimmer, or fake lighting.** Occasional soft tonal containers only.

## Typography

- Material 2021 baseline with strengthened display/headline weights and tighter tracking.
- Hierarchy: Display (hero) → Headline Medium (sections) → Title Large (cards) → Body Large (copy) → Body Small (metadata).
- Prefer `Theme.of(context).textTheme` roles.
- Avoid decorative serif stacks — keep a developer-centric product feel.

## Spacing & radius

- `AppSpacing` — **8px scale**: 4, 8, 16, 24, 32, 48, 64, 96.
- `AppRadius`: chips ~10, buttons ~12, search ~16, cards ~16, dialogs ~20.
- One content grid (`AppBreakpoints.contentMaxWidth` = 1120). Nav, hero, content, and footer align to it.

## Layout

- Sticky navigation: transparent at top, solid after scroll.
- Page scroll owns the footer (brand, nav, GitHub, copyright, version).
- Equal-height card rows via `AppGrid` + flex footers inside cards.

## Iconography

- Use Material Icons / Symbols (`Icons.*`) for consistency across platforms.
- Prefer rounded variants (`Icons.*_rounded`) in chrome and CTAs.
- Keep icon size aligned to text: 18–20dp inline, 24dp actions, 32–40dp empty states.

## Motion

- Durations and curves: `AppMotion` (hover 150–200ms, 2–4dp lift).
- Material ripple on buttons; slight shadow increase on interactive cards.
- No dramatic animations.

## Breakpoints

- Compact &lt; 600, medium &lt; 905, expanded ≥ 905; content max width 1120 (`AppBreakpoints`).
