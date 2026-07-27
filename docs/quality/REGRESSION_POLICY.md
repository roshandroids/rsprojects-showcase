# Regression Testing Policy

> **No bug is considered fixed until a regression test prevents it from returning.**

## Required for every bug fix

1. **Documentation** — short note of root cause and fix (issue comment and/or PR description).
2. **Regression test** — automated test that fails before the fix and passes after (prefer `test/regression/` or the nearest unit/widget suite).
3. **Changelog entry** — when CHANGELOG discipline is active for the release train.

## Rules

- Reproduce the bug with a test first when practical.
- Name or comment the test with the issue id (e.g. `#42` or `GITHUB-42`).
- Do not close the issue until the regression test is merged.
- Flaky tests are not acceptable substitutes; quarantine or fix flakes.

## Permanent engineering rule

This policy is project-wide and applies to all contributors and agents. See also `PROJECT_RULES.md`.
