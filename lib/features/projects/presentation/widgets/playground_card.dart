/// Catalog card for a hosted playground (metadata-driven, never branches on id).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/core/services/open_url.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';

/// Lists a playground with optional Open Playground action.
class PlaygroundCard extends StatelessWidget {
  const PlaygroundCard({required this.playground, super.key});

  final ProjectPlayground playground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final projectId = playground.projectId;

    return AppCard(
      elevated: playground.canOpen,
      onTap: projectId == null || projectId.isEmpty
          ? null
          : () => context.go(AppRoutes.projectDetailPath(projectId)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(playground.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              playground.category,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
              ),
            ),
            if (playground.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                playground.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppBadge(label: playground.status.name),
                if (playground.version != null)
                  AppBadge(label: 'v${playground.version}'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (playground.canOpen)
              AppButton(
                label: 'Open Playground',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  final opened = openUrl(playground.resolvedUrl);
                  if (!opened && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(playground.resolvedUrl)),
                    );
                  }
                },
              )
            else
              Text(
                playground.status == PlaygroundStatus.unavailable
                    ? 'Playground unavailable'
                    : 'Playground not deployed yet',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
