// Defines the model for an item we can add to our shopping list and check off

class ShoppingItem {
  
  String _name;
  set name(String value) {
    assert(value.isNotEmpty, "Items must be given a name when they are added to a shopping list!");
    _name = value;
  }
  String get name => _name;

  int _quantity = 1;
  set quantity(int value) {
    assert (!value.isNegative, "Cannot have an item with a negative quantity!");
    _quantity = value;
  }
  int get quantity => _quantity;

  bool _isCompleted = false; // any newly created item should start as incomplete

  ShoppingItem(String name, int quantity)
      : _name = name, 
        _quantity = quantity;

  bool isCompleted() => _isCompleted;
  void toggleCompletion() {
    _isCompleted = !_isCompleted;
  }
}