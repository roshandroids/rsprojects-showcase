/// Orchestrates community feedback channels (GitHub + email).
///
/// **Why:** Single entry for Report Bug / Suggest Feature / etc.
/// **Owner:** Core quality / platform.
library;

import 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_service.dart';
import 'package:rsprojects_showcase/core/quality/feedback/email_report_builder.dart';
import 'package:rsprojects_showcase/core/quality/feedback/feedback_models.dart';
import 'package:rsprojects_showcase/core/quality/feedback/github_issue_builder.dart';

/// Thank-you copy shown after feedback actions.
abstract final class FeedbackMessages {
  FeedbackMessages._();

  static const String thankYou =
      'Thank you for helping improve RSProjects. Every report, suggestion, '
      'and idea helps make the ecosystem better for everyone.';
}

/// Builds report URIs; launching is left to a future portable URL opener.
class FeedbackService {
  const FeedbackService({
    this.diagnostics = const DiagnosticsService(),
  });

  final DiagnosticsService diagnostics;

  FeedbackPayload compose({
    required FeedbackCategory category,
    required String title,
    required String description,
    bool includeDiagnostics = true,
    CrashReport? crashReport,
  }) {
    return FeedbackPayload(
      category: category,
      title: title,
      description: description,
      diagnostics: includeDiagnostics ? diagnostics.capture() : null,
      crashReport: crashReport,
    );
  }

  Uri githubIssueUri(FeedbackPayload payload) =>
      GitHubIssueBuilder.build(payload: payload);

  Uri emailUri(FeedbackPayload payload) =>
      EmailReportBuilder.build(payload: payload);

  // TODO(quality): openUri(Uri) via cross-platform UrlLauncherPort.
}
