/// Root [MaterialApp.router] composition for RSProjects Showcase.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/router.dart';
import 'package:rsprojects_showcase/app/theme.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';

/// Root application widget.
///
/// Wrap with [ProviderScope] at the call site (bootstrap or tests) so
/// repository overrides can be applied without nested scopes.
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

/// Convenience root used by [bootstrap] with a default [ProviderScope].
class RsProjectsShowcaseRoot extends StatelessWidget {
  const RsProjectsShowcaseRoot({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: RsProjectsShowcaseApp(router: router),
    );
  }
}
