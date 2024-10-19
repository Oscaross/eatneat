import 'package:eatneat/models/recipes/recipe_ingredient.dart';

class Recipe {

  final DateTime createdTimestamp;
  final String name;
  final int servings;
  final List<RecipeIngredient> ingredients = [];
  final List<String> instructions = [];

  Recipe({required this.createdTimestamp, required this.name, required this.servings});

  void addIngredient(RecipeIngredient ingredient) {
    ingredients.add(ingredient);
  }

  void removeIngredient(RecipeIngredient ingredient) {
    ingredients.remove(ingredient);
  }
  
}