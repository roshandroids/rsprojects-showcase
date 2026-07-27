/// Surface card used across catalog and home — Material 3 tonal, hover-aware.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_elevation.dart';
import 'package:rsprojects_showcase/design_system/app_motion.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

/// Themed card with optional tap handler and subtle web hover lift.
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

    final content = widget.clipChild
        ? widget.child
        : Padding(
            padding: widget.padding ?? const EdgeInsets.all(AppSpacing.sm),
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
            boxShadow: raised ? AppElevation.hoverShadow(scheme) : null,
          ),
          transform: raised
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Material(
            color: raised
                ? scheme.surfaceContainerHigh
                : scheme.surfaceContainerLow,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderCard,
              side: BorderSide(
                color: raised
                    ? scheme.outlineVariant.withValues(alpha: 0.9)
                    : scheme.outlineVariant.withValues(alpha: 0.55),
              ),
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
