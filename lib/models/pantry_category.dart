import 'package:namer_app/models/pantry_item.dart';

// For example, a category named 'Tinned foods' that has 3 instances of PantryItem: "Kidney bean", "Chickpea", "Tomato soup"

class PantryCategory {

  // A set containing all PantryItems that belong to this category
  Set<PantryItem> _items = {};
  Set<PantryItem> get items => _items;
  // The name of the category
  String name;
  // The number of items contained within it
  int _count = 0;

  int get count => _count;

  PantryCategory({required this.name});

  void addToCategory(PantryItem item) {
    if(!_items.contains(item)) {
      _items.add(item);
      _count++;
    }
  }

  void removeFromCategory(PantryItem item) {
    if(_items.contains(item)) {
      _items.remove(item);
      _count--;
    }
  }

  void setName(String name) {
    this.name = name;
  }
}