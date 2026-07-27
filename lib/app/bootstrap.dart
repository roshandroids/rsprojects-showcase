/// Application bootstrap / startup orchestration.
///
/// **Why:** Central place for binding Flutter, crash hooks, and launching the app.
/// **Owner:** App layer.
library;

import 'package:flutter/widgets.dart';
import 'package:rsprojects_showcase/app/app.dart';
import 'package:rsprojects_showcase/core/quality/quality.dart';

/// Initializes the runtime and launches [RsProjectsShowcaseApp].
///
/// TODO(app): Load generated project registry; configure providers / DI.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  CrashHandler.install(
    listener: LoggingErrorExperiencePresenter().present,
  );

  // Capture uncaught async errors while starting the app.
  CrashHandler.runGuarded(() {
    runApp(const RsProjectsShowcaseRoot());
  });
}
