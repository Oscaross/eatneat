import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry/pantry_category.dart';

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
  // The date it was added
  DateTime added;
  // A URL that shows the image of the product
  String? image;
  // The item's category
  PantryCategory category = PantryCategory.none;
  // How much of the item as a percentage do we have left
  double _percentageLeft = 100;
  double get percentageLeft => _percentageLeft;

  set percentageLeft(double percentageLeft) {
    if(percentageLeft < 0 || percentageLeft > 100) throw FormatException("PantryItem cannot have more than 100% left or less than 0% left!");

    _percentageLeft = percentageLeft;
  }

  PantryItem({required this.name, required this.weight, required this.expiry, required this.added, required this.quantity, this.image});

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

  void setCategory(PantryCategory category) {
    this.category = category;
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

    var ret = "";

    if(daysUntil <= 1 && daysUntil >= 0) {
      ret = "Soon";
    }
    else {
      if(daysUntil.abs() > 365) {
        int years = (daysUntil / 365).floor();
        ret = "${years}y";
      } 
      else if(daysUntil.abs() > 30) {
        int months = (daysUntil / 30).floor();
        ret = "${months}mo";
      } 
      else {
        ret = "${daysUntil}d";
      }
    }

    if(daysUntil < 0) "-$ret";

    return ret;
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
      return Colors.yellow[600]!;
    }
    else if(delta < 0.9) {
      return Colors.amber;
    }
    else {
      return Colors.redAccent;
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