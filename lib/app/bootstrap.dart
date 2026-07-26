/// Application bootstrap / startup orchestration.
///
/// **Why:** Central place for binding Flutter, loading config, and launching the app.
/// **Owner:** App layer.
/// **When:** Expand when DI, remote config, and registry loading are introduced.
library;

import 'package:flutter/widgets.dart';
import 'package:rsprojects_showcase/app/app.dart';

/// Initializes the runtime and launches [RsProjectsShowcaseApp].
///
/// TODO(app):
/// - EnsureInitialized / error handlers
/// - Load generated project registry
/// - Configure providers / DI
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(app): Perform async startup (registry, feature flags, etc.).

  runApp(const RsProjectsShowcaseApp());
}
