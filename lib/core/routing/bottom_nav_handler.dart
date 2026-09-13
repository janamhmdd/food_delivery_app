import 'package:flutter/material.dart';
import '../../features/auth/logic/filter_categories.dart';
import '../../features/auth/ui/category_items_screen.dart';
import '../../features/auth/ui/favorites_screen.dart';
import 'routes.dart';
import '../../features/auth/ui/orders_screen.dart';
import '../../features/auth/ui/help_screen.dart';

void handleBottomNavTap(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;

  switch (index) {
    case 0:
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
      break;
    case 1:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryItemsScreen(category: kTopCategories.first.label),
        ),
        (route) => route.isFirst,
      );
      break;
    case 2:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        (route) => route.isFirst,
      );
      break;
    case 3:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
        (route) => route.isFirst,
      );
      break;
    case 4:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HelpScreen()),
        (route) => route.isFirst,
      );
      break;
  }
}