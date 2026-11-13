import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/features/navigation/widgets/nav_item_widget.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItemWidget(
                index: 0,
                activeIcon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onItemSelected(0),
              ),
              NavItemWidget(
                index: 1,
                activeIcon: Icons.shopping_bag_rounded,
                inactiveIcon: Icons.shopping_bag_outlined,
                label: 'Shop',
                isActive: currentIndex == 1,
                onTap: () => onItemSelected(1),
              ),
              NavItemWidget(
                index: 2,
                activeIcon: Icons.school_rounded,
                inactiveIcon: Icons.school_outlined,
                label: 'Courses',
                isActive: currentIndex == 2,
                onTap: () => onItemSelected(2),
              ),
              NavItemWidget(
                index: 3,
                activeIcon: Icons.calendar_month_rounded,
                inactiveIcon: Icons.calendar_month_outlined,
                label: 'Book',
                isActive: currentIndex == 3,
                onTap: () => onItemSelected(3),
              ),
              NavItemWidget(
                index: 4,
                activeIcon: Icons.person_rounded,
                inactiveIcon: Icons.person_outlined,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => onItemSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

