/// 404 / unknown route page.
///
/// **Why:** Friendly fallback when go_router cannot match a location.
/// **Owner:** Shared platform.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/shared/widgets/placeholder_page_body.dart';

/// Polished not-found page hosted inside [AppShell] via errorBuilder.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.uri});

  final String? uri;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPageBody(
      eyebrow: '404',
      title: 'Page not found',
      subtitle: uri == null || uri!.isEmpty
          ? 'That route does not exist in the showcase portal.'
          : 'No page matches “$uri”. Check the URL or return home.',
      actions: [
        FilledButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('Back to Home'),
        ),
        OutlinedButton(
          onPressed: () => context.go(AppRoutes.projects),
          child: const Text('Browse Projects'),
        ),
      ],
    );
  }
}
