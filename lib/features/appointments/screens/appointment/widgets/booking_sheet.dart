import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/core/models/models.dart';
import 'package:saris_cosmo_center/core/widgets/common_widgets.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';
import 'package:saris_cosmo_center/features/appointments/models/service_model.dart';

class BookingSheet extends StatefulWidget {
  final Expert expert;
  const BookingSheet({required this.expert, super.key});

  static void show(BuildContext context, Expert expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSheet(expert: expert),
    );
  }

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  final AppointmentController _controller = Get.find<AppointmentController>();

  String? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTime;
  String _paymentMethod = 'online'; // 'online' or 'pay_later'

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<DateTime> _dates = List.generate(
    7,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = _dates.first;

    // Default select first service of the expert if available
    if (widget.expert.services.isNotEmpty) {
      _selectedService = widget.expert.services.first;
    }

    // Load services if empty
    if (_controller.services.isEmpty) {
      _controller.fetchServices().then((_) {
        _fetchSlots();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchSlots();
      });
    }
  }

  ServiceModel? getSelectedServiceModel() {
    if (_selectedService == null) return null;
    try {
      return _controller.services.firstWhere(
        (s) =>
            s.name.toLowerCase().trim() ==
            _selectedService!.toLowerCase().trim(),
      );
    } catch (_) {
      return null;
    }
  }

  void _fetchSlots() {
    final service = getSelectedServiceModel();
    if (service == null || _selectedDate == null) return;
    final formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    _controller.fetchAvailableSlots(
      serviceId: service.id,
      date: formattedDate,
      staffMemberId: int.tryParse(widget.expert.id),
    );
  }

  String _formatTimeSlot(String timeStr) {
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
    final serviceModel = getSelectedServiceModel();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                widget.expert.imageUrl.isEmpty
                    ? Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: AppTheme.primary,
                        ),
                      )
                    : NetworkImageWidget(
                        url: widget.expert.imageUrl,
                        height: 48,
                        width: 48,
                        borderRadius: BorderRadius.circular(24),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book with ${widget.expert.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.expert.specialization,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: AppTheme.divider),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Select Service'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.expert.services.map((s) {
                        final isSelected = _selectedService == s;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedService = s;
                              _selectedTime = null;
                            });
                            _fetchSlots();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.divider,
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    if (serviceModel != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.divider),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Service Price',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMedium,
                              ),
                            ),
                            Text(
                              '₹${serviceModel.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    _sectionTitle('Select Date'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 64,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        itemBuilder: (context, index) {
                          final dateObj = _dates[index];
                          final isSelected =
                              _selectedDate?.day == dateObj.day &&
                              _selectedDate?.month == dateObj.month;
                          final weekday = _weekdays[dateObj.weekday % 7];
                          final dayStr = dateObj.day.toString();

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = dateObj;
                                _selectedTime = null;
                              });
                              _fetchSlots();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              width: 54,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.divider,
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
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textDark,
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

                    _sectionTitle('Available Time Slots'),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (_controller.isLoadingSlots.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }

                      final slots = _controller.availableSlots;
                      if (slots.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'No available slots for this selection. Please try another day or specialist.',
                            style: TextStyle(
                              color: AppTheme.textMedium,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots.map((slot) {
                          final startTime = slot['start_time']?.toString() ?? '';
                          final endTime = slot['end_time']?.toString() ?? '';
                          final isSelected = _selectedTime == startTime;
                          final displayTime =
                              '${_formatTimeSlot(startTime)} - ${_formatTimeSlot(endTime)}';

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTime = startTime;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.divider,
                                ),
                              ),
                              child: Text(
                                displayTime,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 24),

                    _sectionTitle('Payment Method'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPaymentMethodTile(
                            'Online Payment',
                            'online',
                            Icons.payment_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPaymentMethodTile(
                            'Pay Later',
                            'pay_later',
                            Icons.storefront_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: serviceModel != null &&
                                _selectedDate != null &&
                                _selectedTime != null
                            ? () {
                                Navigator.pop(context);
                                final formattedDate =
                                    "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                                _controller.bookServiceAppointment(
                                  serviceId: serviceModel.id,
                                  staffMemberId:
                                      int.tryParse(widget.expert.id),
                                  appointmentDate: formattedDate,
                                  startTime: _selectedTime!,
                                  paymentMethod: _paymentMethod,
                                  serviceName: serviceModel.name,
                                  staffName: widget.expert.name,
                                  price: serviceModel.price,
                                );
                              }
                            : null,
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String title, String method, IconData icon) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textLight,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.textDark,
        ),
      );
}
