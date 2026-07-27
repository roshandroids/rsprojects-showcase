/// Project detail presentation placeholder.
///
/// **Why:** Reserves `/projects/:id` for future registry-backed detail UI.
/// **Owner:** Projects feature team.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/shared/widgets/placeholder_page_body.dart';

/// Placeholder detail screen for a single project id.
///
/// TODO(projects): Load project by id from domain/repository once available.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPageBody(
      eyebrow: 'Project detail',
      title: projectId.isEmpty ? 'Unknown project' : projectId,
      subtitle:
          'Detail content, screenshots, and documentation will appear here '
          'after the content pipeline and projects domain layer land.',
      actions: [
        FilledButton(
          onPressed: () => context.go(AppRoutes.projects),
          child: const Text('Back to Projects'),
        ),
      ],
    );
  }
}
