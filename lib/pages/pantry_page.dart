import 'package:flutter/material.dart';
import 'package:namer_app/screens/add_pantry_item.dart';
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
                      label: Text(
                        item.displayExpiry(),
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: item.colorCodeExpiry(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ],
                ),
                trailing: item.isExpired()
                    ? Icon(Icons.warning, color: Colors.red)
                    : null,
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
}
