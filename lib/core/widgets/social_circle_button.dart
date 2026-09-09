import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class SocialCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double size;

  const SocialCircleButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 50,
  });

  factory SocialCircleButton.fingerprint({VoidCallback? onTap, double size = 46}) {
    return SocialCircleButton(
      onTap: onTap,
      size: size,
      child: Icon(
        Icons.fingerprint,
        color: AppColors.primary,
        size: size * 0.58,
      ),
    );
  }

  factory SocialCircleButton.google({VoidCallback? onTap, double size = 40}) {
    return SocialCircleButton(
      onTap: onTap,
      size: size,
      child: Text(
        'G',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.46,
          fontWeight: FontWeight.bold,
          fontFamily: 'sans-serif',
        ),
      ),
    );
  }

  factory SocialCircleButton.facebook({VoidCallback? onTap, double size = 40}) {
    return SocialCircleButton(
      onTap: onTap,
      size: size,
      child: Text(
        'f',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.46,
          fontWeight: FontWeight.bold,
          fontFamily: 'sans-serif',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.peachCircle,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
