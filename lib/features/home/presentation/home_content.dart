/// Static home copy (principles / tech / community). Project cards come from registry.
library;

/// Home landing content constants.
abstract final class HomeContent {
  HomeContent._();

  static const String heroHeadline =
      'A public portal for every RSProjects product';
  static const String heroSupport =
      'Discover tools, platforms, and libraries built for clarity, '
      'cross-platform reach, and content-driven delivery.';

  static const String principlesIntro =
      'How we ship products that stay maintainable as the catalog grows.';

  static const List<HomePrinciple> principles = [
    HomePrinciple(
      title: 'Content over hardcoding',
      body:
          'Projects enter the showcase through metadata and a generated '
          'registry — not one-off UI forks.',
    ),
    HomePrinciple(
      title: 'Clean boundaries',
      body:
          'UI talks to application state; domain stays free of Flutter and '
          'DTOs never leak into widgets.',
    ),
    HomePrinciple(
      title: 'Web-first, all platforms',
      body:
          'Primary experience targets the web while keeping Android, iOS, '
          'and desktop runners healthy.',
    ),
    HomePrinciple(
      title: 'Observable quality',
      body:
          'Crash, diagnostics, and feedback hooks are first-class so '
          'production issues stay diagnosable.',
    ),
  ];

  static const String technologiesIntro =
      'Core stack powering the showcase and sibling RSProjects.';

  static const List<String> technologies = [
    'Flutter',
    'Dart',
    'Riverpod',
    'go_router',
    'FlexColorScheme',
    'Content registry',
  ];

  static const String openSourceBody =
      'RSProjects favors transparent development. Source and docs live on '
      'GitHub so contributors can follow the same content model as the portal.';

  static const String openSourceUrl =
      'https://github.com/roshandroids/rsprojects-showcase';

  static const String communityBody =
      'Feedback, issues, and ideas welcome — help shape the catalog and the '
      'products behind it.';

  static const String ctaTitle = 'Ready to explore?';
  static const String ctaBody =
      'Open the projects catalog to filter by status, category, and platform.';
}

/// Single engineering principle card.
class HomePrinciple {
  const HomePrinciple({required this.title, required this.body});

  final String title;
  final String body;
}
