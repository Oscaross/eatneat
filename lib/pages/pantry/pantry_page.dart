import 'package:eatneat/ui/magic_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatneat/models/pantry_category.dart';
import 'package:eatneat/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:eatneat/pages/pantry/scanner/scan_failure_page.dart';
import 'package:eatneat/pages/pantry/scanner/scanner.dart';
import 'package:eatneat/pages/pantry/widgets/navigation_bar.dart';
import 'package:eatneat/providers/label_provider.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:eatneat/pages/pantry/pantry_add/item_view_page.dart';
import 'package:eatneat/ui/buttons.dart';
import 'package:eatneat/util/debug.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PantryPage extends StatefulWidget {
  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {

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
              // Display the search and sorting box
              Flexible(
                flex: 2,
                child: Navbar()
              ),
              SizedBox(height: deviceSize.height * 0.02),
              // Display all of the categories
              Flexible(
                flex: 11,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: pantryProvider.categories.length + 1, // need to render the add category button
                        itemBuilder: (context, categoryIndex) {
                          // If this is the final element it's our Add Category button so we need to render that instead
                          if(categoryIndex == pantryProvider.categories.length) {
                            return Center(
                              child: TextButton.icon(
                                  label: Center(
                                    child: Text(
                                      "Add Category",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17
                                      ),
                                    ),
                                  
                                  ),
                                  // TODO: Add category logic
                                  onPressed: () {
                                    
                                  },
                                  style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(deviceSize.width * 0.95, deviceSize.height * 0.02)),
                                    backgroundColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.15)),
                                    overlayColor: WidgetStatePropertyAll(Colors.blueAccent.withOpacity(0.05)),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                                  )
                                ),
                            );
                          }

                          PantryCategory category = pantryProvider.categories[categoryIndex];

                          return Column(
                            children: [
                              // Display category widget
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // The name of the category
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      // Quick click button to collapse/expand the category
                                      Spacer(),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: 
                                        [
                                          Buttons.minorIconButtonStyle(
                                            (category.isHidden) ? Icon(Icons.remove_red_eye_sharp) : Icon(Icons.remove_red_eye_sharp), 
                                            () {
                                              setState(() {
                                                category.toggleVisibility();
                                              });
                                          
                                              HapticFeedback.lightImpact();
                                            }, 
                                            Offset(0, -7)
                                          ),
                                        ]
                                      ),
                                      // Icons to edit the category
                                      Buttons.iconButtonStyle(Icon(Icons.more_horiz), () {}, Offset(0, -5)),
                                    ],
                                  ),
                                ),
                              ),
                              // Display children (PantryItemCard widgets) that belong to each of these categories
                              if(!category.isHidden)
                              SizedBox(
                                // Set the height based on how many objects there are to render. 
                                // more than 2 objects = we use the second row of space then we scroll horizontally, relies on MediaQuery for consistent scaling
                                height: deviceSize.height * ((pantryProvider.categories[categoryIndex].itemCount <= 2) ? 0.25 : 0.5), 
                                child: (category.isHidden) ? null : GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: deviceSize.width,
                                    mainAxisExtent: 210,
                                    mainAxisSpacing: 4, // Spacing between items vertically
                                    crossAxisSpacing: 10, // Spacing between items horizontally
                                  ),
                                  // The number of items to render is the number of PantryItems in the current category of the iteration
                                  itemCount: pantryProvider.categories[categoryIndex].itemCount,
                                  itemBuilder: (context, itemIndex) {
                                    return PantryItemCard(
                                      item: pantryProvider.categories[categoryIndex].items[itemIndex],
                                    );
                                  },
                                ),
                              ),

                              if(!category.isHidden)
                              // Page viewer widget ( . . . )
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  growable: true,
                                  (category.itemCount <= 4) ? 0 : (category.itemCount / 4).ceil(),
                                  (index) {
                                    return Center(
                                      child: IconButton(
                                        icon: Icon(
                                            color: (category.pageIndex == index) ? Colors.blueAccent : const Color.fromARGB(255, 68, 68, 68),
                                            Icons.circle,
                                            size: 13,
                                          ),
                                        onPressed: () {
                                          setState(() {
                                            category.pageIndex = index;
                                            HapticFeedback.selectionClick();
                                          });                 
                                        }
                                      ),
                                    );
                                  }
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
            child: Icon(Icons.plus_one),
            label: "Manually Add",
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => ItemViewPage(),
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

          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Magic Keyboard",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MagicKeyboard(onChanged: (String val) {}))
              );
            }

          ),

          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Barcode scan failure",
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BarcodeScanFailurePage())
              );
            }
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}