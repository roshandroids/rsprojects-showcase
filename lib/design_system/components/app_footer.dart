/// Application footer.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/app_breakpoints.dart';
import 'package:rsprojects_showcase/design_system/app_elevation.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';
import 'package:rsprojects_showcase/design_system/components/app_button.dart';

/// Site footer with copyright and secondary links.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
        color: theme.colorScheme.surface.withValues(alpha: AppElevation.footerOpacity),
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
                  '© RSProjects — public showcase for products and tools',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              AppButton(
                label: 'Settings',
                variant: AppButtonVariant.text,
                size: AppButtonSize.small,
                onPressed: () => context.go(AppRoutes.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
