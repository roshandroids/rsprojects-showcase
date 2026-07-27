/// Application chrome: sticky navigation, scrollable content, page footer.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

/// Top-level layout wrapping routed page content.
///
/// Navigation stays fixed; page body scrolls and owns the footer so the
/// footer relates to content rather than floating on the viewport.
class AppShell extends StatefulWidget {
  const AppShell({
    required this.child,
    super.key,
    this.locationOverride,
  });

  final Widget child;
  final String? locationOverride;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _scrolled = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final location = widget.locationOverride ?? _matchedLocation(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          AppNavBar(location: location, scrolled: _scrolled),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.axis != Axis.vertical) {
                  return false;
                }
                final next = notification.metrics.pixels > 8;
                if (next != _scrolled) {
                  setState(() => _scrolled = next);
                }
                return false;
              },
              child: widget.child,
            ),
          ),
        ],
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
