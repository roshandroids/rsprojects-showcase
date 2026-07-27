/// Branded button variants built on Material 3 + design tokens.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text, tonal }

enum AppButtonSize { small, medium, large }

/// RSProjects button wrapper — consistent sizing and emphasis.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool expand;

  EdgeInsetsGeometry get _padding => switch (size) {
        AppButtonSize.small => const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
        AppButtonSize.medium => const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4,
            vertical: AppSpacing.xs + 4,
          ),
        AppButtonSize.large => const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm - 4,
          ),
      };

  double get _iconSize => switch (size) {
        AppButtonSize.small => 16,
        AppButtonSize.medium => 18,
        AppButtonSize.large => 20,
      };

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: _iconSize),
              const SizedBox(width: AppSpacing.xs),
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: _padding,
            visualDensity: VisualDensity.standard,
          ),
          child: child,
        ),
      AppButtonVariant.tonal => FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: _padding,
            visualDensity: VisualDensity.standard,
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: _padding,
            visualDensity: VisualDensity.standard,
          ),
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: _padding,
            visualDensity: VisualDensity.standard,
          ),
          child: child,
        ),
    };

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
