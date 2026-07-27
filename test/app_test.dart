/// App-level smoke / navigation tests.
///
/// **Why:** Guards MaterialApp.router, theme, shell, and primary routes.
/// **Owner:** App layer + QA.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rsprojects_showcase/app/app.dart';
import 'package:rsprojects_showcase/app/router.dart';

void main() {
  GoRouter buildRouter() => createAppRouter();

  testWidgets('app shell builds on home route', (tester) async {
    await tester.pumpWidget(RsProjectsShowcaseApp(router: buildRouter()));
    await tester.pump();

    expect(find.textContaining('RSProjects'), findsWidgets);
    expect(find.text('Showcase'), findsWidgets);
  });

  testWidgets('top navigation reaches projects and about', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(RsProjectsShowcaseApp(router: router));
    await tester.pump();

    await tester.tap(find.text('Projects').last);
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.projects);
    expect(find.textContaining('Catalog'), findsOneWidget);

    await tester.tap(find.text('About').last);
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoutes.about);
    expect(find.textContaining('RSProjects'), findsWidgets);
  });

  testWidgets('unknown route shows 404 page', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(RsProjectsShowcaseApp(router: router));
    await tester.pump();

    router.go('/does-not-exist');
    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);
  });

  testWidgets('project detail route is reachable', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(RsProjectsShowcaseApp(router: router));
    await tester.pump();

    router.go(AppRoutes.projectDetailPath('ai_tray'));
    await tester.pumpAndSettle();

    expect(find.text('ai_tray'), findsOneWidget);
  });
}
