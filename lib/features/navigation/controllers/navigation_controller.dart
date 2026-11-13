import 'package:get/get.dart';
import 'package:saris_cosmo_center/features/appointments/controllers/appointment_controller.dart';
import 'package:saris_cosmo_center/features/courses/controllers/course_filter_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_filter_controller.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    if (Get.isRegistered<ProductFilterController>()) {
      final filterController = Get.find<ProductFilterController>();
      if (currentIndex.value == 1 && index != 1) {
        filterController.reset();
      }
    }
    if (Get.isRegistered<CourseFilterController>()) {
      final courseFilterController = Get.find<CourseFilterController>();
      if (currentIndex.value == 2 && index != 2) {
        courseFilterController.reset();
      }
    }
    if (Get.isRegistered<AppointmentController>()) {
      final appointmentController = Get.find<AppointmentController>();
      if (currentIndex.value == 3 && index != 3) {
        appointmentController.resetFilters();
      }
    }

    currentIndex.value = index;
  }
}

