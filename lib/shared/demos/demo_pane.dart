/// Generic demo pane — renders any [DemoSpec] without product-specific UI.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';

/// Maps [DemoSpec] variants to shared UI.
class DemoPane extends StatelessWidget {
  const DemoPane({
    required this.spec,
    super.key,
    this.title,
  });

  final DemoSpec spec;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return switch (spec) {
      DemoEmbeddedWeb(:final embedUrl) => _EmbeddedWebPane(
          embedUrl: embedUrl,
          title: title,
        ),
      DemoExternalLink(:final url) => _ExternalLinkPane(
          url: url,
          title: title,
        ),
      DemoMediaFallback(:final media) => _MediaFallbackPane(
          media: media,
          title: title,
        ),
      DemoUnavailable(:final note) => _UnavailablePane(
          note: note,
          title: title,
        ),
    };
  }
}

class _PaneShell extends StatelessWidget {
  const _PaneShell({
    required this.icon,
    required this.headline,
    required this.child,
    this.title,
  });

  final IconData icon;
  final String headline;
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
          ],
          Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(headline, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _EmbeddedWebPane extends StatelessWidget {
  const _EmbeddedWebPane({required this.embedUrl, this.title});

  final String embedUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _PaneShell(
      title: title,
      icon: Icons.web_rounded,
      headline: 'Embedded web demo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interactive embed is available on web hosts. '
            'Use the link below on other platforms.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Center(
                child: Text(
                  'Embed placeholder',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableText(
            embedUrl,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _ExternalLinkPane extends StatelessWidget {
  const _ExternalLinkPane({required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _PaneShell(
      title: title,
      icon: Icons.open_in_new_rounded,
      headline: 'Open demo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Launch the live demo in a new context.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectableText(
            url,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _MediaFallbackPane extends StatelessWidget {
  const _MediaFallbackPane({required this.media, this.title});

  final List<DemoMediaRef> media;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _PaneShell(
      title: title,
      icon: Icons.slideshow_rounded,
      headline: 'Demo preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Interactive demo is represented by media until a live host is available.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in media) ...[
            AppCard(
              elevated: false,
              clipChild: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ColoredBox(
                      color: scheme.surfaceContainerHighest,
                      child: item.src != null && item.src!.isNotEmpty
                          ? Image.asset(
                              item.src!,
                              fit: BoxFit.cover,
                              semanticLabel: item.alt,
                              errorBuilder: (_, _, _) => Center(
                                child: Text(item.alt),
                              ),
                            )
                          : Center(child: Text(item.alt)),
                    ),
                  ),
                  if (item.caption != null)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        item.caption!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _UnavailablePane extends StatelessWidget {
  const _UnavailablePane({this.note, this.title});

  final String? note;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _PaneShell(
      title: title,
      icon: Icons.hourglass_empty_rounded,
      headline: 'Demo placeholder',
      child: Text(
        note ?? 'Interactive demo is not available yet.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withValues(alpha: 0.72),
        ),
      ),
    );
  }
}
