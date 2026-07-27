# Performance Budget

Measurement is **not implemented yet**. This document reserves goals so regressions can become measurable.

## Metrics to track

| Metric | Intent |
|--------|--------|
| Startup time | Cold start → first useful frame |
| First page load | Home interactive |
| Route transition | Navigation jank / duration |
| Animation smoothness | Frame build / raster health |
| Bundle size | Especially Flutter Web download cost |
| Rendering performance | Build/layout hotspots |

Placeholder targets: `PerformanceBudgets.targets` in `lib/core/quality/performance/`.

## Principles

- Performance regressions should be measurable.
- Budgets will be ratified per platform (Web primary).
- Avoid optimizing without baselines.
