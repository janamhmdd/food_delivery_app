import 'package:flutter/material.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              
              const AppLogo(assetPath: 'assets/images/logo_alt.png', width: 130),
              const SizedBox(height: 20),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
              const Spacer(flex: 3),
              AppButton(
                text: 'Log In',
                backgroundColor: AppColors.headerYellow,
                textColor: AppColors.textPrimary,
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.loginScreen),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Sign Up',
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.signUp),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}