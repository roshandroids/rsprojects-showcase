/// Community feedback categories and payloads.
///
/// **Why:** First-class feedback even when the app has not crashed.
/// **Owner:** Core quality / platform.
library;

import 'package:flutter/foundation.dart';
import 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_snapshot.dart';

/// Supported feedback kinds (maps to GitHub labels / email subjects).
enum FeedbackCategory {
  reportBug,
  suggestFeature,
  uiUx,
  documentation,
  performance,
  accessibility,
  general,
}

/// GitHub issue label / type associated with [FeedbackCategory].
enum GitHubIssueType {
  bug,
  enhancement,
  documentation,
  performance,
  ui,
  accessibility,
  question,
}

/// Extension helpers for feedback → GitHub mapping.
extension FeedbackCategoryX on FeedbackCategory {
  String get displayName => switch (this) {
        FeedbackCategory.reportBug => 'Report Bug',
        FeedbackCategory.suggestFeature => 'Suggest Feature',
        FeedbackCategory.uiUx => 'UI/UX Feedback',
        FeedbackCategory.documentation => 'Documentation Feedback',
        FeedbackCategory.performance => 'Performance Feedback',
        FeedbackCategory.accessibility => 'Accessibility Feedback',
        FeedbackCategory.general => 'General Feedback',
      };

  GitHubIssueType get githubType => switch (this) {
        FeedbackCategory.reportBug => GitHubIssueType.bug,
        FeedbackCategory.suggestFeature => GitHubIssueType.enhancement,
        FeedbackCategory.uiUx => GitHubIssueType.ui,
        FeedbackCategory.documentation => GitHubIssueType.documentation,
        FeedbackCategory.performance => GitHubIssueType.performance,
        FeedbackCategory.accessibility => GitHubIssueType.accessibility,
        FeedbackCategory.general => GitHubIssueType.question,
      };
}

extension GitHubIssueTypeX on GitHubIssueType {
  String get label => name;
}

/// User-authored feedback plus optional diagnostics / crash context.
@immutable
class FeedbackPayload {
  const FeedbackPayload({
    required this.category,
    required this.title,
    required this.description,
    this.diagnostics,
    this.crashReport,
  });

  final FeedbackCategory category;
  final String title;
  final String description;
  final DiagnosticsSnapshot? diagnostics;
  final CrashReport? crashReport;

  String toIssueBody() {
    final buffer = StringBuffer()
      ..writeln(description.trim())
      ..writeln();
    if (diagnostics != null) {
      buffer.writeln(diagnostics!.toCopyableText());
    }
    if (crashReport != null) {
      buffer
        ..writeln()
        ..writeln(crashReport!.toDiagnosticsBlock());
    }
    return buffer.toString().trimRight();
  }
}
