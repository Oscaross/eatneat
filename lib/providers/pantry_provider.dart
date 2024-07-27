import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import '../models/pantry_item.dart';

class PantryProvider with ChangeNotifier {
  List<PantryItem> _items = [];

  List<PantryItem> get items => _items;

  // Return all items in the pantry that are labelled with the given label parameter.
  List<PantryItem> filterBy(LabelItem? label) {

    print("Trying to filter labels " + label.toString());

    if(label == null) return List.empty();

    List<PantryItem> ret = List.empty(growable: true);

    for(PantryItem i in items) {
      if(i.label == label) {
        ret.add(i);
        }
    }

    print(ret);

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
    return _items.isEmpty;
  }
}
