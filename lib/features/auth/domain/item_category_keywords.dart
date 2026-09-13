
const Map<String, List<String>> kItemCategoryKeywords = {
  'Snacks': [
    'bruschetta', 'spring roll', 'crepe', 'wing', 'skewer', 'nugget',
    'fries', 'appetizer', 'chips', 'popcorn', 'samosa', 'dumpling',
  ],
  'Meal': [
    'sushi', 'pizza', 'chicken', 'curry', 'burger', 'pasta', 'noodle',
    'steak', 'sandwich', 'taco', 'burrito', 'kebab', 'biryani',
    'wrap', 'lasagna', 'seafood', 'prawn', 'ceviche', 'pad thai',
  ],
  'Vegan': [
    'bean burger', 'mushroom', 'risotto', 'broccoli', 'hummus', 'quinoa',
    'salad', 'vegetable', 'vegan', 'vegetarian', 'tofu', 'lentil',
  ],
  'Dessert': [
     'coconut', 'ice cream', 'flan', 'cheesecake', 'chocolate',
     'brownie', 'pie', 'pudding', 'tart', 'cookie',
  ],
  'Drinks': [
    'coffee', 'beer', 'tea'
  ],
};

bool matchesItemCategoryKeywords(String category, String itemName, String itemDescription) {
  final keywords = kItemCategoryKeywords[category] ?? const [];
  final haystack = '$itemName $itemDescription'.toLowerCase();
  return keywords.any((k) => haystack.contains(k));
}