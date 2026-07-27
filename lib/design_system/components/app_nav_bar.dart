/// Top navigation bar for the application shell.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/design_system/app_breakpoints.dart';
import 'package:rsprojects_showcase/design_system/app_elevation.dart';
import 'package:rsprojects_showcase/design_system/app_motion.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/shared/layouts/responsive_content.dart';

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

/// Lightweight sticky top navigation — transparent at rest, solid when scrolled.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.location,
    super.key,
    this.scrolled = false,
    this.items = AppNavItems.primary,
  });

  final String location;
  final bool scrolled;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final compact = AppBreakpoints.isCompact(width);

    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      decoration: BoxDecoration(
        color: scrolled
            ? scheme.surface.withValues(alpha: AppElevation.chromeOpacity)
            : scheme.surface.withValues(alpha: 0),
        border: Border(
          bottom: BorderSide(
            color: scrolled
                ? scheme.outlineVariant.withValues(alpha: 0.7)
                : Colors.transparent,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.contentMaxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveContent.horizontalPadding(width),
                vertical: AppSpacing.xs,
              ),
              child: SizedBox(
                height: 48,
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
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: () => context.go(AppRoutes.home),
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxs,
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
                color: scheme.primary,
              ),
              alignment: Alignment.center,
              child: Text(
                'RS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppConstants.appTagline,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
                  fontWeight: item.isSelected(location)
                      ? FontWeight.w600
                      : FontWeight.w500,
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
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxs),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor:
              selected ? scheme.onSurface : scheme.onSurfaceVariant,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs + 4,
            vertical: AppSpacing.xs,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: AppMotion.fast,
              height: 2,
              width: selected ? 16 : 0,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
