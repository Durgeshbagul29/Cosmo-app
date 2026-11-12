import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

// Modular Widgets
import 'widgets/appointment_success_animation.dart';
import 'widgets/appointment_success_header.dart';
import 'widgets/appointment_details_card.dart';
import 'widgets/appointment_success_actions.dart';

class AppointmentSuccessScreen extends StatefulWidget {
  final String serviceName;
  final String staffName;
  final String date;
  final String time;
  final double amount;
  final String paymentMethod;
  final String paymentId;

  const AppointmentSuccessScreen({
    super.key,
    required this.serviceName,
    required this.staffName,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    required this.paymentId,
  });

  @override
  State<AppointmentSuccessScreen> createState() =>
      _AppointmentSuccessScreenState();
}

class _AppointmentSuccessScreenState extends State<AppointmentSuccessScreen>
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
                AppointmentSuccessAnimation(
                  scaleAnimation: _scaleAnimation,
                  checkAnimation: _checkAnimation,
                ),
                const SizedBox(height: 40),
                AppointmentSuccessHeader(serviceName: widget.serviceName),
                const SizedBox(height: 32),
                AppointmentDetailsCard(
                  staffName: widget.staffName,
                  date: widget.date,
                  time: widget.time,
                  amount: widget.amount,
                  paymentMethod: widget.paymentMethod,
                  paymentId: widget.paymentId,
                ),
                const Spacer(),
                const AppointmentSuccessActions(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
