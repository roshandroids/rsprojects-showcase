/// Quality engineering barrel (crash, diagnostics, feedback, a11y, perf, tools).
///
/// **Why:** Single import for the quality foundation; expandable per capability.
/// **Owner:** Core quality / platform.
library;

export 'package:rsprojects_showcase/core/quality/accessibility/accessibility_requirements.dart';
export 'package:rsprojects_showcase/core/quality/crash/crash_handler.dart';
export 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
export 'package:rsprojects_showcase/core/quality/developer/developer_tools.dart';
export 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_service.dart';
export 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_snapshot.dart';
export 'package:rsprojects_showcase/core/quality/diagnostics/platform_context.dart';
export 'package:rsprojects_showcase/core/quality/error_experience/error_experience.dart';
export 'package:rsprojects_showcase/core/quality/feedback/email_report_builder.dart';
export 'package:rsprojects_showcase/core/quality/feedback/feedback_models.dart';
export 'package:rsprojects_showcase/core/quality/feedback/feedback_service.dart';
export 'package:rsprojects_showcase/core/quality/feedback/github_issue_builder.dart';
export 'package:rsprojects_showcase/core/quality/performance/performance_budgets.dart';
