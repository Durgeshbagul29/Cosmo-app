import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/profile/my_appointments_screen.dart';
import 'package:saris_cosmo_center/main.dart';

class AppointmentSuccessActions extends StatelessWidget {
  const AppointmentSuccessActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Get.offAll(() => const MainNavigation());
              Get.to(() => const MyAppointmentsScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'View Appointments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Get.until((route) => route.isFirst);
          },
          child: const Text(
            'Back to Home',
            style: TextStyle(
              color: AppTheme.textMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
