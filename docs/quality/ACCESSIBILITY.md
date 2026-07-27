# Accessibility

Accessibility is a **default expectation**, considered during component development—not retrofitted later.

## Requirements

See `AccessibilityRequirements.checklist` in code and:

- Keyboard navigation
- Focus traversal / visible focus
- Semantic labels
- Screen readers
- Large text
- High contrast consideration
- Responsive layouts that remain usable when compact

## Practice

- Prefer Flutter `Semantics`, `FocusTraversalGroup`, and Material a11y affordances.
- Include a11y notes in feature test plans (`TESTING_STRATEGY.md`).
- Treat a11y bugs under the regression policy.
