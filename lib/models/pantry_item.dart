import 'package:flutter/material.dart';

class PantryItem {
  
  // Name of the item (ie. chicken breast)
  final String name;
  // Weight in grams or quantity as a number, depends on isQuantity
  final double quantity;
  // Is this a weight or is this a quantity (number) of items?
  final bool isQuantity;
  // The predicted expiry date
  final DateTime expiry;
  // The date it was added
  final DateTime added;
  // The predicted best before date
  final DateTime? bestBefore;

  const PantryItem({required this.name, required this.quantity, required this.expiry, required this.isQuantity, required this.added, this.bestBefore});

  // Returns true iff this pantry item has expired according to the expiry date set.
  bool isExpired() {
    return expiry.compareTo(DateTime.now()) <= 0;
  }

  // Format the expiry from a DateTime object to a neat representation (ie. Aug 23, Mar 19)
  String displayExpiry() {
    var month = expiry.month;
    var trunc = "";

    switch(month) {
      case 1:
      trunc = "Jan";
      case 2:
      trunc = "Feb";
      case 3:
      trunc = "Mar";
      case 4:
      trunc = "Apr";
      case 5:
      trunc = "May";
      case 6:
      trunc = "Jun";
      case 7:
      trunc = "Jul";
      case 8:
      trunc = "Aug";
      case 9:
      trunc = "Sep";
      case 10:
      trunc = "Oct";
      case 11:
      trunc = "Nov";
      case 12:
      trunc = "Dec";
    }

    return "$trunc ${expiry.day}";
  }

  // Returns a color code based on how soon the food will expire:
  // Based on a percentage of time from when the food was added (added) to expires (expiry).
  // 50% = yellow, 75% = amber and 90% for red
  Color colorCodeExpiry() {
    // Total days from added to expiry
    var total = expiry.difference(added);
    // Get the days since added
    var since = DateTime.now().difference(added);

    double delta = since.inDays / total.inDays;

    if(delta < 0.5) {
      return Colors.white;
    }
    else if(delta < 0.75) {
      return Colors.yellow;
    }
    else if(delta < 0.9) {
      return Colors.amber;
    }
    else {
      return Colors.red;
    }
  }
}