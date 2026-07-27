# Cross-Platform Validation

Web is the **primary deployment target**. The app must remain architecturally cross-platform.

## Supported targets

- Web
- Android
- iOS
- macOS
- Windows
- Linux

## Validation strategy (future CI)

1. Analyze + test on a primary CI image (Linux).
2. `flutter build` matrix for each enabled platform as runners allow.
3. Smoke integration on Web (primary) every PR; broaden as capacity allows.
4. Reject PRs that introduce shared-layer platform-only APIs (`dart:html`, unconditional `dart:io`, etc.).

## Rules

- Prefer portable packages (`go_router`, `flex_color_scheme` already qualify).
- Isolate unavoidable platform code behind adapters.
- Showcase **content** may be platform-specific; the **shell** must not be.

See `PROJECT_RULES.md` → Platform Support and decision **D-018**.
