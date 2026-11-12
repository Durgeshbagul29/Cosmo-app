import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'package:saris_cosmo_center/features/courses/controllers/enrollment_detail_controller.dart';

class LessonBottomActionBar extends StatelessWidget {
  final int lessonId;
  final Enrollment enrollment;
  final LessonProgress? progress;
  final EnrollmentDetailController detailController;
  final VoidCallback? onClose;

  const LessonBottomActionBar({
    super.key,
    required this.lessonId,
    required this.enrollment,
    this.progress,
    required this.detailController,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.divider),
        ),
      ),
      child: Obx(() {
        final isUpdating = detailController.isUpdatingProgress.value;
        final hasProgress = detailController.enrollment.value?.lessonProgress
            .firstWhereOrNull((p) => p.lessonId == lessonId);
        final status = (hasProgress?.status ?? progress?.status ?? 'not_started').toLowerCase();
        final isCompleted = status == 'completed';
        final nextStatus = isCompleted ? 'not_started' : 'completed';

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isUpdating ? null : (onClose ?? () => Navigator.pop(context)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textMedium,
                  side: const BorderSide(color: AppTheme.divider),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isUpdating
                    ? null
                    : () async {
                        await detailController.updateProgress(
                          enrollment.id,
                          lessonId,
                          nextStatus,
                        );
                      },
                icon: isUpdating
                    ? const SizedBox.shrink()
                    : Icon(
                        isCompleted ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                        size: 18,
                      ),
                label: isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? AppTheme.primary : AppTheme.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

