/// Surface card used across catalog and home — Material 3, hover-aware.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_elevation.dart';
import 'package:rsprojects_showcase/design_system/app_motion.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

/// Themed card with optional tap handler and web hover elevation.
class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.elevated = false,
    this.clipChild = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool elevated;

  /// When true, padding is omitted so media can bleed to the card edges.
  final bool clipChild;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final interactive = widget.onTap != null;
    final raised = widget.elevated || (_hovered && interactive) || _focused;
    final borderColor = (_hovered || _focused) && interactive
        ? scheme.outline.withValues(alpha: 0.55)
        : scheme.outlineVariant.withValues(alpha: 0.7);

    final content = widget.clipChild
        ? widget.child
        : Padding(
            padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: widget.child,
          );

    return MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      child: FocusableActionDetector(
        onShowFocusHighlight: (focused) {
          if (interactive) setState(() => _focused = focused);
        },
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderCard,
            boxShadow: raised ? AppElevation.softShadow(scheme) : null,
          ),
          child: Material(
            color: raised
                ? scheme.surfaceContainerHigh
                : scheme.surfaceContainerLow,
            surfaceTintColor: scheme.surfaceTint,
            elevation: raised ? AppElevation.level2 : AppElevation.level0,
            shadowColor: scheme.shadow.withValues(alpha: 0.18),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderCard,
              side: BorderSide(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: interactive
                ? InkWell(
                    onTap: widget.onTap,
                    borderRadius: AppRadius.borderCard,
                    child: content,
                  )
                : content,
          ),
        ),
      ),
    );
  }
}
