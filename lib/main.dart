import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/roleselectionscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LexConnect',
      debugShowCheckedModeBanner: false,

      // Route configuration
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/role-select': (context) => RoleSelectionScreen(),
        '/client-onboarding': (context) => ClientOnboardingScreen(),
        '/lawyer-verification': (context) => LawyerVerificationScreen(),
        '/browse': (context) => GuestBrowseScreen(),
      },

      // Optional: Custom theme
      theme: ThemeData(
        fontFamily: 'Euclid',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
