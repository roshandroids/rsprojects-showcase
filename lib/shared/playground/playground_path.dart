/// Joins a repo-root-relative playground `demoPath` (e.g. `/generated/x/`)
/// against this app's own GitHub Pages project-site path, independent of
/// how deep the current route is.
///
/// Pure and unit-testable — this is the exact join the showcase team got
/// wrong once already (see docs/DEPLOYMENT.md), so it is asserted against a
/// literal expected string in `test/unit/playground_path_test.dart` rather
/// than only reasoned about.
library;

import 'package:rsprojects_showcase/core/constants/app_constants.dart';

/// Absolute site path for a playground's `demoPath`, e.g.
/// `/rsprojects-showcase/generated/document-platform/`.
String buildPlaygroundAbsolutePath(String demoPath) {
  return '${AppConstants.pagesBasePath}$demoPath';
}

/// Resolves [demoPath] against [base] (normally `Uri.base`) as an
/// absolute-path reference, so it opens the playground correctly regardless
/// of the current in-app route depth.
Uri resolvePlaygroundUri(Uri base, String demoPath) {
  return base.resolve(buildPlaygroundAbsolutePath(demoPath));
}
