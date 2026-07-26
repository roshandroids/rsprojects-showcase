/// Shared UI widgets used across features.
///
/// **Why:** Reusable presentational pieces that are not feature-owned.
/// **Owner:** Shared platform / design system.
/// **When:** Extract when the same widget appears in 2+ features.
library;

import 'package:flutter/widgets.dart';

/// Placeholder for shared widgets area.
///
/// TODO(shared): Add buttons, chips, project cards only when reuse is clear.
class SharedWidgetsPlaceholder extends StatelessWidget {
  const SharedWidgetsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
