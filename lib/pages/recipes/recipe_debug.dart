import 'package:eatneat/models/recipes/measurements.dart';
import 'package:eatneat/models/recipes/recipe.dart';
import 'package:eatneat/models/recipes/recipe_ingredient.dart';

// TODO: Say the recipe says "1-2 tablespoons", how are you going to deal with that?

class RecipeDebugger {
  static Recipe generateExampleRecipe() {
    Recipe thaiRedCurry = Recipe(createdTimestamp: DateTime.now(), name: "Thai-style chicken curry", servings: 4);
    // make ingredients
    RecipeIngredient chicken = RecipeIngredient(name: "Boneless chicken thigh", amount: Measurement(type: Measurements.weightMetric, quantity: 450));
    RecipeIngredient coconutMilk = RecipeIngredient(name: "Coconut milk", amount: Measurement(type: Measurements.volume, quantity: 400));
    RecipeIngredient paste = RecipeIngredient(name: "Thai red paste", amount: Measurement(type: Measurements.tbsp, quantity: 1.5));
    RecipeIngredient springOnion = RecipeIngredient(name: "Spring onions", amount: Measurement(type: Measurements.tbsp, quantity: 3));

    thaiRedCurry.addIngredient(chicken);
    thaiRedCurry.addIngredient(coconutMilk);
    thaiRedCurry.addIngredient(paste);
    thaiRedCurry.addIngredient(springOnion);

    thaiRedCurry.instructions.add("Cut the chicken into cubes");
    thaiRedCurry.instructions.add("In a wok, combine the coconut milk, curry paste, spring onions, ginger, rice wine or sherry, fish sauce or soy sauce");
    thaiRedCurry.instructions.add("Add the chicken, immediately cover and leave to simmer for 15 mins");
    thaiRedCurry.instructions.add("Turn onto a warm platter, garnish and serve with rice");

    return thaiRedCurry;
  }
}