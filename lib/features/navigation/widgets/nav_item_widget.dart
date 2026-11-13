import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class NavItemWidget extends StatelessWidget {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItemWidget({
    super.key,
    required this.index,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppTheme.primary : AppTheme.textLight,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppTheme.primary : AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

