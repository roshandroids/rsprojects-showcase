/// Generic gallery that renders examples for any project.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/shared/demos/demo_pane.dart';
import 'package:rsprojects_showcase/shared/examples/example_card.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

/// Project-scoped example gallery — no product-specific UI.
///
/// Pass the registry examples list (or a pre-filtered subset). The gallery
/// filters by [projectId] and renders nothing when empty.
class ExampleGallery extends StatelessWidget {
  const ExampleGallery({
    required this.projectId,
    required this.examples,
    super.key,
    this.title = 'Examples / Playground',
    this.showDemoPanes = false,
  });

  final String projectId;
  final List<ProjectExample> examples;
  final String title;
  final bool showDemoPanes;

  @override
  Widget build(BuildContext context) {
    final resolved = examplesForProject(examples, projectId);

    if (resolved.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(title: title),
          const SizedBox(height: AppSpacing.xl),
          AppGrid(
            minTileWidth: 240,
            children: [
              for (final example in resolved) ExampleCard(example: example),
            ],
          ),
          if (showDemoPanes) ...[
            const SizedBox(height: AppSpacing.xl),
            for (final example in resolved)
              if (example.demo != null ||
                  example.demoUrl != null ||
                  example.media.isNotEmpty) ...[
                DemoPane(
                  spec: example.resolvedDemo,
                  title: example.title,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ],
      ),
    );
  }
}
