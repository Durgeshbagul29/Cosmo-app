import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class LessonHeader extends StatelessWidget {
  final String title;
  final String? classType;
  final int? duration;
  final bool isCompleted;
  final bool isAttended;

  const LessonHeader({
    super.key,
    required this.title,
    this.classType,
    this.duration,
    required this.isCompleted,
    required this.isAttended,
  });

  static String formatClassType(String? type) {
    if (type == null) return 'Class';
    switch (type.toLowerCase()) {
      case 'online_video':
        return 'Online Video';
      case 'offline_class':
        return 'Offline Class';
      case 'practical':
        return 'Practical';
      default:
        return type.replaceAll('_', ' ').capitalizeFirst ?? type;
    }
  }

  static IconData getClassTypeIcon(String? type) {
    if (type == null) return Icons.class_outlined;
    switch (type.toLowerCase()) {
      case 'online_video':
        return Icons.play_circle_outline_rounded;
      case 'offline_class':
        return Icons.school_outlined;
      case 'practical':
        return Icons.science_outlined;
      default:
        return Icons.book_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),

        // Badges / Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getClassTypeIcon(classType),
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatClassType(classType),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (duration != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.textMedium.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppTheme.textMedium,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$duration mins',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.shade50
                    : isAttended
                        ? Colors.blue.shade50
                        : AppTheme.divider.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isCompleted
                    ? 'Completed'
                    : isAttended
                        ? 'Attended'
                        : 'Not Started',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isCompleted
                      ? Colors.green.shade700
                      : isAttended
                          ? Colors.blue.shade700
                          : AppTheme.textMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

