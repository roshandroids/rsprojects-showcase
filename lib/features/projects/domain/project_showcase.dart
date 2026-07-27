/// Canonical showcase presentation model for a project page.
library;

/// Nested showcase content (all fields optional; UI renders conditionally).
class ProjectShowcase {
  const ProjectShowcase({
    this.heroMedia,
    this.problem,
    this.solution,
    this.features = const [],
    this.demo,
    this.screenshots = const [],
    this.media = const [],
    this.architecture,
    this.architectureDiagram,
    this.technologies = const [],
    this.platformSupport = const [],
    this.installation,
    this.documentationLinks = const [],
    this.examples = const [],
    this.benchmarks = const [],
    this.roadmap = const [],
    this.changelog = const [],
    this.contributors = const [],
    this.downloads = const [],
    this.relatedProjectIds = const [],
    this.contributing,
  });

  final ShowcaseHeroMedia? heroMedia;
  final String? problem;
  final String? solution;
  final List<ShowcaseFeature> features;
  final ShowcaseDemo? demo;
  final List<ShowcaseScreenshot> screenshots;
  final List<ShowcaseMediaItem> media;
  final String? architecture;
  final ShowcaseMediaItem? architectureDiagram;
  final List<String> technologies;
  final List<ShowcasePlatformSupport> platformSupport;
  final String? installation;
  final List<ShowcaseLink> documentationLinks;
  final List<ShowcaseExample> examples;
  final List<ShowcaseBenchmark> benchmarks;
  final List<ShowcaseRoadmapItem> roadmap;
  final List<ShowcaseChangelogEntry> changelog;
  final List<ShowcaseContributor> contributors;
  final List<ShowcaseDownload> downloads;
  final List<String> relatedProjectIds;
  final String? contributing;

  /// Gallery prefers unified [media]; falls back to legacy [screenshots].
  List<ShowcaseMediaItem> get galleryItems {
    if (media.isNotEmpty) return media;
    return [
      for (final shot in screenshots)
        ShowcaseMediaItem(
          kind: ShowcaseMediaKind.image,
          alt: shot.alt,
          src: shot.src,
          caption: shot.caption,
        ),
    ];
  }

  bool get hasContent =>
      heroMedia != null ||
      problem != null ||
      solution != null ||
      features.isNotEmpty ||
      demo != null ||
      screenshots.isNotEmpty ||
      media.isNotEmpty ||
      architecture != null ||
      architectureDiagram != null ||
      technologies.isNotEmpty ||
      platformSupport.isNotEmpty ||
      installation != null ||
      documentationLinks.isNotEmpty ||
      examples.isNotEmpty ||
      benchmarks.isNotEmpty ||
      roadmap.isNotEmpty ||
      changelog.isNotEmpty ||
      contributors.isNotEmpty ||
      downloads.isNotEmpty ||
      relatedProjectIds.isNotEmpty ||
      contributing != null;
}

enum ShowcaseMediaKind {
  image,
  video,
  diagram;

  static ShowcaseMediaKind fromString(String? value) {
    return switch (value) {
      'video' => ShowcaseMediaKind.video,
      'diagram' => ShowcaseMediaKind.diagram,
      _ => ShowcaseMediaKind.image,
    };
  }
}

enum ShowcaseHeroMediaKind {
  image,
  video,
  lottie;

  static ShowcaseHeroMediaKind fromString(String? value) {
    return switch (value) {
      'video' => ShowcaseHeroMediaKind.video,
      'lottie' => ShowcaseHeroMediaKind.lottie,
      _ => ShowcaseHeroMediaKind.image,
    };
  }
}

class ShowcaseHeroMedia {
  const ShowcaseHeroMedia({
    required this.kind,
    this.src,
    this.alt,
  });

  final ShowcaseHeroMediaKind kind;
  final String? src;
  final String? alt;
}

class ShowcaseMediaItem {
  const ShowcaseMediaItem({
    required this.kind,
    required this.alt,
    this.src,
    this.caption,
    this.poster,
  });

  final ShowcaseMediaKind kind;
  final String alt;
  final String? src;
  final String? caption;
  final String? poster;
}

class ShowcaseFeature {
  const ShowcaseFeature({
    required this.title,
    this.description,
    this.icon,
    this.media,
  });

  final String title;
  final String? description;
  final String? icon;
  final ShowcaseMediaItem? media;
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

class ShowcaseContributor {
  const ShowcaseContributor({
    required this.name,
    this.role,
    this.url,
    this.avatar,
  });

  final String name;
  final String? role;
  final String? url;
  final String? avatar;
}

class ShowcaseDownload {
  const ShowcaseDownload({
    required this.label,
    required this.url,
    this.platform,
    this.checksum,
  });

  final String label;
  final String url;
  final String? platform;
  final String? checksum;
}
