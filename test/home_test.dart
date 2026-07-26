/// Home feature tests.
///
/// **Why:** Covers home presentation behavior.
/// **Owner:** Home feature team.
/// **When:** Expand when HomeScreen has real content and interactions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('home placeholder builds', (tester) async {
    // TODO(test): Cover hero CTAs and featured projects once implemented.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.textContaining('Home'), findsOneWidget);
  });
}
