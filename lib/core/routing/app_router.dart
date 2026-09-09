import 'package:flutter/material.dart';
import 'routes.dart';
import '../../features/auth/ui/splash_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
import '../../features/auth/ui/set_password_screen.dart';
import '../../features/auth/ui/set_fingerprint_screen.dart';
import '../../features/auth/ui/profile_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case Routes.setPassword:
        return MaterialPageRoute(builder: (_) => const SetPasswordScreen());

      case Routes.setFingerprint:
        final initialScanned = settings.arguments is bool ? settings.arguments as bool : false;
        return MaterialPageRoute(builder: (_) => SetFingerprintScreen(initialScanned: initialScanned));

      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Food Delivery'),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.person_outline),
                    tooltip: 'Profile',
                    onPressed: () => Navigator.pushNamed(context, Routes.profile),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  const Text('Home Screen - Coming Soon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) => ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, Routes.profile),
                      icon: const Icon(Icons.person),
                      label: const Text('Open Profile'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE95322), foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}