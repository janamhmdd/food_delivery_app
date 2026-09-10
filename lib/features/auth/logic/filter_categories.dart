import 'package:flutter/material.dart';

class TopCategory {
  final String label;
  final IconData icon;
  final List<String> subCategories;

  const TopCategory({
    required this.label,
    required this.icon,
    required this.subCategories,
  });
}

const List<TopCategory> kTopCategories = [
  TopCategory(
    label: 'Snacks',
    icon: Icons.fastfood_outlined,
    subCategories: [
      'Bruschetta', 'Spring Rolls', 'Crepes',
      'Wings', 'Skewers', 'Salmon',
      'Mexican', 'Baked', 'Appetizer',
    ],
  ),
  TopCategory(
    label: 'Meal',
    icon: Icons.restaurant_menu_outlined,
    subCategories: [
      'Sushi', 'Pizza', 'Chicken',
      'Curry', 'Burger', 'Cheese',
      'Fresh Prawn', 'Ceviche', 'Pad Thai',
    ],
  ),
  TopCategory(
    label: 'Vegan',
    icon: Icons.eco_outlined,
    subCategories: [
      'Bean Burger', 'Lagsana', 'Pizza',
      'Mushroom', 'Risotto', 'Broccoli',
      'Hummus', 'Quinoa', 'Salad',
    ],
  ),
  TopCategory(
    label: 'Dessert',
    icon: Icons.icecream_outlined,
    subCategories: [
      'Crepes', 'Macarons', 'Cupcakes',
      'Ice Cream', 'Flan', 'Cheesecake',
      'Chocolate', 'Cakes', 'Brownie',
    ],
  ),
  TopCategory(
    label: 'Drinks',
    icon: Icons.local_drink_outlined,
    subCategories: [
      'Coffee', 'Cocktail', 'Juice',
      'Milkshake', 'Wine', 'Piña Colada',
      'Mojito', 'Craft Beer', 'Ice Tea',
    ],
  ),
];

const List<String> kPriceStops = ['\$1', '\$10', '\$50', '\$100 >'];