# Content Model

## Project metadata

Each project lives at `content/projects/<id>/metadata.json`.

### Required fields

| Field | Type | Rules |
|-------|------|--------|
| `id` | string | Non-empty; must match folder name |
| `name` | string | Non-empty display name |
| `description` | string | Non-empty long description |
| `version` | string | Non-empty semver-like string |
| `status` | string | One of: `active`, `beta`, `experimental`, `archived` |
| `category` | string | One of: `platform`, `tool`, `library`, `app`, `other` |
| `platforms` | string[] | Non-empty; values from: `web`, `android`, `ios`, `macos`, `windows`, `linux` |
| `featured` | bool | Whether to highlight on Home |

### Optional fields

| Field | Type | Notes |
|-------|------|--------|
| `tagline` | string | Short one-liner (hero) |
| `repositoryUrl` | string | HTTPS URL — hero GitHub action |
| `demoUrl` | string | HTTPS URL — hero Demo action |
| `docsUrl` | string | HTTPS URL — hero Documentation action |
| `tags` | string[] | Free-form tags |
| `icon` | string | Asset path or icon key |
| `showcase` | object | Canonical presentation sections (see below) |

## Showcase framework (`showcase`)

Optional nested object. Every RSProjects product page uses the same template; sections render **only when content is present**. Future automation may populate these from docs and generated metadata.

| Section | Field | Type | Notes |
|---------|-------|------|--------|
| Hero | *(top-level)* | — | `name`, `tagline`, `status`, `platforms`, `demoUrl`, `repositoryUrl`, `docsUrl` |
| Problem Statement | `problem` | string | |
| Solution Overview | `solution` | string | |
| Key Features | `features` | `{title, description}[]` | |
| Interactive Demo | `demo` | `{url?, note?, available?}` | Placeholder when unavailable |
| Screenshots / Gallery | `screenshots` | `{src?, alt, caption?}[]` | `src` optional until assets land |
| Architecture Overview | `architecture` | string | |
| Technologies Used | `technologies` | string[] | |
| Platform Support | `platformSupport` | `{platform, notes?}[]` | Prefer allowed platform ids |
| Installation | `installation` | string | |
| Documentation Links | `documentationLinks` | `{label, url}[]` | Complements `docsUrl` |
| Examples / Playground | `examples` | `{title, description?, url?}[]` | |
| Benchmarks | `benchmarks` | `{label, value, note?}[]` | Optional |
| Roadmap | `roadmap` | `{item, status?}[]` | `status`: `planned` \| `in_progress` \| `done` |
| Changelog | `changelog` | `{version, date?, notes}[]` | |
| Related RSProjects | `relatedProjectIds` | string[] | Registry `id`s |
| Contributing | `contributing` | string | |

See also [`SHOWCASE_FRAMEWORK.md`](SHOWCASE_FRAMEWORK.md).

## Registry output

`generated/registry.json` (produced by `scripts/generate_registry.dart`):

```json
{
  "generatedAt": "ISO-8601",
  "projects": [ /* full metadata objects including showcase */ ]
}
```

## Validation

Run `dart run scripts/validate_content.dart` before generating the registry.

Required catalog fields are always validated. When `showcase` is present, structural types are checked; individual showcase sections remain optional.

## Ownership

Project owners maintain their `content/projects/<id>/` folder. CI regenerates the registry; do not hand-edit `generated/registry.json` for releases.
