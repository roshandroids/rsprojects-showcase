/// Widget tests for critical design-system components.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('AppButton renders primary label', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      wrap(
        AppButton(
          label: 'Continue',
          onPressed: () => pressed = true,
        ),
      ),
    );
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(pressed, isTrue);
  });

  testWidgets('AppBadge exposes semantics label', (tester) async {
    await tester.pumpWidget(
      wrap(const AppBadge(label: 'beta', tone: AppBadgeTone.info)),
    );
    expect(find.bySemanticsLabel('beta'), findsOneWidget);
  });

  testWidgets('AppEmptyState shows title and action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        AppEmptyState(
          title: 'Nothing here',
          message: 'Try again later',
          actionLabel: 'Retry',
          onAction: () => tapped = true,
        ),
      ),
    );
    expect(find.text('Nothing here'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(tapped, isTrue);
  });
}
