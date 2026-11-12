import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class BookingTimeSlotSelector extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> slots;
  final String? selectedTime;
  final void Function(String startTime, int? staffMemberId) onSelectSlot;

  const BookingTimeSlotSelector({
    super.key,
    required this.isLoading,
    required this.slots,
    required this.selectedTime,
    required this.onSelectSlot,
  });

  static String _formatTimeSlot(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 2.5,
              ),
            ),
          )
        else if (slots.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'No available slots for this selection. Please try another day or specialist.',
              style: TextStyle(
                color: AppTheme.textMedium,
                fontSize: 13,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              final startTime = slot['start_time']?.toString() ?? '';
              final endTime = slot['end_time']?.toString() ?? '';
              final isSelected = selectedTime == startTime;
              final displayTime =
                  '${_formatTimeSlot(startTime)} - ${_formatTimeSlot(endTime)}';
              final slotStaffId = slot['staff_member_id'] as int?;

              return GestureDetector(
                onTap: () => onSelectSlot(startTime, slotStaffId),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.divider,
                    ),
                  ),
                  child: Text(
                    displayTime,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
