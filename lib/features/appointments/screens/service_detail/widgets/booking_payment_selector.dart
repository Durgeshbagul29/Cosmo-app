import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class BookingPaymentSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onSelectMethod;

  const BookingPaymentSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelectMethod,
  });

  Widget _buildTile(String title, String method, IconData icon) {
    final isSelected = selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelectMethod(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.05)
                : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.divider,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primary : AppTheme.textLight,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.primary : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildTile(
              'Online Payment',
              'online',
              Icons.payment_rounded,
            ),
            const SizedBox(width: 12),
            _buildTile(
              'Pay Later at Salon',
              'pay_later',
              Icons.storefront_rounded,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
