import 'package:flutter/material.dart';

class PantryItem {
  // Name of the item (ie. chicken breast)
  String name;
  // Weight in grams or quantity as a number, depends on isQuantity
  double quantity;
  // Is this a weight or is this a quantity (number) of items?
  bool isQuantity;
  // The predicted expiry date
  DateTime expiry;
  // The date it was added
  final DateTime added;

  PantryItem({required this.name, required this.quantity, required this.expiry, required this.isQuantity, required this.added});

  void setName(String name) {
    this.name = name;
  }

  void setQuantity(double quantity) {
    this.quantity = quantity;
  }

  void setIsQuantity(bool isQuantity) {
    this.isQuantity = isQuantity;
  }

  void setExpiry(DateTime expiry) {
    this.expiry = expiry;
  }

  // Returns true iff this pantry item has expired according to the expiry date set.
  bool isExpired() {
    return expiry.compareTo(DateTime.now()) <= 0;
  }

  // Nicely formats the time until expiry (ie. 1y, 2mo, 3d)
  String formatExpiryTime() {
    var now = DateTime.now();
    // The date time object must be relative to 00:00 local timezone otherwise we will encounter issues
    var daysUntil = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;

    if(daysUntil == 1) return "Tomorrow";
    if(daysUntil == 0) return "Today";

    if(daysUntil > 365) {
      int years = (daysUntil / 365).floor();
      return "${years}y";
    } else if(daysUntil > 30) {
      int months = (daysUntil / 30).floor();
      return "${months}mo";
    } else {
      return "${daysUntil}d";
    }
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

    // The number of days from now until when the product is set to expire
    var daysUntil = expiry.difference(DateTime.now()).inDays;

    // If there are more than 365 days until the product expires it should also show the year it will expire in
    return (daysUntil < 365) ? "$trunc ${expiry.day}" : "$trunc ${expiry.day} ${expiry.year}";
  }

  // Returns a color code based on how soon the food will expire:
  // Based on a percentage of time from when the food was added (added) to expires (expiry).
  // 50% = yellow, 75% = amber and 90% for red
  Color colorCodeExpiry(BuildContext context) {
    // Total days from added to expiry
    var total = expiry.difference(added);
    // Get the days since added
    var since = DateTime.now().difference(added);

    double delta = since.inDays / total.inDays;

    if(delta < 0.5) {
      return Theme.of(context).scaffoldBackgroundColor;
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