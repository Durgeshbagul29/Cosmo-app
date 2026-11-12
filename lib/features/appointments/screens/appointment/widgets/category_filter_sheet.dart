import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';

class CategoryFilterSheet extends StatelessWidget {
  const CategoryFilterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CategoryFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentController controller = Get.find<AppointmentController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0, color: AppTheme.divider),
              Expanded(
                child: Obx(() {
                  final categoriesList = controller.categories;
                  final selectedIds = controller.selectedCategoryIds;

                  if (controller.isLoadingCategories.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    );
                  }

                  return ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      CheckboxListTile(
                        title: const Text(
                          'All Categories',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        value: selectedIds.isEmpty,
                        activeColor: AppTheme.primary,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (bool? checked) {
                          if (checked == true) {
                            controller.clearCategorySelection();
                          }
                        },
                      ),
                      ...categoriesList.map((cat) {
                        final isSelected = selectedIds.contains(cat.id);
                        return CheckboxListTile(
                          title: Text(
                            cat.name,
                            style: const TextStyle(color: AppTheme.textDark),
                          ),
                          value: isSelected,
                          activeColor: AppTheme.primary,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (bool? checked) {
                            controller.toggleCategorySelection(cat.id);
                          },
                        );
                      }),
                    ],
                  );
                }),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
