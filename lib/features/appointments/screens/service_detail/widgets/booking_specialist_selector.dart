import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/widgets/common_widgets.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';

class BookingSpecialistSelector extends StatelessWidget {
  final List<ServiceStaff> staffList;
  final ServiceStaff? selectedStaff;
  final ValueChanged<ServiceStaff> onSelectStaff;

  const BookingSpecialistSelector({
    super.key,
    required this.staffList,
    required this.selectedStaff,
    required this.onSelectStaff,
  });

  @override
  Widget build(BuildContext context) {
    if (staffList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Specialist',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              final isSelected = selectedStaff?.id == staff.id;
              return GestureDetector(
                onTap: () => onSelectStaff(staff),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  width: 160,
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
                  child: Row(
                    children: [
                      if (staff.image != null && staff.image!.isNotEmpty)
                        NetworkImageWidget(
                          url: staff.image!,
                          height: 36,
                          width: 36,
                          borderRadius: BorderRadius.circular(18),
                        )
                      else
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              AppTheme.primary.withValues(alpha: 0.1),
                          child: Text(
                            staff.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              staff.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            Text(
                              staff.specialization ??
                                  staff.role ??
                                  'Specialist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
