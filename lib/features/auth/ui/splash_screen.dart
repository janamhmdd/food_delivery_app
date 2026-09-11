import 'package:flutter/material.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasSession = await SharedPrefHelper.hasUserSession();
    if (!mounted) return;

    if (hasSession) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }

    final hasSeenOnboarding = await SharedPrefHelper.hasSeenOnboarding();
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      hasSeenOnboarding ? Routes.welcome : Routes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return const Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: Center(child: AppLogo()),
    );
  }
}