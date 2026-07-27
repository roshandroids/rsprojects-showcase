/// 404 / unknown route page.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

/// Polished not-found page hosted inside [AppShell].
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.uri});

  final String? uri;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader(
            eyebrow: '404',
            title: 'Page not found',
            subtitle:
                'That route does not exist in the showcase portal. '
                'Check the URL or return home.',
          ),
          if (uri != null && uri!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Requested: $uri',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'Back to Home',
                icon: Icons.home_rounded,
                onPressed: () => context.go(AppRoutes.home),
              ),
              AppButton(
                label: 'Browse Projects',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go(AppRoutes.projects),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
