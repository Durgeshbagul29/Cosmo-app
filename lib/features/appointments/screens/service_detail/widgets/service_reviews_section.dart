import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/review_item_card.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/review_summary_card.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/reviews_empty_state.dart';

class ServiceReviewsSection extends StatelessWidget {
  final AppointmentController controller;

  const ServiceReviewsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final summary = controller.reviewsSummary.value;
      final isLoading = controller.isLoadingReviews.value;

      if (isLoading && summary == null) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          ],
        );
      }

      final int totalReviews = summary?['total_reviews'] ?? 0;
      final List reviewList = summary?['reviews']?['data'] ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (summary == null || totalReviews == 0)
            const ReviewsEmptyState()
          else ...[
            ReviewSummaryCard(summary: summary),
            const SizedBox(height: 20),
            ...reviewList.map((item) {
              return ReviewItemCard(
                review: Map<String, dynamic>.from(item),
              );
            }),
          ],
        ],
      );
    });
  }
}
