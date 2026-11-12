import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/home/widgets/product_card.dart';

class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(
              width: 100,
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    width: 60,
                    height: 10,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  SizedBox(height: 8),
                  ShimmerWidget(
                    width: 160,
                    height: 16,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  SizedBox(height: 6),
                  ShimmerWidget(
                    width: 100,
                    height: 14,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 14,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      SizedBox(width: 4),
                      ShimmerWidget(
                        width: 50,
                        height: 12,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(
                        width: 60,
                        height: 18,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      ShimmerWidget(
                        width: 90,
                        height: 32,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
