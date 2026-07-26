/// Projects infrastructure layer (DTOs, mappers, repository implementations).
///
/// **Why:** Loads registry / content and maps DTOs → domain entities.
/// **Owner:** Projects feature team.
/// **When:** Implement after `generated/registry.json` and content schema exist.
library;

/// Placeholder for projects infrastructure.
///
/// TODO(projects):
/// - ProjectDto + mapper
/// - RegistryProjectRepository reading generated registry
/// - Never expose DTOs to presentation
abstract final class ProjectsInfrastructure {
  ProjectsInfrastructure._();
}
