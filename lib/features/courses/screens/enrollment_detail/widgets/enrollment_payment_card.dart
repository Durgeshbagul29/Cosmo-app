import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/courses/models/enrollment_model.dart';
import 'enrollment_format_utils.dart';

class EnrollmentPaymentCard extends StatelessWidget {
  final Enrollment enrollment;

  const EnrollmentPaymentCard({
    super.key,
    required this.enrollment,
  });

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enrollment & Payment Information',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Amount Paid', '₹${enrollment.amountPaid.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildInfoRow('Payment Status', enrollment.paymentStatus.toUpperCase()),
          const SizedBox(height: 8),
          _buildInfoRow('Enrollment Date', EnrollmentFormatUtils.formatDate(enrollment.enrolledAt)),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Completion Date',
            enrollment.completedAt != null && enrollment.completedAt!.isNotEmpty
                ? EnrollmentFormatUtils.formatDate(enrollment.completedAt!)
                : 'In Progress',
          ),
        ],
      ),
    );
  }
}
