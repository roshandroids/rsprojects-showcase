/// Application chrome: top navigation, content area, footer.
///
/// **Why:** Shared shell for all primary routes so features only supply page bodies.
/// **Owner:** Shared platform.
/// **When:** Milestone 1 — application shell.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

/// Top-level layout wrapping routed page content.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    super.key,
    this.locationOverride,
  });

  final Widget child;

  /// Used when [GoRouter.state] is unavailable (e.g. errorBuilder 404 pages).
  final String? locationOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final compact = AppBreakpoints.isCompact(width);
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
            _TopNav(compact: compact, location: location),
            Expanded(child: child),
            const _Footer(),
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

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.compact,
    required this.location,
  });

  final bool compact;
  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.86),
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.md : AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _BrandMark(compact: compact),
                const Spacer(),
                if (compact)
                  _OverflowNav(location: location)
                else
                  _DesktopNav(location: location),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.go(AppRoutes.home),
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderSm,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'RS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppConstants.appName,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (!compact) ...[
                    TextSpan(
                      text: ' ${AppConstants.appTagline}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in AppNavItems.primary)
          _NavLink(
            label: item.label,
            path: item.path,
            selected: item.isSelected(location),
          ),
      ],
    );
  }
}

class _OverflowNav extends StatelessWidget {
  const _OverflowNav({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Navigate',
      onSelected: (path) => context.go(path),
      itemBuilder: (context) {
        return [
          for (final item in AppNavItems.primary)
            PopupMenuItem(
              value: item.path,
              child: Text(
                item.label,
                style: TextStyle(
                  fontWeight:
                      item.isSelected(location) ? FontWeight.w700 : FontWeight.w500,
                  color: item.isSelected(location)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          Icons.menu_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.path,
    required this.selected,
  });

  final String label;
  final String path;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final compact = AppBreakpoints.isCompact(width);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.md : AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '© RSProjects — portal foundation in progress',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.settings),
                child: const Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primary top-nav destinations (Home / Projects / About).
abstract final class AppNavItems {
  AppNavItems._();

  static const List<AppNavItem> primary = [
    AppNavItem(label: 'Home', path: AppRoutes.home),
    AppNavItem(label: 'Projects', path: AppRoutes.projects),
    AppNavItem(label: 'About', path: AppRoutes.about),
  ];
}

/// A single top-navigation destination.
class AppNavItem {
  const AppNavItem({required this.label, required this.path});

  final String label;
  final String path;

  bool isSelected(String location) {
    if (path == AppRoutes.home) {
      return location == AppRoutes.home;
    }
    return location == path || location.startsWith('$path/');
  }
}
