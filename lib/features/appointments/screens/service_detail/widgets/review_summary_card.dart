import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class ReviewSummaryCard extends StatelessWidget {
  final Map<String, dynamic> summary;

  const ReviewSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final double avg = (summary['average_rating'] ?? 0.0).toDouble();
    final int total = summary['total_reviews'] ?? 0;
    final dist = summary['distribution'] ?? {};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  if (avg >= starIndex) {
                    return const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppTheme.ratingStar,
                    );
                  } else if (avg >= starIndex - 0.5) {
                    return const Icon(
                      Icons.star_half_rounded,
                      size: 14,
                      color: AppTheme.ratingStar,
                    );
                  } else {
                    return const Icon(
                      Icons.star_border_rounded,
                      size: 14,
                      color: AppTheme.ratingStar,
                    );
                  }
                }),
              ),
              const SizedBox(height: 6),
              Text(
                '$total ${total == 1 ? 'review' : 'reviews'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((rating) {
                final count = dist[rating.toString()] ?? dist[rating] ?? 0;
                final fraction = total == 0 ? 0.0 : count / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        child: Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: AppTheme.ratingStar,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            value: fraction.toDouble(),
                            backgroundColor: AppTheme.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
