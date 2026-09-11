import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final String assetPath;

  const AppLogo({
    super.key,
    this.width = 140,
    this.assetPath = 'assets/images/logo.png',
  });

  @override
  Widget build(BuildContext context) {

    return Image.asset(
      assetPath,
      width: width,
      height: width * (257.6 / 204.31),
      fit: BoxFit.contain,
    );
  }
}