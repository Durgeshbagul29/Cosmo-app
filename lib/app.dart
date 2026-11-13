import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saris_cosmo_center/core/controllers/network_controller.dart';
import 'package:saris_cosmo_center/core/theme/app_theme.dart';
import 'package:saris_cosmo_center/features/auth/login_screen.dart';
import 'package:saris_cosmo_center/features/courses/controllers/course_filter_controller.dart';
import 'package:saris_cosmo_center/features/navigation/screens/main_navigation_screen.dart';
import 'package:saris_cosmo_center/features/onboarding/onboarding_screen.dart';
import 'package:saris_cosmo_center/features/shop/controllers/cart_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_category_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_controller.dart';
import 'package:saris_cosmo_center/features/shop/controllers/product_filter_controller.dart';

class IICTNApp extends StatelessWidget {
  final bool onboardingComplete;
  final bool isLoggedIn;

  const IICTNApp({
    super.key,
    required this.onboardingComplete,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize Controllers
    Get.put(NetworkController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(ProductFilterController(), permanent: true);
    Get.put(ProductCategoryController(), permanent: true);
    Get.put(CourseFilterController(), permanent: true);
    Get.put(CartController(), permanent: true);

    Widget homeScreen;
    if (!onboardingComplete) {
      homeScreen = const OnboardingScreen();
    } else if (isLoggedIn) {
      homeScreen = const MainNavigation();
    } else {
      homeScreen = const LoginScreen();
    }

    return GetMaterialApp(
      title: 'Saris Cosmo Center',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home: homeScreen,
    );
  }
}

