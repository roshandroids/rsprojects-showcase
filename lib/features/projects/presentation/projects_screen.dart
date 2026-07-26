/// Projects presentation layer (list, detail, filters UI).
///
/// **Why:** Renders project catalog UI; consumes application state only.
/// **Owner:** Projects feature team.
/// **When:** Implement after domain models and providers exist.
library;

import 'package:flutter/material.dart';

/// Placeholder projects catalog screen.
///
/// TODO(projects): Build project grid/list and detail navigation.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(projects): Wire AsyncValue states (loading / empty / error / data).
    return const Scaffold(
      body: Center(child: Text('Projects — TODO')),
    );
  }
}
