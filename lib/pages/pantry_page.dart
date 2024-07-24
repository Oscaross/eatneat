import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/screens/add_pantry_item.dart';
import 'package:namer_app/screens/edit_pantry_item.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';

class PantryPage extends StatelessWidget {
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

          if(pantryProvider.items.isEmpty) {
            return Text(
              "No items to display! Click the + to add your first item...",
              textAlign: TextAlign.center,
              );
          }
          return ListView.builder(
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    Chip(
                      avatar: Icon(Icons.timer, color: Colors.black),
                      label: Text(
                        item.formatExpiryTime(),
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: item.colorCodeExpiry(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
