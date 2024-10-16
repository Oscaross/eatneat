// Internal class to help with debugging. DO NOT SHIP WITH APP!

import 'dart:math';
import 'package:eatneat/models/pantry/pantry_category.dart';
import 'package:eatneat/models/pantry/pantry_item.dart';
import 'package:eatneat/providers/pantry_provider.dart';

class Debug {
  // Helper function to generate random date
  DateTime getRandomDate({int startYear = 2022, int endYear = 2024}) {
    final random = Random();
    int year = startYear + random.nextInt(endYear - startYear + 1);
    int month = random.nextInt(12) + 1;
    int day = random.nextInt(28) + 1; // Keeping it safe with 28 days in any month
    return DateTime(year, month, day);
  }

  // Helper function to generate random weight
  double getRandomWeight() {
    final random = Random();
    bool returnZero = random.nextInt(3) == 0; // 1/3 chance of just a qty being returned
    return (returnZero) ? 0 : (random.nextInt(251) * 5);
  }

  // Helper function to generate random quantity
  int getRandomQuantity() {
    final random = Random();
    return random.nextInt(10) + 1; // Random quantity between 1 and 10
  }

  void configure(PantryProvider provider) {

    PantryCategory.defaultCategories.forEach((category) {
      provider.categories.add(category);
    });

    List<String> pantryItemNames = [
      'Whole Wheat Bread',
      'Apple Juice',
      'Almond Butter',
      'Organic Honey',
      'Canned Beans',
      'Oatmeal',
      'Brown Rice',
      'Frozen Peas',
      'Granola Bars',
      'Chocolate Chip Cookies',
      'Soy Milk',
      'Pasta Sauce',
      'Olive Oil',
      'Flour',
      'Cereal',
      'Tomato Soup',
      'Salted Butter',
      'Eggs',
      'Frozen Pizza',
      'Cheddar Cheese',
      'Peanut Butter',
      'Instant Noodles',
      'Raisins',
      'Chia Seeds',
      'Dried Lentils',
      'Spaghetti',
      'Coconut Oil',
      'Canned Tuna',
      'White Sugar',
      'Brown Sugar',
      'Dried Apricots',
      'Potato Chips',
      'Greek Yogurt',
      'Quinoa',
      'Maple Syrup',
      'Almond Milk',
      'Black Pepper',
      'Cornmeal',
      'Bread Crumbs',
      'Pickles',
      'Ketchup',
      'Mustard',
      'Chicken Stock',
      'Canned Pineapple',
      'Red Kidney Beans',
      'Balsamic Vinegar',
      'Sriracha Sauce',
      'Soy Sauce',
      'Ground Cinnamon',
      'Nutella',
      'Parmesan Cheese',
      'Frozen Spinach',
      'Rice Noodles',
      'Frozen Mixed Berries',
      'Couscous',
      'Powdered Sugar',
      'Instant Coffee',
      'Tea Bags',
      'Canned Tomatoes',
      'Sweet Corn',
      'Cream Cheese',
      'Butter Cookies',
      'Tortilla Chips',
      'Frozen Corn',
      'Vegetable Oil',
      'Pancake Mix',
      'Jelly Beans',
      'Corn Flakes',
      'Salsa',
      'Coconut Water',
      'Vanilla Extract',
      'Bagels',
      'Mozzarella Cheese',
      'Frozen Waffles',
      'Frozen Chicken Nuggets',
      'Canned Salmon',
      'Marinara Sauce',
      'Baking Soda',
      'Frozen Broccoli',
      'Frozen Carrots',
      'Pita Bread',
      'Canned Coconut Milk',
      'Corn Starch',
      'Barbecue Sauce',
      'Canned Chickpeas',
      'Dried Cranberries',
      'Frozen French Fries',
      'Hot Dog Buns',
      'Frozen Fish Fillets',
      'Ground Beef',
      'Whole Milk',
      'Cashew Nuts',
      'Chili Powder',
      'Pita Chips',
      'Frozen Cauliflower Rice',
      'Ground Turkey',
      'Pretzels',
      'Frozen Meatballs',
      'Coconut Flour',
      'Frozen Shrimp',
      'Dried Basil',
      'Garlic Powder',
      'Vegetable Broth',
      'Frozen Blueberries',
      'Mayo',
      'Frozen Edamame',
      'Diced Tomatoes',
      'Zucchini Noodles',
      'Taco Shells'
    ];


    pantryItemNames.forEach((itemName) {
      // Pick a random existing category and add the item to that category
      PantryCategory randomCategory = provider.categories.toList()[Random().nextInt(provider.categories.length)];

      PantryItem item = PantryItem(
        name: itemName,
        weight: getRandomWeight(),
        expiry: getRandomDate(startYear: 2024, endYear: 2026),
        added: DateTime.now(),
        quantity: getRandomQuantity(),
        image: null, // Assuming no image for training data, but can be set if needed
      );

      provider.addItem(item);

      provider.setCategory(randomCategory, item);
    });
  }
}