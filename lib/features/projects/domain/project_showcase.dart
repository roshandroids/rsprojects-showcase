/// Canonical showcase presentation model for a project page.
library;

/// Nested showcase content (all fields optional; UI renders conditionally).
class ProjectShowcase {
  const ProjectShowcase({
    this.problem,
    this.solution,
    this.features = const [],
    this.demo,
    this.screenshots = const [],
    this.architecture,
    this.technologies = const [],
    this.platformSupport = const [],
    this.installation,
    this.documentationLinks = const [],
    this.examples = const [],
    this.benchmarks = const [],
    this.roadmap = const [],
    this.changelog = const [],
    this.relatedProjectIds = const [],
    this.contributing,
  });

  final String? problem;
  final String? solution;
  final List<ShowcaseFeature> features;
  final ShowcaseDemo? demo;
  final List<ShowcaseScreenshot> screenshots;
  final String? architecture;
  final List<String> technologies;
  final List<ShowcasePlatformSupport> platformSupport;
  final String? installation;
  final List<ShowcaseLink> documentationLinks;
  final List<ShowcaseExample> examples;
  final List<ShowcaseBenchmark> benchmarks;
  final List<ShowcaseRoadmapItem> roadmap;
  final List<ShowcaseChangelogEntry> changelog;
  final List<String> relatedProjectIds;
  final String? contributing;

  bool get hasContent =>
      problem != null ||
      solution != null ||
      features.isNotEmpty ||
      demo != null ||
      screenshots.isNotEmpty ||
      architecture != null ||
      technologies.isNotEmpty ||
      platformSupport.isNotEmpty ||
      installation != null ||
      documentationLinks.isNotEmpty ||
      examples.isNotEmpty ||
      benchmarks.isNotEmpty ||
      roadmap.isNotEmpty ||
      changelog.isNotEmpty ||
      relatedProjectIds.isNotEmpty ||
      contributing != null;
}

class ShowcaseFeature {
  const ShowcaseFeature({required this.title, this.description});

  final String title;
  final String? description;
}

class ShowcaseDemo {
  const ShowcaseDemo({this.url, this.note, this.available = false});

  final String? url;
  final String? note;
  final bool available;
}

class ShowcaseScreenshot {
  const ShowcaseScreenshot({
    required this.alt,
    this.src,
    this.caption,
  });

  final String alt;
  final String? src;
  final String? caption;
}

class ShowcasePlatformSupport {
  const ShowcasePlatformSupport({required this.platform, this.notes});

  final String platform;
  final String? notes;
}

class ShowcaseLink {
  const ShowcaseLink({required this.label, required this.url});

  final String label;
  final String url;
}

class ShowcaseExample {
  const ShowcaseExample({
    required this.title,
    this.description,
    this.url,
  });

  final String title;
  final String? description;
  final String? url;
}

class ShowcaseBenchmark {
  const ShowcaseBenchmark({
    required this.label,
    required this.value,
    this.note,
  });

  final String label;
  final String value;
  final String? note;
}

enum ShowcaseRoadmapStatus {
  planned,
  inProgress,
  done;

  static ShowcaseRoadmapStatus? fromString(String? value) {
    return switch (value) {
      'planned' => ShowcaseRoadmapStatus.planned,
      'in_progress' => ShowcaseRoadmapStatus.inProgress,
      'done' => ShowcaseRoadmapStatus.done,
      _ => null,
    };
  }

  String get label => switch (this) {
        ShowcaseRoadmapStatus.planned => 'planned',
        ShowcaseRoadmapStatus.inProgress => 'in progress',
        ShowcaseRoadmapStatus.done => 'done',
      };
}

class ShowcaseRoadmapItem {
  const ShowcaseRoadmapItem({required this.item, this.status});

  final String item;
  final ShowcaseRoadmapStatus? status;
}

class ShowcaseChangelogEntry {
  const ShowcaseChangelogEntry({
    required this.version,
    required this.notes,
    this.date,
  });

  final String version;
  final String notes;
  final String? date;
}
