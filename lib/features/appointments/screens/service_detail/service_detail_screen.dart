import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';

// Modular Widgets
import 'widgets/service_detail_app_bar.dart';
import 'widgets/service_detail_header.dart';
import 'widgets/service_detail_stats.dart';
import 'widgets/service_specialists_section.dart';
import 'widgets/service_reviews_section.dart';
import 'widgets/service_bottom_bar.dart';
import 'widgets/service_booking_sheet.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final AppointmentController _controller = Get.find<AppointmentController>();

  @override
  void initState() {
    super.initState();
    _controller.fetchServiceDetail(widget.service.slug);
    _controller.fetchServiceReviews(widget.service.slug);
  }

  void _showBooking(
    BuildContext context,
    ServiceModel service, [
    ServiceStaff? staff,
  ]) {
    ServiceBookingSheet.show(context, service, staff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        final detail = _controller.serviceDetail.value;
        final isLoading = _controller.isDetailLoading.value;

        if (isLoading || detail == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: Stack(
              children: [
                const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.black26,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            ServiceDetailAppBar(service: detail),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceDetailHeader(service: detail),
                    const SizedBox(height: 24),
                    ServiceDetailStats(service: detail),
                    const SizedBox(height: 32),

                    // Description Section
                    Text(
                      'About This Service',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textDark,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      detail.description?.isNotEmpty == true
                          ? detail.description!
                          : 'Experience professional care with our customized treatment plan designed to refresh and revitalize.',
                      style: const TextStyle(
                        color: AppTheme.textMedium,
                        height: 1.6,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Specialists Section
                    if (detail.staff != null && detail.staff!.isNotEmpty) ...[
                      ServiceSpecialistsSection(
                        staffList: detail.staff!,
                        onStaffTap: (staff) =>
                            _showBooking(context, detail, staff),
                      ),
                      const SizedBox(height: 32),
                    ],

                    ServiceReviewsSection(controller: _controller),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final detail = _controller.serviceDetail.value;
        final isLoading = _controller.isDetailLoading.value;
        if (isLoading || detail == null) return const SizedBox.shrink();

        return ServiceBottomBar(
          onBookPressed: () => _showBooking(context, detail),
        );
      }),
    );
  }
}
