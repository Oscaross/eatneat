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
          return pantryProvider.items.isEmpty
              ? Center(
                  child: Text(
                    "No ingredients yet! Click the plus to add one.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: pantryProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = pantryProvider.items[index];
                    return ListTile(
                      leading: Icon(Icons.fastfood_outlined),
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}, Expiry Date: ${item.expiry.toLocal()}'),
                      trailing: item.isExpired() ? Icon(Icons.warning, color: Colors.red) : null,
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
        child: Icon(Icons.add),
        tooltip: 'Add Item',
        elevation: 5.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
