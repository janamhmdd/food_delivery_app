import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Top yellow header screen title (e.g. "Hello!", "New Account", "Set Password")
  static const TextStyle headerTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // Main headings inside card (e.g. "Welcome")
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Field labels above text inputs
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Colored links (e.g. "Forget Password", "Sign Up", "Terms of Use")
  static const TextStyle link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );
}