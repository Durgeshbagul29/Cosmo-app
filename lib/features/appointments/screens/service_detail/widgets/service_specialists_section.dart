import 'package:flutter/material.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/widgets/common_widgets.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';

class ServiceSpecialistsSection extends StatelessWidget {
  final List<ServiceStaff> staffList;
  final void Function(ServiceStaff staff)? onStaffTap;

  const ServiceSpecialistsSection({
    super.key,
    required this.staffList,
    this.onStaffTap,
  });

  @override
  Widget build(BuildContext context) {
    if (staffList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Specialists',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return _StaffCard(
                staff: staff,
                onTap: onStaffTap != null ? () => onStaffTap!(staff) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StaffCard extends StatelessWidget {
  final ServiceStaff staff;
  final VoidCallback? onTap;

  const _StaffCard({
    required this.staff,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (staff.image != null && staff.image!.isNotEmpty)
                  NetworkImageWidget(
                    url: staff.image!,
                    height: 60,
                    width: 60,
                    borderRadius: BorderRadius.circular(30),
                  )
                else
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        staff.name.isNotEmpty
                            ? staff.name[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              staff.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              staff.specialization ?? staff.role ?? 'Specialist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
