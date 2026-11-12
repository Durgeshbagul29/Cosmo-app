import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';

// Modular Widgets
import 'widgets/expert_card.dart';
import 'widgets/experts_empty_view.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ac = Get.find<AppointmentController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Consult Experts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (ac.isLoadingExperts.value && ac.expertsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        if (ac.expertsList.isEmpty) {
          return const ExpertsEmptyView();
        }

        return RefreshIndicator(
          onRefresh: () => ac.fetchExperts(isRefresh: true),
          color: AppTheme.primary,
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: ac.expertsList.length,
            itemBuilder: (context, index) {
              final expert = ac.expertsList[index];
              return ExpertCard(expert: expert);
            },
          ),
        );
      }),
    );
  }
}
