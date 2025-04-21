import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/roleselectionscreen.dart';
import 'screens/clientonboarding_screen.dart';
import 'screens/clientdashboard_screen.dart';
import 'screens/lawyerverification_screen.dart';
import 'screens/verificationpending_screen.dart';
import 'screens/guestbrowse_screen.dart';

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
        '/client-dashboard': (context) => ClientDashboardScreen(),
        '/lawyer-verification': (context) => LawyerVerificationScreen(),
        '/verification-pending': (context) => VerificationPendingScreen(),
        '/browse': (context) => GuestBrowseScreen(),
      },

      // Optional: Custom theme
      theme: ThemeData(
        fontFamily: 'FiraSans',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
