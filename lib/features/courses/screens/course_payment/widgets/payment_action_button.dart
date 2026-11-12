import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/shop/screens/order/order_detail_screen.dart';
import 'package:saris_cosmo_center/features/courses/screens/enrollment_detail/enrollment_detail_screen.dart';

class PaymentActionButton extends StatelessWidget {
  final bool isCourse;
  final int? orderId;
  final int? enrollmentId;

  const PaymentActionButton({
    super.key,
    required this.isCourse,
    this.orderId,
    this.enrollmentId,
  });

  void _onPressed() {
    if (isCourse && enrollmentId != null) {
      Get.off(() => EnrollmentDetailScreen(enrollmentId: enrollmentId!));
    } else if (!isCourse && orderId != null) {
      Get.off(() => OrderDetailScreen(
            orderId: orderId!,
            navigateToMyOrdersOnBack: true,
          ));
    } else {
      Get.until((route) => route.isFirst);
    }
  }

  String get _buttonText {
    if (isCourse) return 'Start Learning';
    if (orderId != null) return 'Check Order Details';
    return 'Back to Home';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          _buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
