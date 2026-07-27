/// Application chrome: top navigation, content area, footer.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

/// Top-level layout wrapping routed page content.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    super.key,
    this.locationOverride,
  });

  final Widget child;
  final String? locationOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final location = locationOverride ?? _matchedLocation(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surface,
              Color.lerp(
                    scheme.surface,
                    scheme.primary,
                    theme.brightness == Brightness.light ? 0.06 : 0.12,
                  ) ??
                  scheme.surface,
              scheme.surface,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Column(
          children: [
            AppNavBar(location: location),
            Expanded(child: child),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  static String _matchedLocation(BuildContext context) {
    try {
      return GoRouterState.of(context).matchedLocation;
    } on Object {
      final uri = GoRouter.of(context).routeInformationProvider.value.uri;
      return uri.path.isEmpty ? AppRoutes.home : uri.path;
    }
  }
}
