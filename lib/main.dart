/// Application entry point for RSProjects Showcase.
///
/// **Why:** Flutter requires a `main` entry; this wires into [bootstrap].
/// **Owner:** App / platform team.
/// **When:** Wired during initial bootstrap; keep logic out of this file.
library;

import 'package:rsprojects_showcase/app/bootstrap.dart';

Future<void> main() async {
  // TODO(app): Delegate all startup work to bootstrap().
  await bootstrap();
}
