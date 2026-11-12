import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'enrollment_format_utils.dart';

class EnrollmentCourseHeader extends StatelessWidget {
  final Enrollment enrollment;

  const EnrollmentCourseHeader({
    super.key,
    required this.enrollment,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = enrollment.paymentStatus.toLowerCase() == 'paid';
    final isPending = enrollment.paymentStatus.toLowerCase() == 'pending';

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: enrollment.course.thumbnail != null &&
                    enrollment.course.thumbnail!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: enrollment.course.thumbnail!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 80,
                      width: 80,
                      color: AppTheme.primary.withValues(alpha: 0.05),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      color: AppTheme.primary.withValues(alpha: 0.05),
                      child: const Center(
                        child: Icon(
                          Icons.school_rounded,
                          color: AppTheme.primary,
                          size: 32,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 80,
                    width: 80,
                    color: AppTheme.primary.withValues(alpha: 0.05),
                    child: const Center(
                      child: Icon(
                        Icons.school_rounded,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          // Course details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Payment Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? AppTheme.success.withValues(alpha: 0.1)
                            : isPending
                                ? Colors.orange.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPaid
                            ? 'PAID'
                            : isPending
                                ? 'PENDING'
                                : enrollment.paymentStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isPaid
                              ? AppTheme.success
                              : isPending
                                  ? Colors.orange.shade800
                                  : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Enrollment Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: enrollment.status.toLowerCase() == 'active'
                            ? AppTheme.primary.withValues(alpha: 0.1)
                            : AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        enrollment.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: enrollment.status.toLowerCase() == 'active'
                              ? AppTheme.primary
                              : AppTheme.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  enrollment.course.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Enrolled on ${EnrollmentFormatUtils.formatDate(enrollment.enrolledAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
