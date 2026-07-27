/// Builds `mailto:` URIs for fallback email reporting.
///
/// **Why:** Email is the secondary channel when GitHub is unavailable.
/// **Owner:** Core quality / platform.
/// **When:** Open with the platform email client via a portable launcher.
library;

import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_snapshot.dart';
import 'package:rsprojects_showcase/core/quality/feedback/feedback_models.dart';

/// Creates mailto links with subject + body pre-filled.
abstract final class EmailReportBuilder {
  EmailReportBuilder._();

  static Uri build({
    required FeedbackPayload payload,
    String? to,
  }) {
    final recipient = to ?? AppConstants.maintainerEmail;
    final subject = '[RSProjects Showcase] ${payload.category.displayName}: '
        '${payload.title}';
    return Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: <String, String>{
        // Uri replaces spaces with +; clients generally accept this.
        'subject': subject,
        'body': payload.toIssueBody(),
      },
    );
  }

  /// Convenience for crash-only reports.
  static Uri buildCrashReport({
    required CrashReport crashReport,
    DiagnosticsSnapshot? diagnostics,
    String? to,
  }) {
    return build(
      to: to,
      payload: FeedbackPayload(
        category: FeedbackCategory.reportBug,
        title: 'Crash: ${crashReport.exception.split('\n').first}',
        description:
            'A crash was captured in RSProjects Showcase.\n\n'
            'Please investigate using the attached diagnostics.',
        diagnostics: diagnostics,
        crashReport: crashReport,
      ),
    );
  }
}
