import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/services/firebase_notification_service.dart';
import 'package:saris_cosmo_center/features/appointments/screens/appointment/appointments_screen.dart';
import 'package:saris_cosmo_center/features/courses/controllers/course_filter_controller.dart';
import 'package:saris_cosmo_center/features/courses/screens/course/courses_screen.dart';
import 'package:saris_cosmo_center/features/home/home_screen.dart';
import 'package:saris_cosmo_center/features/navigation/controllers/navigation_controller.dart';
import 'package:saris_cosmo_center/features/navigation/widgets/main_bottom_nav_bar.dart';
import 'package:saris_cosmo_center/features/profile/profile_screen.dart';
import 'package:saris_cosmo_center/features/shop/controllers/cart_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_category_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_filter_controller.dart';
import 'package:saris_cosmo_center/features/shop/screens/products/products_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final NavigationController _navController = Get.put(NavigationController());

  final _screens = const [
    HomeScreen(),
    ProductsScreen(),
    CoursesScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // Ensure core controllers are registered (handles re-login after logout deletion)
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController(), permanent: true);
    }
    if (!Get.isRegistered<ProductFilterController>()) {
      Get.put(ProductFilterController(), permanent: true);
    }
    if (!Get.isRegistered<ProductCategoryController>()) {
      Get.put(ProductCategoryController(), permanent: true);
    }
    if (!Get.isRegistered<CourseFilterController>()) {
      Get.put(CourseFilterController(), permanent: true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseNotificationService.instance.processInitialNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: _navController.currentIndex.value,
          children: _screens,
        ),
        bottomNavigationBar: MainBottomNavBar(
          currentIndex: _navController.currentIndex.value,
          onItemSelected: (index) => _navController.changeIndex(index),
        ),
      ),
    );
  }
}

