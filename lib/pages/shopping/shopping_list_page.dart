import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  final List<PantryCategory> categories;

  ShoppingListPage({required this.categories});

  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {

  static const int spacerFlex = 1;

  late List<PantryCategory> _categories;
  String _listTitle = "New List";

  // TODO: DEBUG VARIABLES
  static final List<ShoppingListItem> debugItems = [ShoppingListItem(name: "Frozen Pizza", quantity: 1), ShoppingListItem(name: "Sweetcorn", quantity: 2), ShoppingListItem(name: "Tinned Tomatoes", quantity: 4)];
  static final PantryCategory canned = PantryCategory(name: "Canned Foods");
  static final PantryCategory chilled = PantryCategory(name: "Chilled Foods");

  // our map of the checklist, contains entries which relate a category from the main pantry to one of our custom item view models items
  final Map<PantryCategory, List<ShoppingListItem>> _shoppingList = {canned : debugItems, chilled : debugItems};

  @override
  void initState() {
    // TODO: Re-implement actual logic for configuration of categories
    // _categories = widget.categories;
    _categories = [canned, chilled];
    

    // initialise mapping with all existing categories

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_listTitle),
      ),
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.bottom, paddingType: PaddingType.large),
            child: Center(
              child: Text("Today - Sept 19 2024", style: Theme.of(context).textTheme.bodySmall)
            ),
          ),
          // Render list of todo items
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) => renderTodoListItems(_categories[index].name, _shoppingList[_categories[index]]!),
            ),
          )
        ]
      ),
    );
  }

  Widget renderTodoListItems(String title, List<ShoppingListItem> items) {
    return Column( 
      children: [
        Container(
          width: double.infinity,
          color: Themes.primaryAccent.withOpacity(0.1),
          child: Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
            child: Text(
              title,
              style: TextStyle(
                color: Themes.primaryAccent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              )
            ),
          ),
        ),
        Padding(
          padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.small),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text("Qty", style: Theme.of(context).textTheme.titleSmall)
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 16,
                child: Text("Item", style: Theme.of(context).textTheme.titleSmall)
              ),
              Spacer(),
              Expanded(
                child: Icon(Icons.check)
              ),
            ]
          )
        ),
        ListView.builder(
          shrinkWrap: true, 
          physics: NeverScrollableScrollPhysics(), 
          itemCount: items.length,
          itemBuilder: (context, index) {
            ShoppingListItem item = items[index];

            return Container(
              // Add a transparent highlight to an entry if it is checked
              color: (item.isChecked) ? Themes.primary.withOpacity(0.04) : Colors.transparent,
              child: Padding(
                padding: SafePadding.getSafePadding(context: context, marginType: MarginType.left, paddingType: PaddingType.medium),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("${item.quantity}x")
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 16,
                      child: Text(item.name)
                    ),
                    Spacer(),
                    Checkbox(
                      value: item.isChecked,
                      onChanged: (val) {
                        setState(() {
                          item.isChecked = val ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ShoppingListItem {
 final String name;
 final int quantity;  
 bool isChecked = false;

 ShoppingListItem({required this.name, required this.quantity});
}