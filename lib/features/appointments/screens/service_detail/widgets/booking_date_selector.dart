import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';

class BookingDateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  const BookingDateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelectDate,
  });

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final dateObj = dates[index];
              final isSelected = selectedDate?.day == dateObj.day &&
                  selectedDate?.month == dateObj.month;
              final weekday = _weekdays[dateObj.weekday % 7];
              final dayStr = dateObj.day.toString();

              return GestureDetector(
                onTap: () => onSelectDate(dateObj),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  width: 54,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.divider,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppTheme.textLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayStr,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
