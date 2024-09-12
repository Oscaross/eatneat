import 'package:eatneat/models/pantry_item.dart';
import 'package:eatneat/ui/padding.dart';
import 'package:eatneat/ui/quick_page_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:eatneat/pages/pantry/scanner/scanner.dart';
import 'package:eatneat/pages/pantry/widgets/navigation_bar.dart';
import 'package:eatneat/providers/label_provider.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:eatneat/pages/pantry/pantry_add/item_view_page.dart';
import 'package:eatneat/util/debug.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PantryPage extends StatefulWidget {
  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {
  
  String? searchTerm;

  @override
  Widget build(BuildContext context) {

    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pantry"),
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
      ),
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          return Column(
            children: [
              // Search bar
              SizedBox(
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
        backgroundColor: Colors.blue.withOpacity(0.9),
        foregroundColor: Colors.white,
        buttonSize: Size(60, 60),
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
              Debug().configure(Provider.of<PantryProvider>(context, listen:false), Provider.of<LabelProvider>(context, listen:false));
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 24, // consistently scale height across displays
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.06),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                const Color.fromARGB(255, 46, 154, 243),
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
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.grey[700]),
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[300]!.withOpacity(0.25)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                    )),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: Colors.grey[700]!,
                      width: 2,
                    )),
                    alignment: Alignment.center,
                    padding: WidgetStatePropertyAll(EdgeInsets.only(top: 2)),
                  )
                ),
                // Icons to edit the category
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.blue),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[400]!.withOpacity(0.25)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                    )),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: Colors.blue[400]!,
                      width: 2,
                    )),
                    alignment: Alignment.center,
                    padding: WidgetStatePropertyAll(EdgeInsets.only(top: 4)),
                  )
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
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: deviceSize.width,
                  mainAxisExtent: 210,
                  mainAxisSpacing: 4, // Spacing between items vertically
                  crossAxisSpacing: 10, // Spacing between items horizontally
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
            QuickPageScroller(totalElements: items.length, currentPageIndex: 0, elementsPerPage: 4, onWidgetTap: openSearchBar),
          ],
        ),
      ],
    );
  }

  void buildCategoryIconButton(Icon icon) {

  }
}