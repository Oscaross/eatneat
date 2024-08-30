import 'package:namer_app/models/pantry_item.dart';

// For example, a category named 'Tinned foods' that has 3 instances of PantryItem: "Kidney bean", "Chickpea", "Tomato soup"

class PantryCategory {

  static final PantryCategory none = PantryCategory(name: "None");

  // A set containing all PantryItems that belong to this category
  List<PantryItem> _items = List.empty(growable: true);
  List<PantryItem> get items => _items;
  // The name of the category
  String name;
  // The number of items contained within it
  int _count = 0;

  // Does the user want to see the items contained within this on the screen?
  bool _isHidden = false;
  bool get isHidden => _isHidden;

  int get itemCount => _count;

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

  void toggleVisibility() {
    _isHidden = !_isHidden;
  }
}