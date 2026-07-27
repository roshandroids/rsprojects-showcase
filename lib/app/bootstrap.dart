/// Application bootstrap / startup orchestration.
///
/// **Why:** Central place for binding Flutter, crash hooks, and launching the app.
/// **Owner:** App layer.
library;

import 'package:flutter/widgets.dart';
import 'package:rsprojects_showcase/app/app.dart';
import 'package:rsprojects_showcase/core/quality/quality.dart';

/// Initializes the runtime and launches [RsProjectsShowcaseRoot].
///
/// Binding initialization and [runApp] must share the same zone (Flutter
/// asserts otherwise when [CrashHandler.runGuarded] uses [runZonedGuarded]).
Future<void> bootstrap() async {
  CrashHandler.runGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    CrashHandler.install(
      listener: LoggingErrorExperiencePresenter().present,
    );

    runApp(const RsProjectsShowcaseRoot());
  });
}
