# Community Feedback

Community feedback is a **first-class capability**, available even when the app has not crashed.

## Channels

| Channel | Role |
|---------|------|
| **GitHub Issues** | Canonical public tracker |
| **Email (`mailto:`)** | Fallback via the user’s default client |

## Categories

- Report Bug
- Suggest Feature
- UI/UX Feedback
- Documentation Feedback
- Performance Feedback
- Accessibility Feedback
- General Feedback

## GitHub

`GitHubIssueBuilder` creates pre-filled `issues/new` URLs with labels:

`bug`, `enhancement`, `documentation`, `performance`, `ui`, `accessibility`, `question`

Diagnostics (and crash reports when applicable) are appended to the issue body.

Issue templates live under `.github/ISSUE_TEMPLATE/` (stubs for contributor UX).

## Email

`EmailReportBuilder` pre-fills subject + body (diagnostics / crash). No backend.

## Code

- `lib/core/quality/feedback/`
- Thank-you copy: `FeedbackMessages.thankYou`
