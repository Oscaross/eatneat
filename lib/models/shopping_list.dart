// Model for a shopping list which is a list of shopping items.
// Contains a bunch of util functions for doing shopping related actions, eventually can be interpreted by PantryProvider to automate shopping -> pantry system

import 'package:eatneat/models/shopping_item.dart';

class ShoppingList {

  final Set<ShoppingItem> _itemList = {};
  Set<ShoppingItem> get itemList => _itemList;

  void addItem(ShoppingItem item) {
    _itemList.add(item);
  }

  void removeItem(ShoppingItem item) {
    _itemList.remove(item);
  }

  void clearList() {
    _itemList.removeAll(_itemList);
  }
}