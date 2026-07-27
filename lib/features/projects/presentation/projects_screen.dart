/// Projects presentation layer (list, detail, filters UI).
///
/// **Why:** Renders project catalog UI; consumes application state only.
/// **Owner:** Projects feature team.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/shared/widgets/placeholder_page_body.dart';

/// Placeholder projects catalog screen (shell-hosted).
///
/// TODO(projects): Build project grid/list and wire registry-backed state.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPageBody(
      eyebrow: 'Catalog',
      title: 'Projects',
      subtitle:
          'Project discovery will load from the generated registry. '
          'No metadata parsing or loading is implemented in this milestone.',
      actions: [
        OutlinedButton(
          onPressed: () => context.go(AppRoutes.projectDetailPath('example')),
          child: const Text('Open sample detail route'),
        ),
      ],
    );
  }
}
