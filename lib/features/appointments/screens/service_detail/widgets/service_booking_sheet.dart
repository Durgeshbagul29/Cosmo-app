import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/booking_date_selector.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/booking_payment_selector.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/booking_sheet_header.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/booking_specialist_selector.dart';
import 'package:saris_cosmo_center/features/appointments/screens/service_detail/widgets/booking_time_slot_selector.dart';

class ServiceBookingSheet extends StatefulWidget {
  final ServiceModel service;
  final ServiceStaff? initialStaff;

  const ServiceBookingSheet({
    super.key,
    required this.service,
    this.initialStaff,
  });

  static void show(
    BuildContext context,
    ServiceModel service, [
    ServiceStaff? initialStaff,
  ]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceBookingSheet(
        service: service,
        initialStaff: initialStaff,
      ),
    );
  }

  @override
  State<ServiceBookingSheet> createState() => _ServiceBookingSheetState();
}

class _ServiceBookingSheetState extends State<ServiceBookingSheet> {
  final AppointmentController _controller = Get.find<AppointmentController>();

  ServiceStaff? _selectedStaff;
  DateTime? _selectedDate;
  String? _selectedTime;
  String _paymentMethod = 'online';
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _dates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    _selectedDate = _dates.first;

    if (widget.initialStaff != null) {
      _selectedStaff = widget.initialStaff;
    } else if (widget.service.staff != null &&
        widget.service.staff!.isNotEmpty) {
      _selectedStaff = widget.service.staff!.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSlots();
    });
  }

  void _fetchSlots() {
    if (_selectedDate == null) return;
    final formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    _controller.fetchAvailableSlots(
      serviceId: widget.service.id,
      date: formattedDate,
      staffMemberId: _selectedStaff?.id,
    );
  }

  void _onConfirmBooking() {
    if (_selectedTime == null) return;
    Navigator.pop(context);
    final formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    _controller.bookServiceAppointment(
      serviceId: widget.service.id,
      staffMemberId: _selectedStaff?.id,
      appointmentDate: formattedDate,
      startTime: _selectedTime!,
      paymentMethod: _paymentMethod,
      serviceName: widget.service.name,
      staffName: _selectedStaff?.name ?? 'Assigned Expert',
      price: widget.service.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffList = widget.service.staff ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            BookingSheetHeader(service: widget.service),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSpecialistSelector(
                      staffList: staffList,
                      selectedStaff: _selectedStaff,
                      onSelectStaff: (staff) {
                        setState(() {
                          _selectedStaff = staff;
                          _selectedTime = null;
                        });
                        _fetchSlots();
                      },
                    ),
                    BookingDateSelector(
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onSelectDate: (dateObj) {
                        setState(() {
                          _selectedDate = dateObj;
                          _selectedTime = null;
                        });
                        _fetchSlots();
                      },
                    ),
                    Obx(
                      () => BookingTimeSlotSelector(
                        isLoading: _controller.isLoadingSlots.value,
                        slots: _controller.availableSlots,
                        selectedTime: _selectedTime,
                        onSelectSlot: (startTime, slotStaffId) {
                          setState(() {
                            _selectedTime = startTime;
                            if (slotStaffId != null &&
                                _selectedStaff?.id != slotStaffId) {
                              _selectedStaff = widget.service.staff
                                  ?.firstWhereOrNull(
                                      (s) => s.id == slotStaffId);
                            }
                          });
                        },
                      ),
                    ),
                    BookingPaymentSelector(
                      selectedMethod: _paymentMethod,
                      onSelectMethod: (method) {
                        setState(() => _paymentMethod = method);
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _selectedTime != null ? _onConfirmBooking : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Confirm Appointment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
