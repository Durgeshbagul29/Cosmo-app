import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final String staffName;
  final String date;
  final String time;
  final double amount;
  final String paymentMethod;
  final String paymentId;

  const AppointmentDetailsCard({
    super.key,
    required this.staffName,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    required this.paymentId,
  });

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMedium,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          _buildDetailRow('Specialist', staffName),
          const Divider(color: AppTheme.divider, height: 20),
          _buildDetailRow('Date & Time', '$date at $time'),
          const Divider(color: AppTheme.divider, height: 20),
          _buildDetailRow('Amount', '₹${amount.toStringAsFixed(0)}'),
          const Divider(color: AppTheme.divider, height: 20),
          _buildDetailRow('Payment', paymentMethod),
          const Divider(color: AppTheme.divider, height: 20),
          _buildDetailRow('Transaction ID', paymentId),
        ],
      ),
    );
  }
}
