class PantryItem {
  
  // Name of the item (ie. chicken breast)
  final String name;
  // Weight in grams or quantity as a number, depends on isQuantity
  final double quantity;
  // Is this a weight or is this a quantity (number) of items?
  final bool isQuantity;
  // The predicted expiry date
  final DateTime expiry;
  // The predicted best before date
  final DateTime? bestBefore;

  const PantryItem({required this.name, required this.quantity, required this.expiry, required this.isQuantity, this.bestBefore});

  // Returns true iff this pantry item has expired according to the expiry date set.
  bool isExpired() {
    return expiry.compareTo(DateTime.now()) <= 0;
  }
}