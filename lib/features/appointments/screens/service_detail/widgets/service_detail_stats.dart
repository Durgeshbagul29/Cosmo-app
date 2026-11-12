import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';

class ServiceDetailStats extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailStats({
    super.key,
    required this.service,
  });

  Widget _buildStatItem(IconData icon, String value, String label,
      {Color? iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppTheme.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.access_time_rounded,
            '${service.durationMinutes} mins',
            'Duration',
          ),
          Container(height: 24, width: 1, color: AppTheme.divider),
          _buildStatItem(
            Icons.star_rounded,
            '4.8',
            'Rating',
            iconColor: AppTheme.ratingStar,
          ),
          Container(height: 24, width: 1, color: AppTheme.divider),
          _buildStatItem(
            Icons.check_circle_outline_rounded,
            'Verified',
            'Service',
            iconColor: AppTheme.success,
          ),
        ],
      ),
    );
  }
}
