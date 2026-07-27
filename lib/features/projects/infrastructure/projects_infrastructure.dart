/// Projects infrastructure — DTO, mapper, registry repository.
library;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

/// JSON DTO for registry entries (never used in UI).
class ProjectDto {
  const ProjectDto({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.status,
    required this.category,
    required this.platforms,
    required this.featured,
    this.tagline,
    this.repositoryUrl,
    this.demoUrl,
    this.docsUrl,
    this.tags = const [],
    this.icon,
    this.showcase,
  });

  factory ProjectDto.fromJson(Map<String, Object?> json) {
    final showcaseRaw = json['showcase'];
    return ProjectDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      version: json['version'] as String? ?? '',
      status: json['status'] as String? ?? 'experimental',
      category: json['category'] as String? ?? 'other',
      platforms: (json['platforms'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      featured: json['featured'] as bool? ?? false,
      tagline: json['tagline'] as String?,
      repositoryUrl: json['repositoryUrl'] as String?,
      demoUrl: json['demoUrl'] as String?,
      docsUrl: json['docsUrl'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      icon: json['icon'] as String?,
      showcase: showcaseRaw is Map
          ? ProjectShowcaseDto.fromJson(Map<String, Object?>.from(showcaseRaw))
          : null,
    );
  }

  final String id;
  final String name;
  final String description;
  final String version;
  final String status;
  final String category;
  final List<String> platforms;
  final bool featured;
  final String? tagline;
  final String? repositoryUrl;
  final String? demoUrl;
  final String? docsUrl;
  final List<String> tags;
  final String? icon;
  final ProjectShowcaseDto? showcase;

  Project toDomain() {
    return Project(
      id: id,
      name: name,
      description: description,
      version: version,
      status: ProjectStatus.fromString(status),
      category: ProjectCategory.fromString(category),
      platforms: platforms,
      featured: featured,
      tagline: tagline,
      repositoryUrl: repositoryUrl,
      demoUrl: demoUrl,
      docsUrl: docsUrl,
      tags: tags,
      icon: icon,
      showcase: showcase?.toDomain(),
    );
  }
}

/// Showcase DTO (never used in UI).
class ProjectShowcaseDto {
  const ProjectShowcaseDto({
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

  factory ProjectShowcaseDto.fromJson(Map<String, Object?> json) {
    List<Map<String, Object?>> maps(String key) {
      final raw = json[key];
      if (raw is! List) return const [];
      return [
        for (final item in raw)
          if (item is Map) Map<String, Object?>.from(item),
      ];
    }

    Map<String, Object?>? asMap(Object? raw) {
      if (raw is! Map) return null;
      return Map<String, Object?>.from(raw);
    }

    ({String kind, String? src, String? alt, String? caption, String? poster})?
        parseMedia(Object? raw) {
      final m = asMap(raw);
      if (m == null) return null;
      final alt = m['alt'] as String? ?? '';
      return (
        kind: m['kind'] as String? ?? 'image',
        src: m['src'] as String?,
        alt: alt.isEmpty ? null : alt,
        caption: m['caption'] as String?,
        poster: m['poster'] as String?,
      );
    }

    final demoRaw = json['demo'];
    final heroRaw = asMap(json['heroMedia']);
    final architectureDiagramRaw = parseMedia(json['architectureDiagram']);

    return ProjectShowcaseDto(
      heroMedia: heroRaw == null
          ? null
          : (
              kind: heroRaw['kind'] as String? ?? 'image',
              src: heroRaw['src'] as String?,
              alt: heroRaw['alt'] as String?,
            ),
      problem: json['problem'] as String?,
      solution: json['solution'] as String?,
      features: [
        for (final m in maps('features'))
          (
            title: m['title'] as String? ?? '',
            description: m['description'] as String?,
            icon: m['icon'] as String?,
            media: parseMedia(m['media']),
          ),
      ].where((e) => e.title.isNotEmpty).toList(),
      demo: demoRaw is Map
          ? (
              url: demoRaw['url'] as String?,
              note: demoRaw['note'] as String?,
              available: demoRaw['available'] as bool? ?? false,
            )
          : null,
      screenshots: [
        for (final m in maps('screenshots'))
          (
            alt: m['alt'] as String? ?? '',
            src: m['src'] as String?,
            caption: m['caption'] as String?,
          ),
      ].where((e) => e.alt.isNotEmpty).toList(),
      media: [
        for (final m in maps('media'))
          (
            kind: m['kind'] as String? ?? 'image',
            src: m['src'] as String?,
            alt: m['alt'] as String? ?? '',
            caption: m['caption'] as String?,
            poster: m['poster'] as String?,
          ),
      ].where((e) => e.alt.isNotEmpty).toList(),
      architecture: json['architecture'] as String?,
      architectureDiagram: architectureDiagramRaw,
      technologies: (json['technologies'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      platformSupport: [
        for (final m in maps('platformSupport'))
          (
            platform: m['platform'] as String? ?? '',
            notes: m['notes'] as String?,
          ),
      ].where((e) => e.platform.isNotEmpty).toList(),
      installation: json['installation'] as String?,
      documentationLinks: [
        for (final m in maps('documentationLinks'))
          (
            label: m['label'] as String? ?? '',
            url: m['url'] as String? ?? '',
          ),
      ].where((e) => e.label.isNotEmpty && e.url.isNotEmpty).toList(),
      examples: [
        for (final m in maps('examples'))
          (
            title: m['title'] as String? ?? '',
            description: m['description'] as String?,
            url: m['url'] as String?,
          ),
      ].where((e) => e.title.isNotEmpty).toList(),
      benchmarks: [
        for (final m in maps('benchmarks'))
          (
            label: m['label'] as String? ?? '',
            value: m['value'] as String? ?? '',
            note: m['note'] as String?,
          ),
      ].where((e) => e.label.isNotEmpty && e.value.isNotEmpty).toList(),
      roadmap: [
        for (final m in maps('roadmap'))
          (
            item: m['item'] as String? ?? '',
            status: m['status'] as String?,
          ),
      ].where((e) => e.item.isNotEmpty).toList(),
      changelog: [
        for (final m in maps('changelog'))
          (
            version: m['version'] as String? ?? '',
            date: m['date'] as String?,
            notes: m['notes'] as String? ?? '',
          ),
      ].where((e) => e.version.isNotEmpty && e.notes.isNotEmpty).toList(),
      contributors: [
        for (final m in maps('contributors'))
          (
            name: m['name'] as String? ?? '',
            role: m['role'] as String?,
            url: m['url'] as String?,
            avatar: m['avatar'] as String?,
          ),
      ].where((e) => e.name.isNotEmpty).toList(),
      downloads: [
        for (final m in maps('downloads'))
          (
            label: m['label'] as String? ?? '',
            url: m['url'] as String? ?? '',
            platform: m['platform'] as String?,
            checksum: m['checksum'] as String?,
          ),
      ].where((e) => e.label.isNotEmpty && e.url.isNotEmpty).toList(),
      relatedProjectIds:
          (json['relatedProjectIds'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
      contributing: json['contributing'] as String?,
    );
  }

  final ({String kind, String? src, String? alt})? heroMedia;
  final String? problem;
  final String? solution;
  final List<
      ({
        String title,
        String? description,
        String? icon,
        ({
          String kind,
          String? src,
          String? alt,
          String? caption,
          String? poster,
        })? media,
      })> features;
  final ({String? url, String? note, bool available})? demo;
  final List<({String alt, String? src, String? caption})> screenshots;
  final List<
      ({
        String kind,
        String? src,
        String alt,
        String? caption,
        String? poster,
      })> media;
  final String? architecture;
  final ({
    String kind,
    String? src,
    String? alt,
    String? caption,
    String? poster,
  })? architectureDiagram;
  final List<String> technologies;
  final List<({String platform, String? notes})> platformSupport;
  final String? installation;
  final List<({String label, String url})> documentationLinks;
  final List<({String title, String? description, String? url})> examples;
  final List<({String label, String value, String? note})> benchmarks;
  final List<({String item, String? status})> roadmap;
  final List<({String version, String? date, String notes})> changelog;
  final List<({String name, String? role, String? url, String? avatar})>
      contributors;
  final List<({String label, String url, String? platform, String? checksum})>
      downloads;
  final List<String> relatedProjectIds;
  final String? contributing;

  static ShowcaseMediaItem? _mediaToDomain(
    ({
      String kind,
      String? src,
      String? alt,
      String? caption,
      String? poster,
    })? raw, {
    String fallbackAlt = '',
  }) {
    if (raw == null) return null;
    final alt = (raw.alt ?? '').trim().isEmpty ? fallbackAlt : raw.alt!;
    if (alt.isEmpty && raw.src == null) return null;
    return ShowcaseMediaItem(
      kind: ShowcaseMediaKind.fromString(raw.kind),
      alt: alt.isEmpty ? 'Media' : alt,
      src: raw.src,
      caption: raw.caption,
      poster: raw.poster,
    );
  }

  ProjectShowcase toDomain() {
    return ProjectShowcase(
      heroMedia: heroMedia == null
          ? null
          : ShowcaseHeroMedia(
              kind: ShowcaseHeroMediaKind.fromString(heroMedia!.kind),
              src: heroMedia!.src,
              alt: heroMedia!.alt,
            ),
      problem: problem,
      solution: solution,
      features: [
        for (final f in features)
          ShowcaseFeature(
            title: f.title,
            description: f.description,
            icon: f.icon,
            media: _mediaToDomain(f.media, fallbackAlt: f.title),
          ),
      ],
      demo: demo == null
          ? null
          : ShowcaseDemo(
              url: demo!.url,
              note: demo!.note,
              available: demo!.available,
            ),
      screenshots: [
        for (final s in screenshots)
          ShowcaseScreenshot(alt: s.alt, src: s.src, caption: s.caption),
      ],
      media: [
        for (final m in media)
          ShowcaseMediaItem(
            kind: ShowcaseMediaKind.fromString(m.kind),
            alt: m.alt,
            src: m.src,
            caption: m.caption,
            poster: m.poster,
          ),
      ],
      architecture: architecture,
      architectureDiagram: _mediaToDomain(
        architectureDiagram,
        fallbackAlt: 'Architecture diagram',
      ),
      technologies: technologies,
      platformSupport: [
        for (final p in platformSupport)
          ShowcasePlatformSupport(platform: p.platform, notes: p.notes),
      ],
      installation: installation,
      documentationLinks: [
        for (final l in documentationLinks)
          ShowcaseLink(label: l.label, url: l.url),
      ],
      examples: [
        for (final e in examples)
          ShowcaseExample(
            title: e.title,
            description: e.description,
            url: e.url,
          ),
      ],
      benchmarks: [
        for (final b in benchmarks)
          ShowcaseBenchmark(label: b.label, value: b.value, note: b.note),
      ],
      roadmap: [
        for (final r in roadmap)
          ShowcaseRoadmapItem(
            item: r.item,
            status: ShowcaseRoadmapStatus.fromString(r.status),
          ),
      ],
      changelog: [
        for (final c in changelog)
          ShowcaseChangelogEntry(
            version: c.version,
            date: c.date,
            notes: c.notes,
          ),
      ],
      contributors: [
        for (final c in contributors)
          ShowcaseContributor(
            name: c.name,
            role: c.role,
            url: c.url,
            avatar: c.avatar,
          ),
      ],
      downloads: [
        for (final d in downloads)
          ShowcaseDownload(
            label: d.label,
            url: d.url,
            platform: d.platform,
            checksum: d.checksum,
          ),
      ],
      relatedProjectIds: relatedProjectIds,
      contributing: contributing,
    );
  }
}

/// JSON DTO for registry example entries (never used in UI).
class ProjectExampleDto {
  const ProjectExampleDto({
    required this.id,
    required this.title,
    required this.description,
    required this.projectId,
    required this.category,
    this.tags = const [],
    this.featured = false,
    this.demo,
    this.media = const [],
    this.documentationLinks = const [],
    this.sourceUrl,
    this.demoUrl,
  });

  factory ProjectExampleDto.fromJson(Map<String, Object?> json) {
    List<Map<String, Object?>> maps(String key) {
      final raw = json[key];
      if (raw is! List) return const [];
      return [
        for (final item in raw)
          if (item is Map) Map<String, Object?>.from(item),
      ];
    }

    final demoRaw = json['demo'];
    return ProjectExampleDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      projectId: json['projectId'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      featured: json['featured'] as bool? ?? false,
      demo: demoRaw is Map ? Map<String, Object?>.from(demoRaw) : null,
      media: [
        for (final m in maps('media'))
          (
            kind: m['kind'] as String? ?? 'image',
            src: m['src'] as String?,
            alt: m['alt'] as String? ?? '',
            caption: m['caption'] as String?,
            poster: m['poster'] as String?,
          ),
      ].where((e) => e.alt.isNotEmpty).toList(),
      documentationLinks: [
        for (final m in maps('documentationLinks'))
          (
            label: m['label'] as String? ?? '',
            url: m['url'] as String? ?? '',
          ),
      ].where((e) => e.label.isNotEmpty && e.url.isNotEmpty).toList(),
      sourceUrl: json['sourceUrl'] as String?,
      demoUrl: json['demoUrl'] as String?,
    );
  }

  final String id;
  final String title;
  final String description;
  final String projectId;
  final String category;
  final List<String> tags;
  final bool featured;
  final Map<String, Object?>? demo;
  final List<
      ({
        String kind,
        String? src,
        String alt,
        String? caption,
        String? poster,
      })> media;
  final List<({String label, String url})> documentationLinks;
  final String? sourceUrl;
  final String? demoUrl;

  ProjectExample toDomain() {
    final mediaRefs = [
      for (final m in media)
        DemoMediaRef(
          kind: m.kind,
          src: m.src,
          alt: m.alt,
          caption: m.caption,
          poster: m.poster,
        ),
    ];
    return ProjectExample(
      id: id,
      title: title,
      description: description,
      projectId: projectId,
      category: ExampleCategory.fromString(category),
      tags: tags,
      featured: featured,
      demo: DemoSpec.fromMetadata(
        demo: demo,
        media: mediaRefs,
        demoUrl: demoUrl,
      ),
      media: mediaRefs,
      documentationLinks: [
        for (final l in documentationLinks)
          ExampleLink(label: l.label, url: l.url),
      ],
      sourceUrl: sourceUrl,
      demoUrl: demoUrl,
    );
  }
}

/// Loads projects (and supporting examples) from the bundled registry.
class AssetRegistryProjectRepository implements ProjectRepository {
  AssetRegistryProjectRepository({
    this.assetPath = AppConstants.registryAssetPath,
    AssetBundle? bundle,
  }) : _bundle = bundle ?? rootBundle;

  final String assetPath;
  final AssetBundle _bundle;

  List<Project>? _projectCache;
  List<ProjectExample>? _exampleCache;

  Future<void> _ensureLoaded() async {
    if (_projectCache != null && _exampleCache != null) return;

    final raw = await _bundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Registry root must be a JSON object');
    }

    final projectList = decoded['projects'];
    if (projectList is! List) {
      throw const FormatException('Registry "projects" must be a list');
    }

    final projects = <Project>[];
    for (final item in projectList) {
      if (item is Map) {
        projects.add(
          ProjectDto.fromJson(Map<String, Object?>.from(item)).toDomain(),
        );
      }
    }

    final examples = <ProjectExample>[];
    final exampleList = decoded['examples'];
    if (exampleList is List) {
      for (final item in exampleList) {
        if (item is Map) {
          examples.add(
            ProjectExampleDto.fromJson(Map<String, Object?>.from(item))
                .toDomain(),
          );
        }
      }
    }

    _projectCache = projects;
    _exampleCache = examples;
  }

  @override
  Future<List<Project>> fetchProjects() async {
    await _ensureLoaded();
    return _projectCache!;
  }

  /// Supporting examples slice from the same registry asset.
  Future<List<ProjectExample>> fetchExamples() async {
    await _ensureLoaded();
    return _exampleCache!;
  }

  @override
  Future<Project?> fetchById(String id) async {
    final all = await fetchProjects();
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
