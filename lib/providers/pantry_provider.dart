import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry/pantry_category.dart';
import '../models/pantry/pantry_item.dart';

class PantryProvider with ChangeNotifier {

  List<PantryItem> _items = [];
  List<PantryItem> get items => _items;

  List<PantryCategory> _categories = [];
  List<PantryCategory> get categories => (_isSearching) ? _categoriesInSearch : _categories;

  // Search management:

  List<PantryCategory> _categoriesInSearch = [];

  // Is the user using the search bar? This will change the data we send them,
  bool _isSearching = false;

  void searchBy(String searchTerm) {
    _isSearching = true;

    if(searchTerm == "") _categoriesInSearch = categories;

    List<PantryCategory> ret = List.empty(growable: true);

    for(PantryCategory c in categories) {
      // Search should not be case sensitive
      if(c.name.toLowerCase().contains(searchTerm)) ret.add(c);
    }
    
    // A successful search query has been performed so trigger an update
    notifyListeners();

    _categoriesInSearch = ret;
  }
  
  void stopSearching() {
    _isSearching = false;
    notifyListeners();
  }

  void addItem(PantryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(PantryItem item) {
    _items.remove(item);
    item.category.removeFromCategory(item);
    notifyListeners();
  }

  void triggerUpdate() {
    notifyListeners();
  }

  void setCategory(PantryCategory category, PantryItem item) {
    category.setCategory(item);
    notifyListeners();
  }

  List<PantryItem> searchByTerm(String term) {
    List<PantryItem> ret = [];

    for(PantryItem i in _items) {
      if(i.name.toLowerCase().contains(term)) ret.add(i);
    }

    return ret;
  }

  /// Checks whether the item instantiated is valid to enter the pantry
  static bool isValidEntry(PantryItem item) {

    if(item.quantity < 1) return false;
    if(item.category == PantryCategory.none) return false;

    return true;
  }
}