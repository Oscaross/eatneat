import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:namer_app/screens/pantry/edit_pantry_item.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';

class PantryPage extends StatelessWidget {
  static const ButtonStyle labelStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.blueAccent),
    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    ),
    side: WidgetStatePropertyAll<BorderSide>(
      BorderSide(color: Colors.blueAccent, width: 2.0),
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(
      TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    elevation: WidgetStatePropertyAll<double>(0.0), // Set elevation to 0 for flat design
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('My Pantry'),
          ],
        ),
      ),
      body: Consumer<PantryProvider>(
        builder: (context, pantryProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  child: Text("Add Label"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(pageBuilder:(context, animation, secondaryAnimation) => AddLabelPage(),)
                    );
                  },
                  style: labelStyle,
                )
              ),
              Expanded(
                child: pantryProvider.items.isEmpty
                    ? Center(
                        child: Text(
                          "No items to display! Click the + to add your first item...",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: pantryProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = pantryProvider.items[index];

                          return ListTile(
                            leading: Icon(Icons.fastfood_outlined),
                            title: Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                    "${item.quantity} ${(item.isQuantity) ? "units" : "grams"}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                Chip(
                                  avatar: Icon(Icons.timer, color: Colors.black),
                                  label: Text(
                                    item.formatExpiryTime(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: item.colorCodeExpiry(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == 'Edit') {
                                  // Edit item logic
                                  _editItem(context, item);
                                } else if (value == 'Delete') {
                                  // Delete item logic
                                  _deleteItem(context, pantryProvider, item);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          );
        },
        tooltip: 'Add Item',
        elevation: 5.0,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _editItem(BuildContext context, PantryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemPage(item: item)),
    );
  }

  void _deleteItem(BuildContext context, PantryProvider provider, PantryItem item) {
    provider.removeItem(item);
  }
}