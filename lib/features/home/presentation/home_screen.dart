/// Home presentation layer (screens, widgets, view bindings).
///
/// **Why:** UI for the landing page; no domain or data access here.
/// **Owner:** Home feature team.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/shared/widgets/placeholder_page_body.dart';

/// Placeholder home screen (shell-hosted).
///
/// TODO(home): Build brand-first hero, featured projects, and navigation CTAs.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPageBody(
      eyebrow: 'RSProjects',
      title: 'Showcase',
      subtitle:
          'Public portal for RSProjects products. The application shell, '
          'theme, and navigation are in place — catalog content comes next.',
      actions: [
        FilledButton(
          onPressed: () => context.go(AppRoutes.projects),
          child: const Text('View Projects'),
        ),
        OutlinedButton(
          onPressed: () => context.go(AppRoutes.about),
          child: const Text('About'),
        ),
      ],
    );
  }
}
