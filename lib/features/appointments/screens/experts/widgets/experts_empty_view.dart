import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class ExpertsEmptyView extends StatelessWidget {
  const ExpertsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 64,
            color: AppTheme.textLight.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No experts available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
