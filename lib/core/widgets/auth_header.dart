import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.headerYellow,
      padding: EdgeInsets.only(
        top: topPadding + 14,
        left: 16,
        right: 16,
        bottom: 26,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onBackPressed ?? () => Navigator.maybePop(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          Center(
            child: Text(
              title,
              style: AppTextStyles.headerTitle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
