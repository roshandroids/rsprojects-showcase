/// Shared content schema validation for project metadata.
///
/// Used by `scripts/validate_content.dart` and unit tests.
library;

const Set<String> kAllowedStatuses = {
  'active',
  'beta',
  'experimental',
  'archived',
};

const Set<String> kAllowedCategories = {
  'platform',
  'tool',
  'library',
  'app',
  'other',
};

const Set<String> kAllowedPlatforms = {
  'web',
  'android',
  'ios',
  'macos',
  'windows',
  'linux',
};

const Set<String> kAllowedRoadmapStatuses = {
  'planned',
  'in_progress',
  'done',
};

const Set<String> kAllowedMediaKinds = {
  'image',
  'video',
  'diagram',
};

const Set<String> kAllowedHeroMediaKinds = {
  'image',
  'video',
  'lottie',
};

/// Validates a decoded metadata map. Returns human-readable error messages.
List<String> validateProjectMetadata(
  Map<String, Object?> data, {
  String? expectedId,
}) {
  final errors = <String>[];

  String? requireString(String key) {
    final value = data[key];
    if (value is! String || value.trim().isEmpty) {
      errors.add('Missing or empty required string field "$key"');
      return null;
    }
    return value.trim();
  }

  final id = requireString('id');
  requireString('name');
  requireString('description');
  requireString('version');

  final status = requireString('status');
  if (status != null && !kAllowedStatuses.contains(status)) {
    errors.add('Invalid status "$status". Allowed: $kAllowedStatuses');
  }

  final category = requireString('category');
  if (category != null && !kAllowedCategories.contains(category)) {
    errors.add('Invalid category "$category". Allowed: $kAllowedCategories');
  }

  final platforms = data['platforms'];
  if (platforms is! List || platforms.isEmpty) {
    errors.add('Field "platforms" must be a non-empty list');
  } else {
    for (final p in platforms) {
      if (p is! String || !kAllowedPlatforms.contains(p)) {
        errors.add('Invalid platform "$p". Allowed: $kAllowedPlatforms');
      }
    }
  }

  if (data['featured'] is! bool) {
    errors.add('Field "featured" must be a boolean');
  }

  if (expectedId != null && id != null && id != expectedId) {
    errors.add('Metadata id "$id" does not match folder "$expectedId"');
  }

  final showcase = data['showcase'];
  if (showcase != null) {
    if (showcase is! Map) {
      errors.add('Field "showcase" must be an object when present');
    } else {
      errors.addAll(
        validateShowcaseMetadata(
          showcase.map((k, v) => MapEntry(k.toString(), v as Object?)),
        ),
      );
    }
  }

  return errors;
}

/// Validates optional showcase section shapes (all sections remain optional).
List<String> validateShowcaseMetadata(Map<String, Object?> data) {
  final errors = <String>[];

  void optionalString(String key) {
    final value = data[key];
    if (value == null) return;
    if (value is! String || value.trim().isEmpty) {
      errors.add('showcase.$key must be a non-empty string when present');
    }
  }

  optionalString('problem');
  optionalString('solution');
  optionalString('architecture');
  optionalString('installation');
  optionalString('contributing');

  final features = data['features'];
  if (features != null) {
    if (features is! List) {
      errors.add('showcase.features must be a list');
    } else {
      for (var i = 0; i < features.length; i++) {
        final item = features[i];
        if (item is! Map ||
            item['title'] is! String ||
            (item['title'] as String).trim().isEmpty) {
          errors.add('showcase.features[$i] requires non-empty "title"');
          continue;
        }
        final featureMedia = item['media'];
        if (featureMedia != null) {
          if (featureMedia is! Map) {
            errors.add('showcase.features[$i].media must be an object');
          } else {
            final kind = featureMedia['kind'];
            if (kind != null &&
                (kind is! String || !kAllowedMediaKinds.contains(kind))) {
              errors.add(
                'showcase.features[$i].media.kind invalid. '
                'Allowed: $kAllowedMediaKinds',
              );
            }
          }
        }
      }
    }
  }

  final demo = data['demo'];
  if (demo != null && demo is! Map) {
    errors.add('showcase.demo must be an object when present');
  }

  final screenshots = data['screenshots'];
  if (screenshots != null) {
    if (screenshots is! List) {
      errors.add('showcase.screenshots must be a list');
    } else {
      for (var i = 0; i < screenshots.length; i++) {
        final item = screenshots[i];
        if (item is! Map ||
            item['alt'] is! String ||
            (item['alt'] as String).trim().isEmpty) {
          errors.add('showcase.screenshots[$i] requires non-empty "alt"');
        }
      }
    }
  }

  final technologies = data['technologies'];
  if (technologies != null && technologies is! List) {
    errors.add('showcase.technologies must be a list');
  }

  final platformSupport = data['platformSupport'];
  if (platformSupport != null) {
    if (platformSupport is! List) {
      errors.add('showcase.platformSupport must be a list');
    } else {
      for (var i = 0; i < platformSupport.length; i++) {
        final item = platformSupport[i];
        if (item is! Map || item['platform'] is! String) {
          errors.add('showcase.platformSupport[$i] requires "platform"');
          continue;
        }
        final platform = item['platform'] as String;
        if (!kAllowedPlatforms.contains(platform)) {
          errors.add(
            'showcase.platformSupport[$i] invalid platform "$platform"',
          );
        }
      }
    }
  }

  final documentationLinks = data['documentationLinks'];
  if (documentationLinks != null) {
    if (documentationLinks is! List) {
      errors.add('showcase.documentationLinks must be a list');
    } else {
      for (var i = 0; i < documentationLinks.length; i++) {
        final item = documentationLinks[i];
        if (item is! Map ||
            item['label'] is! String ||
            item['url'] is! String) {
          errors.add(
            'showcase.documentationLinks[$i] requires "label" and "url"',
          );
        }
      }
    }
  }

  final examples = data['examples'];
  if (examples != null) {
    if (examples is! List) {
      errors.add('showcase.examples must be a list');
    } else {
      for (var i = 0; i < examples.length; i++) {
        final item = examples[i];
        if (item is! Map ||
            item['title'] is! String ||
            (item['title'] as String).trim().isEmpty) {
          errors.add('showcase.examples[$i] requires non-empty "title"');
        }
      }
    }
  }

  final benchmarks = data['benchmarks'];
  if (benchmarks != null) {
    if (benchmarks is! List) {
      errors.add('showcase.benchmarks must be a list');
    } else {
      for (var i = 0; i < benchmarks.length; i++) {
        final item = benchmarks[i];
        if (item is! Map ||
            item['label'] is! String ||
            item['value'] is! String) {
          errors.add('showcase.benchmarks[$i] requires "label" and "value"');
        }
      }
    }
  }

  final roadmap = data['roadmap'];
  if (roadmap != null) {
    if (roadmap is! List) {
      errors.add('showcase.roadmap must be a list');
    } else {
      for (var i = 0; i < roadmap.length; i++) {
        final item = roadmap[i];
        if (item is! Map || item['item'] is! String) {
          errors.add('showcase.roadmap[$i] requires "item"');
          continue;
        }
        final status = item['status'];
        if (status != null &&
            (status is! String || !kAllowedRoadmapStatuses.contains(status))) {
          errors.add(
            'showcase.roadmap[$i] invalid status. Allowed: $kAllowedRoadmapStatuses',
          );
        }
      }
    }
  }

  final changelog = data['changelog'];
  if (changelog != null) {
    if (changelog is! List) {
      errors.add('showcase.changelog must be a list');
    } else {
      for (var i = 0; i < changelog.length; i++) {
        final item = changelog[i];
        if (item is! Map ||
            item['version'] is! String ||
            item['notes'] is! String) {
          errors.add('showcase.changelog[$i] requires "version" and "notes"');
        }
      }
    }
  }

  final related = data['relatedProjectIds'];
  if (related != null && related is! List) {
    errors.add('showcase.relatedProjectIds must be a list');
  }

  void validateMediaObject(String path, Object? raw, {required bool requireAlt}) {
    if (raw == null) return;
    if (raw is! Map) {
      errors.add('$path must be an object');
      return;
    }
    final kind = raw['kind'];
    if (kind != null &&
        (kind is! String || !kAllowedMediaKinds.contains(kind))) {
      errors.add('$path.kind invalid. Allowed: $kAllowedMediaKinds');
    }
    if (requireAlt) {
      final alt = raw['alt'];
      if (alt is! String || alt.trim().isEmpty) {
        errors.add('$path requires non-empty "alt"');
      }
    }
  }

  final heroMedia = data['heroMedia'];
  if (heroMedia != null) {
    if (heroMedia is! Map) {
      errors.add('showcase.heroMedia must be an object');
    } else {
      final kind = heroMedia['kind'];
      if (kind != null &&
          (kind is! String || !kAllowedHeroMediaKinds.contains(kind))) {
        errors.add(
          'showcase.heroMedia.kind invalid. Allowed: $kAllowedHeroMediaKinds',
        );
      }
    }
  }

  final media = data['media'];
  if (media != null) {
    if (media is! List) {
      errors.add('showcase.media must be a list');
    } else {
      for (var i = 0; i < media.length; i++) {
        validateMediaObject('showcase.media[$i]', media[i], requireAlt: true);
      }
    }
  }

  validateMediaObject(
    'showcase.architectureDiagram',
    data['architectureDiagram'],
    requireAlt: false,
  );

  final contributors = data['contributors'];
  if (contributors != null) {
    if (contributors is! List) {
      errors.add('showcase.contributors must be a list');
    } else {
      for (var i = 0; i < contributors.length; i++) {
        final item = contributors[i];
        if (item is! Map ||
            item['name'] is! String ||
            (item['name'] as String).trim().isEmpty) {
          errors.add('showcase.contributors[$i] requires non-empty "name"');
        }
      }
    }
  }

  final downloads = data['downloads'];
  if (downloads != null) {
    if (downloads is! List) {
      errors.add('showcase.downloads must be a list');
    } else {
      for (var i = 0; i < downloads.length; i++) {
        final item = downloads[i];
        if (item is! Map ||
            item['label'] is! String ||
            item['url'] is! String) {
          errors.add('showcase.downloads[$i] requires "label" and "url"');
        }
      }
    }
  }

  return errors;
}
