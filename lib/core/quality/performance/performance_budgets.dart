/// Performance budget placeholders (measurement not implemented yet).
///
/// **Why:** Regressions should be measurable against agreed targets.
/// **Owner:** Core quality / platform.
/// **When:** Wire instrumentation after budgets are ratified in docs.
library;

/// Named metrics we intend to track.
enum PerformanceMetric {
  startupTime,
  firstPageLoad,
  routeTransition,
  animationSmoothness,
  bundleSize,
  renderingPerformance,
}

/// Future budget thresholds — values are placeholders, not enforced.
abstract final class PerformanceBudgets {
  PerformanceBudgets._();

  /// TODO(quality): Replace with measured baselines per platform.
  static const Map<PerformanceMetric, String> targets = {
    PerformanceMetric.startupTime: 'TBD — cold start to first frame',
    PerformanceMetric.firstPageLoad: 'TBD — home interactive',
    PerformanceMetric.routeTransition: 'TBD — p95 transition duration',
    PerformanceMetric.animationSmoothness: 'TBD — jank / frame build budget',
    PerformanceMetric.bundleSize: 'TBD — web download size budget',
    PerformanceMetric.renderingPerformance: 'TBD — raster / build times',
  };
}
