# Quality Gates (CI Pipeline)

Pull requests should not merge unless required quality gates pass (once implemented).

## Pipeline

```
Format
  ↓
Analyze
  ↓
Unit Tests
  ↓
Widget Tests
  ↓
Golden Tests
  ↓
Integration Tests
  ↓
Content Validation
  ↓
Cross-Platform Build Validation
  ↓
Deployment
```

## Stage notes

| Stage | Command / intent (future) |
|-------|---------------------------|
| Format | `dart format --set-exit-if-changed .` |
| Analyze | `flutter analyze --fatal-infos` |
| Unit / widget | `flutter test` (split tags/folders later) |
| Golden | `flutter test test/golden` (update policy TBD) |
| Integration | `flutter test integration_test` on CI device/web |
| Content | `dart run scripts/validate_content.dart` |
| Cross-platform | Build matrix: web, android, ios, macos, windows, linux (as runners allow) |
| Deployment | `.github/workflows/deploy.yml` after gates on `main` |

## Workflow stub

See `.github/workflows/ci.yml` — architecture documented; full gate implementation is TBD.

## Branch protection (future)

Require CI status checks before merge to `main`.
