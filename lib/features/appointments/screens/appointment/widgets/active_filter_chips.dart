import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';

class ActiveFilterChips extends StatelessWidget {
  final AppointmentController controller;

  const ActiveFilterChips({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIds = controller.selectedCategoryIds;
      if (selectedIds.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          children: selectedIds.map((id) {
            final category =
                controller.categories.firstWhereOrNull((c) => c.id == id);
            if (category == null) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: Chip(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                side: const BorderSide(color: AppTheme.primary, width: 0.5),
                label: Text(
                  category.name,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                deleteIcon: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppTheme.primary,
                ),
                onDeleted: () {
                  controller.toggleCategorySelection(id);
                },
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
