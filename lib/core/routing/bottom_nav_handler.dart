import 'package:flutter/material.dart';
import '../../features/auth/logic/filter_categories.dart';
import '../../features/auth/ui/category_items_screen.dart';
import '../../features/auth/ui/favorites_screen.dart';
import 'routes.dart';
import '../../features/auth/ui/orders_screen.dart';
import '../../features/auth/ui/help_screen.dart';
/// Shared tap handler for AppBottomNavBar. Only Home (0), Menu (1) and
/// Favorites (2) have real screens right now — Orders (3) and Support (4)
/// are left as no-ops until those screens exist.
void handleBottomNavTap(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;

  switch (index) {
    case 0:
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryItemsScreen(category: kTopCategories.first.label),
        ),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
      );
      break;
    case 3:
       Navigator.pushReplacement(
         context,
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
      );
    case 4:
     Navigator.pushReplacement(
       context,
      MaterialPageRoute(builder: (_) => const HelpScreen()),
     );
    break;
  }
}