import 'package:eatneat/models/pantry_item.dart';
import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/quick_page_scroller.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:eatneat/pages/pantry/scanner/scanner.dart';
import 'package:eatneat/pages/pantry/widgets/navigation_bar.dart';
import 'package:eatneat/providers/label_provider.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:eatneat/pages/pantry/item_view_page.dart';
import 'package:eatneat/util/debug.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PantryPage extends StatefulWidget {
  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {
  
  Map<PantryCategory, ScrollController> _horizontalScrollerMap = <PantryCategory, ScrollController> {};
  String? searchTerm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _horizontalScrollerMap.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pantry"),
        scrolledUnderElevation: 0,
      ),
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding: SafePadding.getSafePadding(context: context, marginType: MarginType.top, paddingType: PaddingType.medium),
                child: SizedBox(
                  height: deviceSize.height * 0.05, 
                  child: Navbar(
                    onChanged: (input) { 
                      setState(() {
                        searchTerm = input;
                      });
                    },
                    onSubmitted: (input) {
                
                    }
                
                  ),
                ),
              ),

              SizedBox(height: deviceSize.height * 0.02),

              // Each category with its respective child items
              Expanded(
                child: ListView.builder(
                  itemCount: pantryProvider.categories.length,
                  itemBuilder: (context, categoryIndex) => buildCategoryBanner(pantryProvider.categories[categoryIndex], deviceSize),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: SpeedDial(
        onOpen: () {
          HapticFeedback.heavyImpact();
        },
        icon: Icons.add,
        iconTheme: IconThemeData(
          weight: 30,
          size: 26,
        ),
        buttonSize: deviceSize * 0.07,
        children: [
          SpeedDialChild(
            child: Icon(Icons.barcode_reader),
            label: "Scan Barcode",
            onTap: () async {
              HapticFeedback.mediumImpact();
              
              await Scanner.scan(context, OriginPage.pantryPage);
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.receipt),
            label: "Scan Receipt",
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => ItemViewPage(actionType: ActionType.add),
                )
              );
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.plus_one),
            label: "Manually Add",
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => ItemViewPage(actionType: ActionType.add),
                )
              );
            }
          ),

          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Create test items",
            onTap: () {
              Debug().configure(Provider.of<PantryProvider>(context, listen:false));
            }
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void openSearchBar() {

  }

  Widget buildCategoryBanner(PantryCategory category, Size deviceSize) {
    List<PantryItem> items = category.getPantryItems(searchTerm);

    // initialise a new scroll controller for this category
    _horizontalScrollerMap.putIfAbsent(category, () => ScrollController());
    
    // null safe because in the line above we've ensured that we have a controller
    ScrollController controller = _horizontalScrollerMap[category]!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 24, // consistently scale height across displays
          decoration: BoxDecoration(
            color: Themes.primaryAccent.withOpacity(0.06),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Themes.primary,
                Themes.primaryAccent,
              ],
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: SafePadding.getSafePadding(context: context, marginType: MarginType.vertical, customMultiplier: 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // The name of the category
                Padding(
                  padding: SafePadding.getSafePadding(context: context, marginType: MarginType.left, paddingType: PaddingType.medium),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Quick click button to collapse/expand the category
                Spacer(),
                IconButton(
                  icon: Icon(Icons.remove_red_eye_sharp),
                  onPressed: () {
                    setState(() {
                      category.toggleVisibility();
                    });
                  },
                  style: Themes.decorateIconButton()
                ),
                // Icons to edit the category
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                
                  },
                  style: Themes.decorateIconButton(),
                ),
              ],
            ),
          ),
        ),

        // If the category should hide it's contents - just render nothing
        (category.isHidden) ? Center() :
        Column( 
          children: [
            SizedBox(
              // Set the height based on how many objects there are to render. 
              // more than 2 objects = we use the second row of space then we scroll horizontally, relies on MediaQuery for consistent scaling
              height: deviceSize.height * ((items.length <= 2) ? 0.25 : 0.5), 
              child: (category.isHidden) ? null : GridView.builder(
                scrollDirection: Axis.horizontal,
                controller: controller,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: deviceSize.width,
                  mainAxisExtent: 210,
                  mainAxisSpacing: 6, 
                  crossAxisSpacing: 6, 
                ),
                // The number of items to render is the number of PantryItems in the current category of the iteration
                itemCount: items.length,
                itemBuilder: (context, itemIndex) {
                  return PantryItemCard(
                    item: items[itemIndex],
                  );
                },
              ),
            ),

            // Page viewer widget ( . . . )
            // TODO: Animate this between a search icon and the page viewer
            QuickPageScroller(
              totalElements: items.length,
              currentPageIndex: 0,
              elementsPerPage: 4,
              onWidgetTap: openSearchBar,
              controller: controller,
              // TODO: Add a constant width to all item cards and query it here 
              pageSize: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ],
    );
  }

  void buildCategoryIconButton(Icon icon) {

  }
}