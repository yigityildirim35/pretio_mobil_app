import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class EmotionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const EmotionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final is3DEnabled = Provider.of<ThemeProvider>(context).is3DEnabled;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: is3DEnabled
            ? BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              )
            : BoxDecoration(
                color: isSelected ? color : theme.canvasColor,
                borderRadius: BorderRadius.circular(16),
              ),
        child: Column(
          children: [
            Icon(
              icon,
              color: is3DEnabled
                  ? (isSelected ? color : Colors.grey.shade600)
                  : (isSelected ? theme.colorScheme.onPrimary : color),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: is3DEnabled
                    ? (isSelected ? color : Colors.grey.shade600)
                    : (isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
