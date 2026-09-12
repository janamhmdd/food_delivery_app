
const Map<String, List<String>> kItemCategoryKeywords = {
  'Snacks': [
    'bruschetta', 'spring roll', 'crepe', 'wing', 'skewer', 'nugget',
    'fries', 'appetizer', 'chips', 'popcorn', 'samosa', 'dumpling',
  ],
  'Meal': [
    'sushi', 'pizza', 'chicken', 'curry', 'burger', 'pasta', 'noodle',
    'rice', 'steak', 'sandwich', 'taco', 'burrito', 'kebab', 'biryani',
    'wrap', 'lasagna', 'seafood', 'prawn', 'ceviche', 'pad thai',
  ],
  'Vegan': [
    'bean burger', 'mushroom', 'risotto', 'broccoli', 'hummus', 'quinoa',
    'salad', 'vegetable', 'vegan', 'vegetarian', 'tofu', 'lentil',
  ],
  'Dessert': [
    'macaron', 'cupcake', 'ice cream', 'flan', 'cheesecake', 'chocolate',
    'cake', 'brownie', 'pastry', 'pie', 'pudding', 'tart', 'cookie',
  ],
  'Drinks': [
    'coffee', 'cocktail', 'juice', 'milkshake', 'wine', 'piña colada',
    'mojito', 'beer', 'tea', 'smoothie', 'latte', 'lemonade', 'soda',
  ],
};

bool matchesItemCategoryKeywords(String category, String itemName, String itemDescription) {
  final keywords = kItemCategoryKeywords[category] ?? const [];
  final haystack = '$itemName $itemDescription'.toLowerCase();
  return keywords.any((k) => haystack.contains(k));
}