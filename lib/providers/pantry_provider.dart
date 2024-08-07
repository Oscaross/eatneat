import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import '../models/pantry_item.dart';

class PantryProvider with ChangeNotifier {
  List<PantryItem> _items = [];

  List<PantryItem> get items => _items;

  // Return all items in the pantry that satisfy all of the labels supplied in the set
  List<PantryItem> filterBy(Set<LabelItem> labelSet) {

    if(labelSet.isEmpty) return List.empty();

    List<PantryItem> ret = List.empty(growable: true);

    for(int i = 0; i < _items.length; i++) {

      var curr = _items[i];
      bool valid = true;

      for(int ii = 0; ii < labelSet.length; ii++) {
        // If the label in the set doesn't match then we need to move onto the next pantry item as this one doesn't satisfy the criteria
        if(curr.label != labelSet.elementAt(ii)) {
          valid = false;
          break;
        }
      }

      if(valid) ret.add(curr);
    }

    return ret;
  }

  void addItem(PantryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(PantryItem item) {
    _items.remove(item);
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
