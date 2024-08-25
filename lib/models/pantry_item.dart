import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';

class PantryItem {
  // Name of the item (ie. chicken breast)
  String name;
  // Weight stored in metric units. 
  double weight;
  // The quantity of the unit, by default this is set to 1.
  int quantity = 1; 
  // If the user tells us the item is expired before we expect it to be expired we should consider it expired
  bool expired = false;
  // The predicted expiry date
  DateTime expiry;
  // The label the user has assigned to the item, null if none
  LabelItem? label;
  // The set of all labels that the user can assign
  Set<LabelItem> labelSet = {};
  // The date it was added
  DateTime added;

  PantryItem({required this.name, required this.weight, required this.expiry, required this.added, required this.quantity, required this.labelSet});

  void setName(String name) {
    this.name = name;
  }

  void setWeight(double weight) {
    this.weight = weight;
  }

  void setExpiry(DateTime expiry) {
    this.expiry = expiry;
  }

  void setQuantity(int quantity) {
    this.quantity = quantity;
  }

  void addLabel(Set<LabelItem> labelsToAdd) {
    labelSet.addAll(labelsToAdd);
  }

  // Returns true iff this pantry item has expired according to the expiry date set, OR if the user has told us the item is expired.
  bool isExpired() {
    return expiry.compareTo(DateTime.now()) <= 0 || expired;
  }

  // Allows the user to 'restock' the item by ammending the expiry date
  void restock(DateTime expiry) {
    expired = false;
    setExpiry(expiry);
    added = DateTime.now();
  }

  // Nicely formats the time until expiry (ie. 1y, 2mo, 3d)
  String formatExpiryTime() {
    var now = DateTime.now();
    // The date time object must be relative to 00:00 local timezone otherwise we will encounter issues
    var daysUntil = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;

    // TODO: Not sure if this is best but "Tomorrow" will almost always overflow our card so there isn't really an alternative...
    if(daysUntil <= 1) return "Soon";

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

  String weightFormatted() {
    if(weight >= 1000) {
      // As kilograms, rounded to only 1 decimal place
      return "${(weight / 1000).toStringAsFixed(1)}kg";
    }

    return "${weight.truncate()}g";
  }
}