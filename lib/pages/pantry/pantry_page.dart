import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_category.dart';
import 'package:namer_app/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:namer_app/pages/pantry/scanner/scan_failure_page.dart';
import 'package:namer_app/pages/pantry/scanner/scanner.dart';
import 'package:namer_app/pages/pantry/widgets/navigation_bar.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/pages/pantry/pantry_add/add_pantry_item.dart';
import 'package:namer_app/ui/buttons.dart';
import 'package:namer_app/util/debug.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PantryPage extends StatefulWidget {
  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantry")
      ),
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          return Column(
            children: [
              SizedBox(height: 8),
              // Display the search and sorting box
              Navbar(),
              // Display all of the categories
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: pantryProvider.categories.length,
                        itemBuilder: (context, categoryIndex) {
                          PantryCategory category = pantryProvider.categories[categoryIndex];

                          return Column(
                            children: [
                              // Display category widget
                              Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1),
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
                                      Buttons.iconButtonStyle(
                                        // TODO: I need a button which is remove_red_eye but with a line through it
                                        Icon((category.isHidden) ? Icons.remove_red_eye : Icons.remove_red_eye_sharp), 
                                        () {
                                          setState(() {
                                            category.toggleVisibility();
                                          });
;                                       }, 
                                        Offset(0, -6)
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
                                // This is probably a bad idea but we just set the height based on how many objects there are to render. 
                                // more than 2 objects = we use the second row of space then we scroll horizontally. 
                                height: (pantryProvider.categories[categoryIndex].itemCount <= 2) ? 220 : 440, 
                                child: (category.isHidden) ? null : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  // The number of items to render is the number of PantryItems in the current category of the iteration
                                  itemCount: pantryProvider.categories[categoryIndex].itemCount,
                                  itemBuilder: (context, itemIndex) {
                                    return PantryItemCard(
                                      item: pantryProvider.categories[categoryIndex].items[itemIndex],
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    // Add category button
                    // TODO: This is sat at the bottom and will not join the rest of the items. It's pissing me off
                    Container(
                      width: double.infinity,
                      height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.1),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.blue,
                                    const Color.fromARGB(255, 46, 154, 243),
                                  ],
                                ),
                              ),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Navigate to category creation screen

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width:8),
                            Text(
                              "New Category",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            )
                          ]
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: Icon(Icons.barcode_reader),
            label: "Scan Barcode",
            onTap: () async {
              
              await Scanner.scan(context, OriginPage.pantryPage);
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.plus_one),
            label: "Manually Add",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => AddItemPage(),
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