import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class AppointmentsEmptyView extends StatelessWidget {
  const AppointmentsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.spa_outlined,
                  size: 64,
                  color: AppTheme.textLight.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No services found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try adjusting your filters.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
