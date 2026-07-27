/// Unit tests for quality feedback / crash report formatting.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/core/quality/quality.dart';

void main() {
  group('CrashReport', () {
    test('toDiagnosticsBlock includes exception and platform', () {
      final report = CrashReport(
        timestamp: DateTime.utc(2026, 7, 26),
        exception: 'StateError: boom',
        stackTrace: 'stack',
        appVersion: '0.0.1',
        buildNumber: '1',
        platform: 'web',
        operatingSystem: 'web',
        browser: 'web',
        route: '/',
        themeMode: 'system',
        locale: 'en',
        screenSize: '800x600',
        devicePixelRatio: 2,
      );

      final block = report.toDiagnosticsBlock();
      expect(block, contains('StateError: boom'));
      expect(block, contains('web'));
      expect(block, contains('0.0.1'));
    });
  });

  group('GitHubIssueBuilder', () {
    test('builds issues/new URI with label and body', () {
      const payload = FeedbackPayload(
        category: FeedbackCategory.reportBug,
        title: 'Nav highlight broken',
        description: 'Active route not highlighted on Projects.',
      );

      final uri = GitHubIssueBuilder.build(payload: payload);
      expect(uri.path, contains('/issues/new'));
      expect(uri.queryParameters['title'], 'Nav highlight broken');
      expect(uri.queryParameters['labels'], 'bug');
      expect(uri.queryParameters['body'], contains('Active route'));
    });
  });

  group('EmailReportBuilder', () {
    test('builds mailto URI', () {
      const payload = FeedbackPayload(
        category: FeedbackCategory.suggestFeature,
        title: 'Add filters',
        description: 'Category filters on catalog.',
      );

      final uri = EmailReportBuilder.build(payload: payload);
      expect(uri.scheme, 'mailto');
      expect(uri.queryParameters['subject'], contains('Suggest Feature'));
    });
  });
}
