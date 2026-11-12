import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import '../../controllers/enrollment_detail_controller.dart';
import '../../controllers/my_courses_controller.dart';

// Modular Widgets
import 'widgets/enrollment_course_header.dart';
import 'widgets/enrollment_student_card.dart';
import 'widgets/enrollment_payment_card.dart';
import 'widgets/enrollment_progress_card.dart';
import 'widgets/enrollment_syllabus_list.dart';
import 'widgets/enrollment_raw_progress_list.dart';
import 'widgets/enrollment_certificate_card.dart';

class EnrollmentDetailScreen extends StatefulWidget {
  final int enrollmentId;

  const EnrollmentDetailScreen({
    super.key,
    required this.enrollmentId,
  });

  @override
  State<EnrollmentDetailScreen> createState() => _EnrollmentDetailScreenState();
}

class _EnrollmentDetailScreenState extends State<EnrollmentDetailScreen> {
  final EnrollmentDetailController _detailController =
      Get.put(EnrollmentDetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailController.fetchEnrollmentDetail(widget.enrollmentId);
    });
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<MyCoursesController>()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<MyCoursesController>()) {
            Get.find<MyCoursesController>().fetchMyEnrollments();
          }
        });
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Course Progress'),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (_detailController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        final enrollment = _detailController.enrollment.value;
        final course = _detailController.courseDetails.value;

        if (enrollment == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 60,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load progress details.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      _detailController.fetchEnrollmentDetail(widget.enrollmentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        final List<dynamic> modules = enrollment.course.modules.isNotEmpty
            ? enrollment.course.modules
            : (course?.modules ?? []);

        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () =>
              _detailController.fetchEnrollmentDetail(widget.enrollmentId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnrollmentCourseHeader(enrollment: enrollment),
                const SizedBox(height: 12),
                EnrollmentStudentCard(enrollment: enrollment),
                const SizedBox(height: 12),
                EnrollmentPaymentCard(enrollment: enrollment),
                const SizedBox(height: 12),
                EnrollmentProgressCard(enrollment: enrollment),
                const SizedBox(height: 12),
                if (modules.isNotEmpty)
                  EnrollmentSyllabusList(
                    modules: modules,
                    enrollment: enrollment,
                    detailController: _detailController,
                  )
                else
                  EnrollmentRawProgressList(
                    enrollment: enrollment,
                    detailController: _detailController,
                  ),
                const SizedBox(height: 12),
                EnrollmentCertificateCard(
                  enrollment: enrollment,
                  detailController: _detailController,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}
