# Architecture

## Overview

RSProjects Showcase is a Flutter Web portal for discovering RSProjects products.

Layout is **feature-first** with shared core/platform layers.

## Layers

```
lib/
  app/        # bootstrap, router, theme, root widget
  core/       # constants, errors, services, utilities, core widgets
  features/   # home, projects, search, settings, about
  shared/     # cross-feature models, layouts, markdown, animations
  generated/  # Dart codegen output (not the JSON registry)
```

## Features

| Feature | Layers present | Notes |
|---------|----------------|-------|
| `home` | presentation | Landing |
| `projects` | presentation → application → domain → infrastructure | Full stack for catalog |
| `search` | presentation | Expand when needed |
| `settings` | presentation | Expand when needed |
| `about` | presentation | Expand when needed |

## Content & discovery

```
content/projects/<id>/metadata.json  →  scripts/generate_registry.dart  →  generated/registry.json
```

TODO: Document automatic discovery rules and registry consumption in the projects repository.

## State management

TODO: Riverpod (Notifier / AsyncNotifier / AsyncValue) when application layer is implemented.

## Navigation

TODO: Wire `app/router.dart` to feature screens.

## Non-goals (for now)

- No business logic in placeholders
- No guessed UI
- No premature dependencies
