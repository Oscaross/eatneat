import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/pages/pantry/pantry_item_card.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/screens/pantry/add_pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:namer_app/screens/pantry/edit_pantry_item.dart';
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
                          });
                        },
                        // If we are in long press mode we should be editing the label
                        onLongPress: () {
                          final String? option;
                        },
                        style: label.generateButtonStyle(),
                        child: Text(label.getName()),
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
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, 
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: pantryProvider.filterBy(_selectedLabel).length,
                        itemBuilder: (context, index) {
                          final item = pantryProvider.filterBy(_selectedLabel)[index];
                          return PantryItemCard(item: item);
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
}