/// Friendly error experience — never show Flutter's default release red screen.
///
/// **Why:** Errors are a product surface: restart, diagnostics, and report paths.
/// **Owner:** Core quality / UI.
/// **When:** Wire into [CrashHandler] listener and [ErrorWidget.builder].
library;

import 'package:flutter/widgets.dart';
import 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
import 'package:rsprojects_showcase/core/quality/feedback/feedback_service.dart';

/// Actions available on the friendly error surface.
enum ErrorExperienceAction {
  restart,
  copyDiagnostics,
  reportBug,
  createGitHubIssue,
  contactMaintainer,
}

/// Contract for presenting a non-fatal / fatal error UI.
abstract interface class ErrorExperiencePresenter {
  void present(CrashReport report);

  void dismiss();
}

/// Placeholder presenter — logs until a real overlay/route is implemented.
class LoggingErrorExperiencePresenter implements ErrorExperiencePresenter {
  @override
  void present(CrashReport report) {
    // TODO(quality): Push friendly error page / dialog with actions.
    debugPrint('ErrorExperience: ${report.exception}');
  }

  @override
  void dismiss() {}
}

/// Suggested thank-you message after feedback from the error surface.
String get errorFeedbackThankYou => FeedbackMessages.thankYou;

/// Marker widget reserved for the friendly error page body.
///
/// TODO(quality): Implement restart / copy / report / GitHub / email actions.
class FriendlyErrorPage extends StatelessWidget {
  const FriendlyErrorPage({
    required this.report,
    super.key,
    this.onAction,
  });

  final CrashReport report;
  final void Function(ErrorExperienceAction action)? onAction;

  @override
  Widget build(BuildContext context) {
    // Structural placeholder only — full UI lands with error-experience feature work.
    return const ColoredBox(
      color: Color(0xFF0B1220),
      child: Center(
        child: Text(
          'Something went wrong.\n'
          'Restart · Copy Diagnostics · Report Bug · GitHub Issue · Contact',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFE8EEF5)),
        ),
      ),
    );
  }
}
