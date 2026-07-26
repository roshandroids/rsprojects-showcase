/// Root [MaterialApp] / [WidgetsApp] composition for RSProjects Showcase.
///
/// **Why:** Owns the top-level widget tree (theme, router, localization hooks).
/// **Owner:** App layer.
/// **When:** Implement when routing and theme placeholders are ready.
library;

import 'package:flutter/material.dart';

/// Root application widget.
///
/// TODO(app): Wire [theme], [router], and feature shells.
class RsProjectsShowcaseApp extends StatelessWidget {
  const RsProjectsShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(app): Replace with themed MaterialApp.router (or equivalent).
    return const MaterialApp(
      title: 'RSProjects Showcase',
      home: Scaffold(
        body: Center(
          child: Text('RSProjects Showcase — architecture bootstrap'),
        ),
      ),
    );
  }
}
