/// Filter / selection chips.
library;

import 'package:flutter/material.dart';
import 'package:rsprojects_showcase/design_system/app_radius.dart';

/// Themed filter chip wrapper (always has a Material ancestor).
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.selected = false,
    this.onSelected,
    this.avatar,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected ?? (selected ? (_) {} : null),
        avatar: avatar,
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderChip),
        side: BorderSide(
          color: selected
              ? Colors.transparent
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
