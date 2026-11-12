import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/utils/app_snackbar.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'package:saris_cosmo_center/features/courses/controllers/enrollment_detail_controller.dart';
import 'certificate_details_bottom_sheet.dart';

class EnrollmentCertificateCard extends StatelessWidget {
  final Enrollment enrollment;
  final EnrollmentDetailController detailController;

  const EnrollmentCertificateCard({
    super.key,
    required this.enrollment,
    required this.detailController,
  });

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        launched = await launchUrl(url);
      }
      if (!launched) {
        AppSnackbar.error(
          'Error',
          'Could not open link in browser.',
        );
      }
    } catch (e) {
      debugPrint('Launch Error: $e');
      try {
        final Uri url = Uri.parse(urlString);
        await launchUrl(url);
      } catch (fallbackError) {
        AppSnackbar.error(
          'Error',
          'Failed to open link: $fallbackError',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = enrollment.completedAt != null &&
        enrollment.completedAt!.isNotEmpty &&
        enrollment.certificate != null;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certificate',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Base Card Content
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isUnlocked
                          ? Colors.amber.shade400
                          : AppTheme.divider,
                      width: 1.5,
                    ),
                    color: isUnlocked
                        ? Colors.amber.shade50.withValues(alpha: 0.2)
                        : AppTheme.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: isUnlocked
                                ? Colors.amber.shade700
                                : AppTheme.textLight,
                            size: 44,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isUnlocked
                                      ? 'Course Completed!'
                                      : 'Certificate Locked',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: isUnlocked
                                        ? Colors.amber.shade900
                                        : AppTheme.textMedium,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isUnlocked
                                      ? 'Your official course certificate is ready to download.'
                                      : 'Achieve 100% course completion progress to unlock your verified certificate.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.4,
                                    color: isUnlocked
                                        ? Colors.amber.shade800
                                        : AppTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isUnlocked) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _launchUrl(enrollment.certificate!.url),
                                icon: const Icon(
                                  Icons.open_in_browser_rounded,
                                  size: 18,
                                ),
                                label: const Text('Download'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.success,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    CertificateDetailsBottomSheet.show(
                                  context,
                                  enrollment.certificate!,
                                  detailController,
                                ),
                                icon: const Icon(
                                  Icons.verified_user_outlined,
                                  size: 18,
                                ),
                                label: const Text('View Details'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primary,
                                  side: const BorderSide(
                                    color: AppTheme.primary,
                                    width: 1.5,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Lock Overlay if not unlocked
                if (!isUnlocked)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Complete Course to Unlock',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
