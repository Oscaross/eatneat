import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_category.dart';
import '../models/pantry_item.dart';

class PantryProvider with ChangeNotifier {
  List<PantryItem> _items = [];

  List<PantryItem> get items => _items;

  List<PantryCategory> _categories = [];

  List<PantryCategory> get categories => _categories;

  SortByMode _currentSortingMode = SortByMode.alphabetical;

  List<PantryItem> searchResult = [];

  // Return all items in the pantry that satisfy all of the labels supplied in the set
  List<PantryItem> filterBy(Set<LabelItem> labelSet) {
    // If we have no filters just return everything
    if(labelSet.isEmpty) return items;

    List<PantryItem> ret = List.empty(growable: true);

    for(int i = 0; i < _items.length; i++) {

      var curr = _items[i];

      if(curr.labelSet.containsAll(labelSet)) {
        ret.add(curr);
      }
    }

    return ret;
  }

  // Takes a mode and sorts the pantry by this mode, this function is only called if:
  // a. the user changes the SortByMode
  // b. the list of pantry items is changed
  void sortBy(SortByMode mode) {

    _currentSortingMode = mode;

    switch(mode) {
      case SortByMode.alphabetical:
        items.sort((a, b) => a.name.compareTo(b.name));
      case SortByMode.dateAdded:
      // If a was added before b then return a 1, otherwise return a 0 and this allows for us to sort similarly to the compareTo operator
        items.sort((a, b) => (a.added.isBefore(b.added) ? 1 : 0));
      case SortByMode.expiryDate:
        items.sort((a, b) => (b.expiry.isBefore(a.expiry) ? 1 : 0));
      case SortByMode.weight:
        items.sort((a, b) => b.weight.compareTo(a.weight));
      default: 
        throw ArgumentError("Attempted to sort items by a mode that does not exist?");
    }

    // State has changed so notify the listeners
    notifyListeners();
  }

  // Takes a search term ie. 'tomato' and returns all candidates that contain that string within their title. Used by the search bar to return results
  void searchBy(String searchTerm) {

    if(searchTerm == "") searchResult = items;

    List<PantryItem> ret = List.empty(growable: true);

    for(PantryItem i in items) {
      // Search should not be case sensitive
      if(i.name.toLowerCase().contains(searchTerm)) ret.add(i);
    }
    
    // A successful search query has been performed so trigger an update
    notifyListeners();

    searchResult = ret;
  }

  void addItem(PantryItem item) {
    _items.add(item);
    // We must re-sort the list
    sortBy(_currentSortingMode);
    notifyListeners();
  }

  void removeItem(PantryItem item) {
    _items.remove(item);
    // We must re-sort the list
    sortBy(_currentSortingMode);
    notifyListeners();
  }

  void triggerUpdate() {
    notifyListeners();
  }

  bool isEmpty() {
    return itemCount() == 0;
  }

  int itemCount() {
    return _items.length;
  }
}

enum SortByMode {
  dateAdded, 
  expiryDate,
  alphabetical,
  weight,
}