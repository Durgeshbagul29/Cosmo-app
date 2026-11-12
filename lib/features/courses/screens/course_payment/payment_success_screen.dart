import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

// Modular Widgets
import 'widgets/payment_success_animation.dart';
import 'widgets/payment_success_header.dart';
import 'widgets/payment_transaction_card.dart';
import 'widgets/payment_action_button.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String title;
  final double amount;
  final String paymentId;
  final bool isCourse;
  final int? orderId;
  final int? enrollmentId;

  const PaymentSuccessScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.paymentId,
    this.isCourse = false,
    this.orderId,
    this.enrollmentId,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 25.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                PaymentSuccessAnimation(
                  scaleAnimation: _scaleAnimation,
                  checkAnimation: _checkAnimation,
                ),
                const SizedBox(height: 40),
                PaymentSuccessHeader(
                  title: widget.title,
                  isCourse: widget.isCourse,
                ),
                const SizedBox(height: 32),
                PaymentTransactionCard(
                  amount: widget.amount,
                  paymentId: widget.paymentId,
                ),
                const Spacer(),
                PaymentActionButton(
                  isCourse: widget.isCourse,
                  orderId: widget.orderId,
                  enrollmentId: widget.enrollmentId,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
