import 'package:eatneat/models/recipes/recipe.dart';
import 'package:eatneat/models/recipes/recipe_ingredient.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CookRecipePage extends StatefulWidget {
  final Recipe recipe;

  CookRecipePage({required this.recipe});

  @override 
  CookRecipePageState createState() => CookRecipePageState();
}

class CookRecipePageState extends State<CookRecipePage> {

  late Recipe recipe;
  // default to showing the ingredients in the recipe
  DisplayableContent contentToDisplay = DisplayableContent.ingredients;

  @override
  void initState() {
    recipe = widget.recipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              Text(
                recipe.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // number of servings in the recipe
                  buildIconAndText(Icons.person, recipe.servings.toString()),
                  // how long since we clicked 'start cooking'
                  buildIconAndText(Icons.timer, "20s"),
                  // how many instructions complete / how many total
                  buildIconAndText(Icons.text_snippet, "2/5"),
                  // how many ingredients prepped / how many total
                  buildIconAndText(Icons.shopping_cart, "3/7"),
                ],
              ),
            ]
          ),
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    HapticFeedback.mediumImpact();
                    contentToDisplay = DisplayableContent.ingredients;
                  }),
                  style: Themes.decorateTextButton(contentToDisplay == DisplayableContent.ingredients ? ButtonType.standout : ButtonType.subtle),
                  label: Text("Ingredients"),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => setState(() {
                    HapticFeedback.mediumImpact();
                    contentToDisplay = DisplayableContent.instructions;
                  }),
                  style: Themes.decorateTextButton(contentToDisplay == DisplayableContent.instructions ? ButtonType.standout : ButtonType.subtle),
                  child: Text("Instructions"),
                ),
              ]
            ),
          ),

          buildMainContent(),
        ]
      )
    );
  }

  Widget buildMainContent() {
    return switch(contentToDisplay) {
      DisplayableContent.ingredients => buildIngredientsInfo(),
      DisplayableContent.instructions => buildInstructionsInfo()
    };
  }

  Widget buildIngredientsInfo() {
    List<RecipeIngredient> ingredients = recipe.ingredients;

    return Expanded(
      child: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return Text(ingredients[index].name);
        }
      )
    );
  }

  Widget buildInstructionsInfo() {
    List<String> instructions = recipe.instructions;

    return Expanded(
      child: ListView.builder(
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return Text("${index + 1}. ${instructions[index]}");
        }
      )
    );
  }

  Widget buildIconAndText(IconData icon, String data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22
          ),
          SizedBox(width: 2),
          Text(
            data,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]
      ),
    );
  }
}

enum DisplayableContent {
  instructions,
  ingredients
}