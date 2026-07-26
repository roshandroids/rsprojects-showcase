/// Home presentation layer (screens, widgets, view bindings).
///
/// **Why:** UI for the landing page; no domain or data access here.
/// **Owner:** Home feature team.
/// **When:** Implement when design and content model are ready.
library;

import 'package:flutter/material.dart';

/// Placeholder home screen.
///
/// TODO(home): Build hero, featured projects, and navigation CTAs.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(home): Replace placeholder body with real home composition.
    return const Scaffold(
      body: Center(child: Text('Home — TODO')),
    );
  }
}
