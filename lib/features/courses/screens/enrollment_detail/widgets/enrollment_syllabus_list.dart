import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'package:saris_cosmo_center/features/courses/controllers/enrollment_detail_controller.dart';
import 'package:saris_cosmo_center/features/courses/screens/lesson/lesson_detail_screen.dart';
import 'enrollment_format_utils.dart';

class EnrollmentSyllabusList extends StatelessWidget {
  final List<dynamic> modules;
  final Enrollment enrollment;
  final EnrollmentDetailController detailController;

  const EnrollmentSyllabusList({
    super.key,
    required this.modules,
    required this.enrollment,
    required this.detailController,
  });

  void _navigateToLesson(
    BuildContext context,
    Map<String, dynamic> lesson,
    LessonProgress? matchedProgress,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(
          lesson: lesson,
          enrollment: enrollment,
          progress: matchedProgress,
          detailController: detailController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonProgress = enrollment.lessonProgress;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Course Modules & Lessons',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final module = modules[index];
              final String moduleTitle =
                  module['title']?.toString() ?? 'Module ${index + 1}';
              final String description =
                  module['description']?.toString() ?? '';
              final List lessonsList = module['lessons'] as List? ?? [];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      moduleTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    subtitle: lessonsList.isNotEmpty
                        ? Text(
                            '${lessonsList.length} topics',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textLight,
                            ),
                          )
                        : null,
                    childrenPadding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      if (description.isNotEmpty) ...[
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMedium,
                            height: 1.4,
                          ),
                        ),
                        if (lessonsList.isNotEmpty) const SizedBox(height: 12),
                      ],
                      if (lessonsList.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lessonsList.map((lesson) {
                            final int lessonId = lesson['id'] ?? 0;
                            final String title =
                                lesson['title']?.toString() ?? '';

                            // Find matching progress
                            final matchedProgress =
                                lessonProgress.firstWhereOrNull(
                              (p) => p.lessonId == lessonId,
                            );

                            final status = (matchedProgress?.status ??
                                    'not_started')
                                .toLowerCase();
                            final isCompleted = status == 'completed';
                            final isAttended = status == 'attended';

                            // Style choices
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

                            final lessonMap =
                                Map<String, dynamic>.from(lesson);

                            return InkWell(
                              onTap: () => _navigateToLesson(
                                context,
                                lessonMap,
                                matchedProgress,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        statusIcon,
                                        size: 18,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isCompleted || isAttended
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isCompleted
                                                  ? AppTheme.textMedium
                                                  : AppTheme.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            isCompleted &&
                                                    matchedProgress?.completedAt != null
                                                ? 'Completed on: ${EnrollmentFormatUtils.formatDateTime(matchedProgress!.completedAt!)}'
                                                : isAttended &&
                                                        matchedProgress?.attendedAt != null
                                                    ? 'Attended on: ${EnrollmentFormatUtils.formatDateTime(matchedProgress!.attendedAt!)}'
                                                    : statusLabel,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: statusColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 20,
                                        color: AppTheme.primary,
                                      ),
                                      onPressed: () => _navigateToLesson(
                                        context,
                                        lessonMap,
                                        matchedProgress,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
