/// Projects feature tests.
///
/// **Why:** Covers catalog presentation and later domain/application behavior.
/// **Owner:** Projects feature team.
/// **When:** Expand with repository fakes once infrastructure exists.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/features/projects/presentation/projects_screen.dart';

void main() {
  testWidgets('projects placeholder builds', (tester) async {
    // TODO(test): Cover loading / empty / error / data states.
    await tester.pumpWidget(const MaterialApp(home: ProjectsScreen()));
    expect(find.textContaining('Projects'), findsOneWidget);
  });
}
