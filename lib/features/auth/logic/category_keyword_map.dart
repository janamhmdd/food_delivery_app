/// The API's `category` filter matches real cuisine names on the
/// restaurant's `type` field (e.g. "Biryani", "Parsi Cuisine") — it has no
/// concept of the 5 broad UI categories (Snacks/Meal/Vegan/Dessert/Drinks)
/// used by the Figma kit. Passing "Snacks" etc. as `category` always
/// returns an empty list.
///
/// This is a best-effort client-side substitute: fetch ALL restaurants,
/// then keep the ones whose `type` contains one of these keywords. It's
/// approximate (some restaurants won't match any bucket, some fit more
/// than one) and depends on what cuisine types happen to exist in the
/// dataset right now — it's not a real category system, just the closest
/// thing possible without one.
const Map<String, List<String>> kCategoryKeywords = {
  'Snacks': ['snack', 'appetizer', 'street food', 'fast food', 'grill', 'bbq'],
  'Meal': [
    'biryani', 'curry', 'burger', 'pizza', 'sushi', 'noodle', 'rice',
    'kebab', 'steak', 'sandwich', 'wrap', 'taco', 'pasta', 'chinese',
    'thai', 'mexican', 'indian', 'italian', 'seafood', 'chicken', 'cuisine',
  ],
  'Vegan': ['vegan', 'vegetarian', 'salad', 'organic'],
  'Dessert': ['dessert', 'bakery', 'cake', 'ice cream', 'sweet', 'pastry', 'chocolate'],
  'Drinks': ['juice', 'coffee', 'tea', 'cocktail', 'bar', 'beverage', 'smoothie', 'cafe'],
};

bool matchesCategoryKeywords(String category, String restaurantType) {
  final keywords = kCategoryKeywords[category] ?? const [];
  final lowerType = restaurantType.toLowerCase();
  return keywords.any((k) => lowerType.contains(k));
}