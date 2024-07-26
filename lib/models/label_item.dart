import 'package:flutter/material.dart';

class LabelItem {

  String name;
  Color color;

  LabelItem({required this.name, required this.color});

  // Generates the styling required to render the button with the correct color, background and styling on the pantry page.
  ButtonStyle generateButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(color.withOpacity(0.1)),
      foregroundColor: WidgetStatePropertyAll<Color>(color),
      padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(color: color, width: 2.0),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
      ),
      elevation: WidgetStatePropertyAll<double>(0.0), // Set elevation to 0 for flat design
    );
  }

  void updateName(String name) {
    this.name = name;
  }

  void updateColor(Color color) {
    this.color = color;
  }
}