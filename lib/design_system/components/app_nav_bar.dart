/// Top navigation bar for the application shell.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/design_system/app_breakpoints.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

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

/// Primary top-nav destinations.
abstract final class AppNavItems {
  AppNavItems._();

  static const List<AppNavItem> primary = [
    AppNavItem(label: 'Home', path: AppRoutes.home),
    AppNavItem(label: 'Projects', path: AppRoutes.projects),
    AppNavItem(label: 'About', path: AppRoutes.about),
  ];
}

/// Responsive top navigation with brand mark and active route highlight.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.location,
    super.key,
    this.items = AppNavItems.primary,
  });

  final String location;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      surfaceTintColor: theme.colorScheme.surfaceTint,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
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
                  _OverflowNav(location: location, items: items)
                else
                  _DesktopNav(location: location, items: items),
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
                  if (!compact)
                    TextSpan(
                      text: ' ${AppConstants.appTagline}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
  const _DesktopNav({required this.location, required this.items});

  final String location;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in items)
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
  const _OverflowNav({required this.location, required this.items});

  final String location;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Navigate',
      onSelected: (path) => context.go(path),
      itemBuilder: (context) {
        return [
          for (final item in items)
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
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
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
