/// App-level smoke / widget tests.
///
/// **Why:** Guards bootstrap and root app composition.
/// **Owner:** App layer + QA.
/// **When:** Expand when router and theme are wired.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/app/app.dart';

void main() {
  testWidgets('app placeholder builds', (tester) async {
    // TODO(test): Assert real routes / theme once implemented.
    await tester.pumpWidget(const RsProjectsShowcaseApp());
    expect(find.textContaining('RSProjects Showcase'), findsOneWidget);
  });
}
