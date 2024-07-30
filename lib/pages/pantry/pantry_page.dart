import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/screens/pantry/add_pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:namer_app/screens/pantry/edit_pantry_item.dart';
import 'package:namer_app/util/shake.dart';
import 'package:provider/provider.dart';


class PantryPage extends StatefulWidget {
  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  // The label that we want to display
  LabelItem? _selectedLabel;

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
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => AddLabelPage(),
                          ),
                        );
                      },
                      style: labelProvider.addButtonStyle,
                      child: Text("+"),
                    ),
                    ...labelProvider.labels.map((label) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if(_selectedLabel != null) {
                              _selectedLabel!.hide();
                            }
                            _selectedLabel = label;
                            _selectedLabel!.show();

                            Shaker.vibrate(20);
                          });
                        },
                        style: label.generateButtonStyle(),
                        child: Text(label.name),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Expanded(
                child: pantryProvider.filterBy(_selectedLabel).isEmpty
                    ? Center(
                        child: Text(
                          "No items to display! Click the + to add your first item...",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: pantryProvider.filterBy(_selectedLabel).length,
                        itemBuilder: (context, index) {
                          final item = pantryProvider.filterBy(_selectedLabel)[index];

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
