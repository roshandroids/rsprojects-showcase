/// Projects feature tests.
///
/// **Why:** Covers catalog presentation and later domain/application behavior.
/// **Owner:** Projects feature team.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/presentation/projects_screen.dart';

void main() {
  testWidgets('projects placeholder builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: ProjectsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Projects'), findsOneWidget);
  });
}
