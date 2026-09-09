import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/helpers/shared_pref_helper.dart';
import 'package:food_delivery_app/core/routing/routes.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserCode();
  }

  Future<void> _checkUserCode() async {
    await Future.delayed(const Duration(seconds: 2));

    final userCode = await SharedPrefHelper.getUserCode();

    if (!mounted) return;

    if (userCode != null && userCode.isNotEmpty) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}