import 'dart:async';

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
  // how long since the session was started
  final Stopwatch timer = Stopwatch();
  // when to update UI
  late Timer timerChanged;
  // UI element to represent timer
  final ValueNotifier<String> timerRepresented = ValueNotifier("0s");

  final Map<RecipeIngredient, bool> completedIngredients = {};
  int completedIngredientCount = 0;
  final Map<String, bool> completedInstructions = {};
  int completedInstructionCount = 0;

  // default to showing the ingredients in the recipe
  DisplayableContent contentToDisplay = DisplayableContent.ingredients;

  @override
  void initState() {
    recipe = widget.recipe;
    // start timer
    timer.start();
    // to avoid thousands of set state calls when the timer is timing milliseconds, every 1 second that elapses we rebuild the UI to show the stopwatch tick
    timerChanged = Timer(Duration(seconds: 1), reflectChangeInTimer);

    // initialise the map to keep track of which ingredients are prepped & which instructions are complete
    for(RecipeIngredient i in recipe.ingredients) {
      completedIngredients[i] = false;
    }

    for(String i in recipe.instructions) {
      completedInstructions[i] = false;
    }

    super.initState();
  }

  void reflectChangeInTimer() {
    // if the widget is no longer mounted in the tree, we can't have this callback or a memory leak will occur so exit the cycle
    if(!mounted) return;

    timerRepresented.value = representTimer();
    timerChanged = Timer(Duration(seconds: 1), reflectChangeInTimer);
  }

  @override
  void dispose() {
    timer.stop();
    timerRepresented.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.expand_more_sharp, size: 28),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)
                ),
              ),
              Spacer(),
              Column(
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
                      buildIconAndText(Icons.shopping_cart, "$completedIngredientCount/${completedIngredients.length}"),
                    ],
                  ),
                ]
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)
                ),
              )
            ],
          ),
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ValueListenableBuilder<String>(
              valueListenable: timerRepresented,
              builder: (context, val, child) {
                return Text(val);
              },

            )
          ),
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

          buildActionButtons(),
        ]
      )
    );
  }

  Widget buildActionButtons() {
    return Column(
      children: [
        FilledButton.icon(
          icon: Icon(Icons.check),
          label: Text("Finish Cooking"),
          onPressed: () {

          },
          style: FilledButton.styleFrom(
            fixedSize: Themes.getFullWidthButtonSize(context),
          )
        ),
        FilledButton.icon(
          icon: Icon(Icons.close),
          label: Text("Cancel"),
          onPressed: () {

          },
          style: Themes.filledButtonCancelStyle(context),
        )

      ]
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

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Table(
      columnWidths: {
        0: FlexColumnWidth(60),
        1: FlexColumnWidth(30),
        2: FlexColumnWidth(10),
      },
      children: [
        // Guidance text for each field (ingredient name, quantity, and whether it's prepped or not)
        TableRow(
          children: [
            Text("Ingredient", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            Text("Quantity", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            Center(child: Icon(Icons.check)),
          ],
        ),
        // The actual ingredients
        for (RecipeIngredient i in ingredients)
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(child: Text(i.name)),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(child: Text(i.amount.formatMeasurement())),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Checkbox(
                    value: completedIngredients[i],
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        completedIngredientCount += (val!) ? 1 : -1;
                        completedIngredients[i] = val;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

  String representTimer() {
    int elapsed = timer.elapsed.inSeconds;

    if (elapsed < 60) {
      return "${elapsed}s";
    }
    else if (elapsed < 3600) {
      int secs = elapsed % 60;
      int mins = (elapsed / 60).floor();

      return "${mins}m ${secs}s";
    }
    else if (elapsed < 86400) {
      int secs = elapsed % 60;
      int mins = (elapsed / 60).floor() % 60;
      int hours = (elapsed / 3600).floor();

      return "${hours}h ${mins}m ${secs}s";
    }
    else {
      int secs = elapsed % 604800;
      int mins = (elapsed / 60).floor();
      int hours = (elapsed / 3600).floor();
      int days = (elapsed / 604800).floor();

      return "${days}d ${hours}h ${mins}m ${secs}s";
    }
    // if they are taking any longer than a week to cook a single meal - they should probably just hang up their apron
  }
}

enum DisplayableContent {
  instructions,
  ingredients
}