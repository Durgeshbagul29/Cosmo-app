import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class PaymentSuccessAnimation extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> checkAnimation;

  const PaymentSuccessAnimation({
    super.key,
    required this.scaleAnimation,
    required this.checkAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main Circle (Starts massive, shrinks to 1x)
        ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppTheme.success,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Checkmark in Circle
        ScaleTransition(
          scale: checkAnimation,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
