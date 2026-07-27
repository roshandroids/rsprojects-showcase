/// Shared example models and query helpers (supporting project content).
library;

import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';

enum ExampleCategory {
  demo,
  tutorial,
  template,
  sample,
  other;

  static ExampleCategory fromString(String value) {
    return ExampleCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExampleCategory.other,
    );
  }

  String get label => switch (this) {
        ExampleCategory.demo => 'Demo',
        ExampleCategory.tutorial => 'Tutorial',
        ExampleCategory.template => 'Template',
        ExampleCategory.sample => 'Sample',
        ExampleCategory.other => 'Other',
      };
}

/// Documentation link attached to an example.
class ExampleLink {
  const ExampleLink({required this.label, required this.url});

  final String label;
  final String url;
}

/// Immutable example entity associated with exactly one project.
class ProjectExample {
  const ProjectExample({
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

  final String id;
  final String title;
  final String description;
  final String projectId;
  final ExampleCategory category;
  final List<String> tags;
  final bool featured;
  final DemoSpec? demo;
  final List<DemoMediaRef> media;
  final List<ExampleLink> documentationLinks;
  final String? sourceUrl;
  final String? demoUrl;

  /// Resolved demo for presentation (explicit [demo] or derived from fields).
  DemoSpec get resolvedDemo =>
      demo ??
      DemoSpec.fromMetadata(
        media: media,
        demoUrl: demoUrl,
      );
}

/// In-memory filter for registry examples.
class ExampleQuery {
  const ExampleQuery({
    this.projectId,
    this.category,
    this.search = '',
    this.featuredOnly = false,
  });

  final String? projectId;
  final ExampleCategory? category;
  final String search;
  final bool featuredOnly;

  ExampleQuery copyWith({
    String? projectId,
    bool clearProjectId = false,
    ExampleCategory? category,
    bool clearCategory = false,
    String? search,
    bool? featuredOnly,
  }) {
    return ExampleQuery(
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      category: clearCategory ? null : (category ?? this.category),
      search: search ?? this.search,
      featuredOnly: featuredOnly ?? this.featuredOnly,
    );
  }
}

/// Filters examples (typically by [ExampleQuery.projectId]).
List<ProjectExample> applyExampleQuery(
  List<ProjectExample> source,
  ExampleQuery query,
) {
  var result = source.toList();

  if (query.projectId != null) {
    result =
        result.where((e) => e.projectId == query.projectId).toList();
  }
  if (query.category != null) {
    result = result.where((e) => e.category == query.category).toList();
  }
  if (query.featuredOnly) {
    result = result.where((e) => e.featured).toList();
  }

  final q = query.search.trim().toLowerCase();
  if (q.isNotEmpty) {
    result = result.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  result.sort((a, b) {
    if (a.featured != b.featured) {
      return a.featured ? -1 : 1;
    }
    return a.title.compareTo(b.title);
  });

  return result;
}

/// Convenience filter for a single project.
List<ProjectExample> examplesForProject(
  List<ProjectExample> source,
  String projectId,
) {
  return applyExampleQuery(
    source,
    ExampleQuery(projectId: projectId),
  );
}
