/// Root [MaterialApp.router] composition for RSProjects Showcase.
///
/// **Why:** Owns theme + router wiring for the whole portal.
/// **Owner:** App layer.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/app/theme.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';

/// Root application widget.
class RsProjectsShowcaseApp extends StatelessWidget {
  const RsProjectsShowcaseApp({
    super.key,
    this.router,
  });

  /// Optional router override for tests; defaults to [AppRouter.router].
  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.fullTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router ?? AppRouter.router,
    );
  }
}
