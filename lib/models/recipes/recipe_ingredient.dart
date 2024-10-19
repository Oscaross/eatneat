import 'package:eatneat/models/recipes/measurements.dart';

class RecipeIngredient {
  final String name;
  final Measurement amount;

  RecipeIngredient({required this.name, required this.amount});
}