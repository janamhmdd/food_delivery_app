import 'package:flutter/material.dart';
import 'routes.dart';
import '../../features/auth/ui/splash_screen.dart';
import '../../features/auth/ui/welcome_screen.dart';
import '../../features/auth/ui/onboarding_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
import '../../features/auth/ui/set_password_screen.dart';
import '../../features/auth/ui/set_fingerprint_screen.dart';
import '../../features/auth/ui/profile_screen.dart';
import '../../features/auth/ui/filter_screen.dart';
import '../../features/auth/ui/home_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

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

      case Routes.filter:
        return MaterialPageRoute(builder: (_) => const FilterScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}