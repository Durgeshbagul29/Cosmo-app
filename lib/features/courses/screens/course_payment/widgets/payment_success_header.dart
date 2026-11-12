import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class PaymentSuccessHeader extends StatelessWidget {
  final String title;
  final bool isCourse;

  const PaymentSuccessHeader({
    super.key,
    required this.title,
    required this.isCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Payment Successful!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isCourse
              ? 'You are now enrolled in\n$title'
              : 'Your order for\n$title\nhas been placed successfully!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textMedium,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
