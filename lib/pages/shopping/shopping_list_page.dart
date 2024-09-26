import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:eatneat/util/date.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  final List<PantryCategory> categories;

  ShoppingListPage({required this.categories});

  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {

  // TODO: Change this to use an actual timestamp
  static final DateTime _timestamp = DateTime.now();
  static const int spacerFlex = 1;

  late List<PantryCategory> _categories;

  // TODO: DEBUG VARIABLES
  static final List<ShoppingListItem> debugItems = [ShoppingListItem(name: "Frozen Pizza", quantity: 1), ShoppingListItem(name: "Sweetcorn", quantity: 2), ShoppingListItem(name: "Tinned Tomatoes", quantity: 4)];
  static final PantryCategory canned = PantryCategory(name: "Canned Foods");
  static final PantryCategory chilled = PantryCategory(name: "Chilled Foods");

  // our map of the checklist, contains entries which relate a category from the main pantry to one of our custom item view models items
  final Map<PantryCategory, List<ShoppingListItem>> _shoppingList = {canned : debugItems, chilled : debugItems};

  // initialise a new editing controller to start with 'New List' when the user first creates a list
  final TextEditingController _listNameController = TextEditingController(text: "New List");

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
        actions: [],
        foregroundColor: Themes.background,
        title: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          controller: _listNameController,
        ),
      ),
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.vertical, paddingType: PaddingType.large),
            child: Center(
              child: Text("${DateUtil.representDateAsMonthDateYear(_timestamp)} - ${DateUtil.representHowOld(_timestamp)} ago", style: Theme.of(context).textTheme.bodySmall)
            ),
          ),
          // render the shopping list itself
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) => renderOneList(_categories[index].name, _shoppingList[_categories[index]]!),
            ),
          ),
          Expanded(
            child: drawButtons(),
          ),
        ]
      ),
    );
  }

  Widget renderOneList(String title, List<ShoppingListItem> items) {
    return Column( 
      children: [
        buildCategoryBanner(title),
        buildCategoryContents(items),
      ],
    );
  }

  Widget buildCategoryBanner(String title) {
    return Container(
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
      );
  }

  Widget buildCategoryContents(List<ShoppingListItem> items) {
    return Padding(
      padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.medium),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: <int, TableColumnWidth> {
          0 : FlexColumnWidth(4),
          1 : FlexColumnWidth(23),
          2 : FlexColumnWidth(2),
        },
        children: <TableRow>[
          // render guidance text (qty, name and checkmark)
          TableRow(
            children: <Widget> [
              Text("Qty", style: Theme.of(context).textTheme.titleSmall),
              Text("Item", style: Theme.of(context).textTheme.titleSmall),
              Icon(Icons.check)
            ]
          ),

          // render actual items in list
          for(final item in items) TableRow(
            decoration: BoxDecoration(
              color: item.isChecked ? Themes.primary.withOpacity(0.06) : Colors.transparent,
            ),
            children: <Widget> [
              Text("${item.quantity}x"),
              Text(item.name),
              Checkbox(
                value: item.isChecked,
                // make the checkbox the primary accent color if we check it, otherwise, make it the scaffold background color and be unselected
                checkColor: Colors.white,
                fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Themes.primaryAccent : Themes.background),
                onChanged: (val) {
                  setState(() {
                    item.isChecked = val ?? false;
                  });
                },
              ),
            ]
          )
        ],
      ),
    );
  }

  Widget drawButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        FilledButton.icon(
          icon: Icon(Icons.check),
          onPressed: () {},
          label: Text("Finished"),
          style: FilledButton.styleFrom(
            fixedSize: Themes.getFullWidthButtonSize(context),
          )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        FilledButton.icon(
          icon: Icon(Icons.close),
          onPressed: () {},
          label: Text("Cancel List"),
          style: Themes.filledButtonCancelStyle(context),
        )
      ]
    );
  }
}

class ShoppingListItem {
 final String name;
 final int quantity;  
 bool isChecked = false;

 ShoppingListItem({required this.name, required this.quantity});
}