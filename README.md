# RSProjects Showcase

Public portal **and static host** for RSProjects products.

Private product source stays in private repos. This repository ships the showcase Flutter app plus generated Flutter Web playgrounds under `generated/<project-id>/`.

## Status

See [PROJECT_STATUS.md](PROJECT_STATUS.md). Playground hosting contract: [docs/PLAYGROUNDS.md](docs/PLAYGROUNDS.md).

## Quick start

See [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md).

```sh
flutter pub get
dart run scripts/validate_content.dart
dart run scripts/generate_registry.dart
flutter run -d chrome
```

## Documentation

| Doc | Description |
|-----|-------------|
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | **Canonical status** — share for planning / reviews |
| [ARCHITECTURE.md](ARCHITECTURE.md) | High-level architecture |
| [docs/PLAYGROUNDS.md](docs/PLAYGROUNDS.md) | Generated playground hosting; platform-ci is the sole publisher |
| [PROJECT_RULES.md](PROJECT_RULES.md) | Contribution / engineering rules |
| [ROADMAP.md](ROADMAP.md) | Planned milestones |
| [docs/](docs/README.md) | Detailed docs |

## License

TODO: See [LICENSE](LICENSE).
