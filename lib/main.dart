import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spaceships/Controller/login_controller.dart';
import 'package:spaceships/Controller/login_option_controller.dart';
import 'package:spaceships/Controller/register_controller.dart';
import 'package:spaceships/Controller/theme_controller.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/registerloginforgot/loginoption.dart';
import 'package:spaceships/screen/registerloginforgot/splash%20screen.dart';


import 'Common/Theme/app_theme_helper.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("Fcm token $fcmToken  ");
  Get.put(LoginOptionController());
  Get.put(LoginScreenController());
  Get.put(RegisterController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetBuilder<ThemeController>(
      builder: (themeController) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreenWithDelay(),
        navigatorKey: Get.key,
      ),
    );
  }
}

class SplashScreenWithDelay extends StatefulWidget {
  @override
  _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() async {
    await Future.delayed(Duration(milliseconds: 600));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Get.offAll(AuthCheckerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class AuthCheckerScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> checkAuthState() async {
    return _auth.currentUser; // Return the current user from FirebaseAuth
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: checkAuthState(), // Call the function to get the future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // Show splash screen while checking auth state
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is already logged in, navigate to HomeScreen
          return HomeScreen(username: snapshot.data!.displayName ?? '');
        } else {
          // User is not logged in, navigate to LoginOptionScreen
          return LoginOptionScreen();
        }
      },
    );
  }
}
