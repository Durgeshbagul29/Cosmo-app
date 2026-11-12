import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class ReviewsEmptyState extends StatelessWidget {
  const ReviewsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 48,
            color: AppTheme.textLight.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'No reviews yet for this service.',
            style: TextStyle(
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Be the first to share your experience!',
            style: TextStyle(color: AppTheme.textLight, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
