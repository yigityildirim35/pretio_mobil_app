import 'package:flutter/material.dart';

/// Returns a BoxDecoration for cards.
/// When [is3D] is true, applies a raised 3D look with border + shadow offset
/// (like the Goals page style). When false, returns a flat card style.
/// Set [showBorder] to false to suppress the border even in 3D mode.
BoxDecoration buildCardDecoration({
  required BuildContext context,
  required bool is3D,
  double borderRadius = 24,
  Color? borderColor,
  Color? shadowColor,
  Color? backgroundColor,
  bool showBorder = true,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  if (is3D) {
    final effectiveBorderColor =
        borderColor ??
        (isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
            : const Color(0xFFF1F5F9));
    final effectiveShadowColor =
        shadowColor ??
        (isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
            : const Color(0xFFE2E8F0));

    return BoxDecoration(
      color: backgroundColor ?? theme.cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: showBorder ? Border.all(color: effectiveBorderColor, width: 2) : null,
      boxShadow: [
        BoxShadow(
          color: effectiveShadowColor,
          offset: const Offset(0, 4),
          blurRadius: 0,
        ),
      ],
    );
  } else {
    return BoxDecoration(
      color: backgroundColor ?? theme.cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
