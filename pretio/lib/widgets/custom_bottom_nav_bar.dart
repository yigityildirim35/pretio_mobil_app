import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 12, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.dashboard,
            label: AppLocalizations.of(context)!.dashboard,
            isActive: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          NavBarItem(
            icon: Icons.bar_chart,
            label: AppLocalizations.of(context)!.analytics,
            isActive: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          NavBarItem(
            icon: Icons.flag,
            label: AppLocalizations.of(context)?.goals ?? 'Hedefler',
            isActive: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          NavBarItem(
            icon: Icons.lightbulb,
            label: AppLocalizations.of(context)!.shadowBudget,
            isActive: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          NavBarItem(
            icon: Icons.person,
            label: AppLocalizations.of(context)!.profile,
            isActive: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? theme.colorScheme.primary : inactiveColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
