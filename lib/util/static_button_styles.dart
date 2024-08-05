import 'package:flutter/material.dart';

class StaticButtonStyles {

  // pantry_item_card.dart -> "Delete Button" on long press
  static ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
    fixedSize: Size(160, 10),
    foregroundColor: Colors.red, // Background color
    iconColor: Colors.black, // Text color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50), // Rounded corners
    ),
    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2), // Padding
);
}