/// Projects domain — entities, enums, repository contract, query helpers.
library;

import 'package:rsprojects_showcase/features/projects/domain/project_showcase.dart';

export 'package:rsprojects_showcase/features/projects/domain/project_showcase.dart';

enum ProjectStatus {
  active,
  beta,
  experimental,
  archived;

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProjectStatus.experimental,
    );
  }
}

enum ProjectCategory {
  platform,
  tool,
  library,
  app,
  other;

  static ProjectCategory fromString(String value) {
    return ProjectCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProjectCategory.other,
    );
  }
}

enum ProjectSort { nameAsc, nameDesc, status, featuredFirst }

/// Immutable project entity (UI-safe).
class Project {
  const Project({
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

  final String id;
  final String name;
  final String description;
  final String version;
  final ProjectStatus status;
  final ProjectCategory category;
  final List<String> platforms;
  final bool featured;
  final String? tagline;
  final String? repositoryUrl;
  final String? demoUrl;
  final String? docsUrl;
  final List<String> tags;
  final String? icon;
  final ProjectShowcase? showcase;
}

/// Catalog query / filter state.
class ProjectQuery {
  const ProjectQuery({
    this.search = '',
    this.status,
    this.category,
    this.platform,
    this.sort = ProjectSort.featuredFirst,
  });

  final String search;
  final ProjectStatus? status;
  final ProjectCategory? category;
  final String? platform;
  final ProjectSort sort;

  ProjectQuery copyWith({
    String? search,
    ProjectStatus? status,
    bool clearStatus = false,
    ProjectCategory? category,
    bool clearCategory = false,
    String? platform,
    bool clearPlatform = false,
    ProjectSort? sort,
  }) {
    return ProjectQuery(
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      category: clearCategory ? null : (category ?? this.category),
      platform: clearPlatform ? null : (platform ?? this.platform),
      sort: sort ?? this.sort,
    );
  }
}

/// Filters and sorts projects in-memory.
List<Project> applyProjectQuery(List<Project> source, ProjectQuery query) {
  var result = source.toList();

  final q = query.search.trim().toLowerCase();
  if (q.isNotEmpty) {
    result = result.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          (p.tagline?.toLowerCase().contains(q) ?? false) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  if (query.status != null) {
    result = result.where((p) => p.status == query.status).toList();
  }
  if (query.category != null) {
    result = result.where((p) => p.category == query.category).toList();
  }
  if (query.platform != null) {
    result = result.where((p) => p.platforms.contains(query.platform)).toList();
  }

  switch (query.sort) {
    case ProjectSort.nameAsc:
      result.sort((a, b) => a.name.compareTo(b.name));
    case ProjectSort.nameDesc:
      result.sort((a, b) => b.name.compareTo(a.name));
    case ProjectSort.status:
      result.sort((a, b) => a.status.name.compareTo(b.status.name));
    case ProjectSort.featuredFirst:
      result.sort((a, b) {
        if (a.featured != b.featured) {
          return a.featured ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
  }

  return result;
}

/// Resolves related projects by id, preserving declared order.
List<Project> resolveRelatedProjects(
  List<Project> catalog,
  List<String> relatedIds,
) {
  final byId = {for (final p in catalog) p.id: p};
  return [
    for (final id in relatedIds)
      if (byId.containsKey(id)) byId[id]!,
  ];
}

/// Repository contract for showcase projects.
abstract interface class ProjectRepository {
  Future<List<Project>> fetchProjects();

  Future<Project?> fetchById(String id);
}
