/// Builds pre-filled GitHub issue URLs (canonical public tracker).
///
/// **Why:** GitHub Issues are the primary public feedback system.
/// **Owner:** Core quality / platform.
/// **When:** Open via a portable URL launcher abstraction (not added yet).
library;

import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/core/quality/feedback/feedback_models.dart';

/// Creates `https://github.com/.../issues/new` deep links with query params.
abstract final class GitHubIssueBuilder {
  GitHubIssueBuilder._();

  /// Returns a URI that opens a new issue with title/body/labels pre-filled.
  static Uri build({
    required FeedbackPayload payload,
    String? repositoryUrl,
  }) {
    final repo = repositoryUrl ?? AppConstants.githubRepoUrl;
    final type = payload.category.githubType;
    final labels = <String>[type.label];

    // GitHub "new issue" query API.
    return Uri.parse('$repo/issues/new').replace(
      queryParameters: <String, String>{
        'title': payload.title,
        'body': payload.toIssueBody(),
        'labels': labels.join(','),
      },
    );
  }
}
