/// Home feature tests.
///
/// **Why:** Covers home presentation behavior.
/// **Owner:** Home feature team.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('home placeholder builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Showcase'), findsOneWidget);
  });
}
