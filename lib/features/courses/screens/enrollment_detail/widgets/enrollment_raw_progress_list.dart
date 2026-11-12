import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'package:saris_cosmo_center/features/courses/controllers/enrollment_detail_controller.dart';
import 'enrollment_format_utils.dart';

class EnrollmentRawProgressList extends StatelessWidget {
  final Enrollment enrollment;
  final EnrollmentDetailController detailController;

  const EnrollmentRawProgressList({
    super.key,
    required this.enrollment,
    required this.detailController,
  });

  @override
  Widget build(BuildContext context) {
    final lessonProgress = enrollment.lessonProgress;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lesson Progress Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          if (lessonProgress.isEmpty)
            const Text(
              'No lesson progress records found.',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMedium,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessonProgress.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppTheme.divider),
              itemBuilder: (context, index) {
                final progress = lessonProgress[index];

                final status = progress.status.toLowerCase();
                final isCompleted = status == 'completed';
                final isAttended = status == 'attended';

                IconData statusIcon = Icons.circle_outlined;
                Color statusColor = AppTheme.textLight;
                String statusLabel = 'Not Started';

                if (isCompleted) {
                  statusIcon = Icons.check_circle_rounded;
                  statusColor = AppTheme.success;
                  statusLabel = 'Completed';
                } else if (isAttended) {
                  statusIcon = Icons.play_circle_filled_rounded;
                  statusColor = AppTheme.primary;
                  statusLabel = 'Attended';
                }

                return Obx(() {
                  final isUpdating = detailController.isUpdatingProgress.value;
                  return InkWell(
                    onTap: isUpdating
                        ? null
                        : () {
                            final nextStatus =
                                isCompleted ? 'not_started' : 'completed';
                            detailController.updateProgress(
                              enrollment.id,
                              progress.lessonId,
                              nextStatus,
                            );
                          },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lesson ID: #${progress.lessonId}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                if (isCompleted && progress.completedAt != null)
                                  Text(
                                    'Completed on: ${EnrollmentFormatUtils.formatDateTime(progress.completedAt!)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textLight,
                                    ),
                                  )
                                else if (isAttended &&
                                    progress.attendedAt != null)
                                  Text(
                                    'Attended on: ${EnrollmentFormatUtils.formatDateTime(progress.attendedAt!)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
        ],
      ),
    );
  }
}
