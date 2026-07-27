# Crash Handling & Diagnostics

## Crash handling

Centralized in `lib/core/quality/crash/`.

- Captures Flutter framework errors (`FlutterError.onError`)
- Captures platform dispatcher / async errors
- Zone-guarded startup via `CrashHandler.runGuarded`
- Builds structured [`CrashReport`](../../lib/core/quality/crash/crash_report.dart) models

**No** Crashlytics, Sentry, or other external reporters in this foundation.

### Crash report fields

app version, build number, platform, OS, browser (web), route, theme, locale, screen size, device pixel ratio, timestamp, exception, stack trace, optional context.

## Diagnostics

`DiagnosticsService` produces a [`DiagnosticsSnapshot`](../../lib/core/quality/diagnostics/diagnostics_snapshot.dart) for:

- Copy Diagnostics
- GitHub issue bodies
- Email reports
- Developer tools export

Future enhancements: logs, screenshots, performance traces.

## Error experience

Never ship Flutter’s default release red screen as the user-facing experience.

Friendly actions (architecture): Restart, Copy Diagnostics, Report Bug, Create GitHub Issue, Contact Maintainer.

After feedback: thank-you message from `FeedbackMessages.thankYou`.
