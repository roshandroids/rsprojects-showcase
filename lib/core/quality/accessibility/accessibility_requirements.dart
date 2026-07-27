/// Accessibility expectations for RSProjects Showcase components.
///
/// **Why:** A11y is a quality requirement, not a retrofit.
/// **Owner:** Core quality / design system.
/// **When:** Enforce during widget development and reviews.
library;

/// Checklist tokens / guidance used by docs and future lint helpers.
abstract final class AccessibilityRequirements {
  AccessibilityRequirements._();

  static const List<String> checklist = [
    'Keyboard navigation for all interactive controls',
    'Visible focus traversal and focus order',
    'Semantic labels for icons and non-text actions',
    'Screen reader announcements for critical state changes',
    'Support large / scaled text without clipping',
    'Adequate contrast (including high-contrast consideration)',
    'Responsive layouts that remain usable at compact widths',
  ];

  // TODO(quality): Add Semantics / FocusTraversal helpers as shared widgets land.
}
