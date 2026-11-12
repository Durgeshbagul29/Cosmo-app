import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/models/models.dart';
import 'package:saris_cosmo_center/features/search/search_screen.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';

// Modular Widgets
import 'widgets/service_card.dart';
import 'widgets/service_card_shimmer.dart';
import 'widgets/category_filter_sheet.dart';
import 'widgets/active_filter_chips.dart';
import 'widgets/appointments_empty_view.dart';
import 'widgets/booking_sheet.dart';

// Re-exports for backward compatibility with other screens
export 'widgets/service_card.dart';
export 'widgets/service_card_shimmer.dart';
export 'widgets/booking_sheet.dart';

class AppointmentsScreen extends StatefulWidget {
  final Expert? selectedExpert;
  const AppointmentsScreen({super.key, this.selectedExpert});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentController _controller = Get.put(AppointmentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.resetFilters();
      if (widget.selectedExpert != null) {
        BookingSheet.show(context, widget.selectedExpert!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              _controller.resetFilters();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => CategoryFilterSheet.show(context),
          ),
        ],
      ),
      body: Obx(() {
        final list = _controller.filteredServices;
        final isLoading = _controller.isLoadingServices.value;

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              _controller.fetchServices(),
              _controller.fetchCategories(),
            ]);
          },
          color: AppTheme.primary,
          child: Column(
            children: [
              ActiveFilterChips(controller: _controller),
              Expanded(
                child: list.isEmpty
                    ? (isLoading
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) =>
                                const ServiceCardShimmer(),
                          )
                        : const AppointmentsEmptyView())
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final service = list[index];
                          return ServiceCard(service: service);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
