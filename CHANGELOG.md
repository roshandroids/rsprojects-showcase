# Changelog

All notable changes to RSProjects Showcase will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added

- Architecture bootstrap (folders, placeholders, docs templates)
- Playground hosting pipeline: `generated/<id>/` static Flutter Web builds published by `platform-ci`, deployed to GitHub Pages alongside the showcase app (`.github/workflows/deploy.yml`, `.github/workflows/receive-playground.yml`)
- `playground` field on project content metadata (`enabled`, `id`, `demoPath`); `status`/`version`/`commit`/`deployedAt` computed by `scripts/generate_registry.dart` from `generated/<id>/` presence, never authored — see [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md)
- "Open playground" / "Playground pending" action on the project page, driven entirely by registry `playground` metadata (no project-id branching)

### Fixed

- Resolved a contract mismatch where an external CI system (`platform-ci`) assumed this repo discovered playgrounds by scanning `generated/` at runtime and used a nonexistent repo name (`project_showcase`). Locked the correct architecture (registry references a playground by id; hosting and catalog are separate pipelines) in `docs/DEPLOYMENT.md`.

## [0.0.0] - TBD

TODO: First tagged release notes.
