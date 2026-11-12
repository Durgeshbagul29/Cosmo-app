import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class AppointmentSuccessHeader extends StatelessWidget {
  final String serviceName;

  const AppointmentSuccessHeader({
    super.key,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Booking Confirmed!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Your appointment for\n$serviceName\nhas been successfully booked!',
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
