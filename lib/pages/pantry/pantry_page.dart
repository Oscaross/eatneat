import 'package:flutter/material.dart';
import 'package:namer_app/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:namer_app/pages/pantry/scanner/scan_failure_page.dart';
import 'package:namer_app/pages/pantry/scanner/scanner.dart';
import 'package:namer_app/pages/pantry/widgets/navigation_bar.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/pages/pantry/pantry_add/add_pantry_item.dart';
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
              // Display the search and sorting bx
              Navbar(),
              // Display all of the categories
              Expanded(
                  child: pantryProvider.categories.isEmpty ? Center() : 
                    ListView.builder(
                      itemCount: pantryProvider.categories.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            // Category label
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.08),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.blue,
                                    Colors.blueAccent,
                                  ],
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                pantryProvider.categories[index].name,
                                style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                ),
                              ),
                            ),
                            // List of items which satisfy the category
                            Expanded(
                          child: pantryProvider.filterBy(labelProvider.selectedLabels).isEmpty
                              ? Center(
                                  child: Text(
                                    "No items to display! Click the + to add your first item...",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, 
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                  ),
                                  itemCount: pantryProvider.filterBy(labelProvider.selectedLabels).length,
                                  itemBuilder: (context, index) {
                                    final item = pantryProvider.filterBy(labelProvider.selectedLabels)[index];
                                    return PantryItemCard(item: item);
                                  },
                                ),
                              ),
                          ],
                        );
                      }
                    ),
                )
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