/// Application routing configuration (go_router).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/features/about/presentation/about_screen.dart';
import 'package:rsprojects_showcase/features/home/presentation/home_screen.dart';
import 'package:rsprojects_showcase/features/projects/presentation/project_detail_screen.dart';
import 'package:rsprojects_showcase/features/projects/presentation/projects_screen.dart';
import 'package:rsprojects_showcase/features/settings/presentation/settings_screen.dart';
import 'package:rsprojects_showcase/shared/animations/shared_animations.dart';
import 'package:rsprojects_showcase/shared/layouts/app_shell.dart';
import 'package:rsprojects_showcase/shared/widgets/not_found_page.dart';

/// Canonical route path constants.
abstract final class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String about = '/about';
  static const String settings = '/settings';

  static String projectDetailPath(String id) => '/projects/$id';
}

/// Builds the application [GoRouter].
GoRouter createAppRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => appFadeSlidePage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.projects,
            name: 'projects',
            pageBuilder: (context, state) => appFadeSlidePage(
              key: state.pageKey,
              child: const ProjectsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: 'projectDetail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return appFadeSlidePage(
                    key: state.pageKey,
                    child: ProjectDetailScreen(projectId: id),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.about,
            name: 'about',
            pageBuilder: (context, state) => appFadeSlidePage(
              key: state.pageKey,
              child: const AboutScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => appFadeSlidePage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return AppShell(
        locationOverride: state.uri.path,
        child: NotFoundPage(uri: state.uri.toString()),
      );
    },
  );
}

/// Application router holder used by [RsProjectsShowcaseApp].
abstract final class AppRouter {
  AppRouter._();

  static final GoRouter router = createAppRouter();
}
