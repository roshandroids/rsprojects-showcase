/// Core-level reusable widgets (loading, error, empty shells).
///
/// **Why:** Primitives used by many features without belonging to `shared/`.
/// **Owner:** Core platform.
/// **When:** Implement when first feature needs a shared loading/error shell.
library;

import 'package:flutter/widgets.dart';

/// Placeholder marker for core widgets package area.
///
/// TODO(core): Add AppLoadingView, AppErrorView, AppEmptyView.
class CoreWidgetsPlaceholder extends StatelessWidget {
  const CoreWidgetsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(core): Remove placeholder once real core widgets exist.
    return const SizedBox.shrink();
  }
}
