/// Projects application layer — Riverpod providers and catalog state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/infrastructure/projects_infrastructure.dart';

/// Injectable [ProjectRepository] (override in tests).
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return AssetRegistryProjectRepository();
});

/// Immutable catalog snapshot: all projects + active query.
class ProjectsCatalogState {
  const ProjectsCatalogState({
    required this.all,
    required this.query,
  });

  final List<Project> all;
  final ProjectQuery query;

  List<Project> get filtered => applyProjectQuery(all, query);

  List<Project> get featured =>
      all.where((project) => project.featured).toList(growable: false);

  ProjectsCatalogState copyWith({
    List<Project>? all,
    ProjectQuery? query,
  }) {
    return ProjectsCatalogState(
      all: all ?? this.all,
      query: query ?? this.query,
    );
  }
}

/// Loads registry projects and holds catalog filter/sort state.
class ProjectsCatalogNotifier extends AsyncNotifier<ProjectsCatalogState> {
  @override
  Future<ProjectsCatalogState> build() async {
    final repository = ref.watch(projectRepositoryProvider);
    final projects = await repository.fetchProjects();
    return ProjectsCatalogState(
      all: projects,
      query: const ProjectQuery(),
    );
  }

  Future<void> refresh() async {
    final previous = state.asData?.value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(projectRepositoryProvider);
      final projects = await repository.fetchProjects();
      return ProjectsCatalogState(
        all: projects,
        query: previous?.query ?? const ProjectQuery(),
      );
    });
  }

  void setSearch(String search) {
    _updateQuery((query) => query.copyWith(search: search));
  }

  void setStatus(ProjectStatus? status) {
    _updateQuery(
      (query) => status == null
          ? query.copyWith(clearStatus: true)
          : query.copyWith(status: status),
    );
  }

  void setCategory(ProjectCategory? category) {
    _updateQuery(
      (query) => category == null
          ? query.copyWith(clearCategory: true)
          : query.copyWith(category: category),
    );
  }

  void setPlatform(String? platform) {
    _updateQuery(
      (query) => platform == null
          ? query.copyWith(clearPlatform: true)
          : query.copyWith(platform: platform),
    );
  }

  void setSort(ProjectSort sort) {
    _updateQuery((query) => query.copyWith(sort: sort));
  }

  void clearFilters() {
    _updateQuery(
      (query) => ProjectQuery(search: query.search, sort: query.sort),
    );
  }

  void _updateQuery(ProjectQuery Function(ProjectQuery current) updater) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(query: updater(current.query)),
    );
  }
}

final projectsCatalogProvider =
    AsyncNotifierProvider<ProjectsCatalogNotifier, ProjectsCatalogState>(
  ProjectsCatalogNotifier.new,
  // Asset registry failures are deterministic; surface error UI immediately.
  retry: (retryCount, error) => null,
);

/// Single project by id (metadata-driven detail).
final projectByIdProvider =
    FutureProvider.family<Project?, String>((ref, id) async {
  if (id.isEmpty) return null;
  return ref.watch(projectRepositoryProvider).fetchById(id);
}, retry: (retryCount, error) => null);
