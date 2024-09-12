import 'package:eatneat/models/pantry_item.dart';

// For example, a category named 'Tinned foods' that has 3 instances of PantryItem: "Kidney bean", "Chickpea", "Tomato soup"

class PantryCategory {

  static final PantryCategory none = PantryCategory(name: "None");
  // Very subject to change list of default blanket categories that the app should come pre-built with.
  static final Set<String> defaultCategories = {"Breakfast & Cereals", "Biscuits & Snacks", "Breads & Wraps", "Baking & Dessert", "Tinned & Jarred", "Condiments & Spreads", "Pasta, Rice & Grains", "Instant & Ready Meals", "Tea, Coffee & Beverages", "World Foods", "Health & Special Diet", "Herbs & Spices", "Cooking Essentials"};

  // A set containing all PantryItems that belong to this category
  List<PantryItem> _items = List.empty(growable: true);

  // The name of the category
  String name;
  // The number of items contained within it
  int _count = 0;

  // Does the user want to see the items contained within this on the screen?
  bool _isHidden = false;
  bool get isHidden => _isHidden;

  // What page out of the items is the user currently viewing
  int pageIndex = 0;

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

  List<PantryItem> getPantryItems(String? searchTerm) {
    if(searchTerm == null) return _items;

    List<PantryItem> ret = [];

    for(PantryItem i in _items) {
      if(i.name.toLowerCase().contains(searchTerm.toLowerCase())) ret.add(i);
    }

    return ret;
  }
}