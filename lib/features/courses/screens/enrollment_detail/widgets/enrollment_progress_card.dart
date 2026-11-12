import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';

class EnrollmentProgressCard extends StatelessWidget {
  final Enrollment enrollment;

  const EnrollmentProgressCard({
    super.key,
    required this.enrollment,
  });

  @override
  Widget build(BuildContext context) {
    final double fraction = enrollment.progressPercent / 100.0;
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enrollment Progress',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 10,
                    backgroundColor: AppTheme.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      fraction >= 0.8 ? AppTheme.success : AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${enrollment.progressPercent.toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            fraction >= 1.0
                ? 'Congratulations! You have completed this course.'
                : 'Keep learning to complete the remaining modules.',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
