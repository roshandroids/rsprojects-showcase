/// About presentation layer.
///
/// **Why:** Renders about / credits / contact content.
/// **Owner:** About feature team.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/shared/widgets/placeholder_page_body.dart';

/// Placeholder about screen (shell-hosted).
///
/// TODO(about): Build about content sections and external links.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPageBody(
      eyebrow: 'About',
      title: 'RSProjects',
      subtitle:
          'This portal will introduce the RSProjects organization and how '
          'products in the showcase are selected and maintained.',
    );
  }
}
