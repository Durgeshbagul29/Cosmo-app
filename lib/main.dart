import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saris_cosmo_center/app.dart';
import 'package:saris_cosmo_center/core/services/firebase_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Exports for backward compatibility
export 'package:saris_cosmo_center/app.dart';
export 'package:saris_cosmo_center/features/navigation/controllers/navigation_controller.dart';
export 'package:saris_cosmo_center/features/navigation/screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase and FCM Messaging
  try {
    await Firebase.initializeApp();
    debugPrint("🔔 FCM Trace: Firebase initialized successfully in main()");
    await FirebaseNotificationService.instance.initialize();
  } catch (e) {
    debugPrint("🔔 FCM Trace: Failed to initialize Firebase: $e");
  }

  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
  final isLoggedIn = prefs.getString('auth_token') != null;

  // Register device token on launch if logged in
  if (isLoggedIn) {
    try {
      await FirebaseNotificationService.instance.registerDeviceToken();
    } catch (e) {
      debugPrint("🔔 FCM Trace: Failed to register device token on launch: $e");
    }
  }

  runApp(
    IICTNApp(onboardingComplete: onboardingComplete, isLoggedIn: isLoggedIn),
  );
}
