/// Sealed demo presentation model — never branch UI on product id.
library;

/// Lightweight media reference used by [DemoMediaFallback].
class DemoMediaRef {
  const DemoMediaRef({
    required this.alt,
    this.kind = 'image',
    this.src,
    this.caption,
    this.poster,
  });

  final String kind;
  final String? src;
  final String alt;
  final String? caption;
  final String? poster;
}

/// Generic demo variants driven by metadata.
sealed class DemoSpec {
  const DemoSpec();

  /// Maps example/project demo JSON (+ optional media / demoUrl) to a [DemoSpec].
  factory DemoSpec.fromMetadata({
    Map<String, Object?>? demo,
    List<DemoMediaRef> media = const [],
    String? demoUrl,
  }) {
    if (demo != null && demo['available'] == false) {
      return DemoUnavailable(note: demo['note'] as String?);
    }

    final kind = demo?['kind'] as String?;
    switch (kind) {
      case 'embedded_web':
        final embedUrl = demo?['embedUrl'] as String?;
        if (embedUrl != null && embedUrl.trim().isNotEmpty) {
          return DemoEmbeddedWeb(embedUrl: embedUrl.trim());
        }
      case 'external':
        final url = (demo?['url'] as String?)?.trim();
        if (url != null && url.isNotEmpty) {
          return DemoExternalLink(url: url);
        }
      case 'media':
        final refs = media.isNotEmpty
            ? media
            : _mediaFromDemo(demo);
        if (refs.isNotEmpty) {
          return DemoMediaFallback(media: refs);
        }
    }

    final externalUrl =
        (demo?['url'] as String?)?.trim() ?? demoUrl?.trim();
    if (externalUrl != null && externalUrl.isNotEmpty) {
      return DemoExternalLink(url: externalUrl);
    }

    if (media.isNotEmpty) {
      return DemoMediaFallback(media: media);
    }

    return DemoUnavailable(note: demo?['note'] as String?);
  }
}

List<DemoMediaRef> _mediaFromDemo(Map<String, Object?>? demo) {
  if (demo == null) return const [];
  final raw = demo['media'];
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item is Map)
        DemoMediaRef(
          kind: item['kind'] as String? ?? 'image',
          src: item['src'] as String?,
          alt: item['alt'] as String? ?? 'Media',
          caption: item['caption'] as String?,
          poster: item['poster'] as String?,
        ),
  ];
}

final class DemoEmbeddedWeb extends DemoSpec {
  const DemoEmbeddedWeb({required this.embedUrl});

  final String embedUrl;
}

final class DemoExternalLink extends DemoSpec {
  const DemoExternalLink({required this.url});

  final String url;
}

final class DemoMediaFallback extends DemoSpec {
  const DemoMediaFallback({required this.media});

  final List<DemoMediaRef> media;
}

final class DemoUnavailable extends DemoSpec {
  const DemoUnavailable({this.note});

  final String? note;
}
