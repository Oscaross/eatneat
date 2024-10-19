import 'package:eatneat/pages/recipes/cook_recipe_page.dart';
import 'package:eatneat/pages/recipes/recipe_debug.dart';
import 'package:eatneat/ui/swipable_ui_element.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  @override 
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  // TODO: Make recipe page UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              SwipableUIElement(page: CookRecipePage(recipe: RecipeDebugger.generateExampleRecipe()))
            );
          },
          child: Text("Example Recipe"),
        )
      )
    );
  }

}