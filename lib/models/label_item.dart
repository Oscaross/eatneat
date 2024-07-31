import 'package:flutter/material.dart';

class LabelItem {

  String name;
  Color color;
  // Determines whether the button is showing its contents to the user or not
  bool isShowing = false;

  LabelItem({required this.name, required this.color});

  void show() {
    isShowing = true;
  }

  void hide() {
    isShowing = false;
  }

  // Generates the styling required to render the button with the correct color, background and styling on the pantry page.
  ButtonStyle generateButtonStyle() {
    return ButtonStyle(
      // If we are showing the button highlight it with opacity. Otherwise, set the background to be transparent
      backgroundColor: WidgetStatePropertyAll<Color>((isShowing) ? color.withOpacity(0.2) : Colors.transparent),
      foregroundColor: WidgetStatePropertyAll<Color>(color),
      padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0)),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(color: color, width: (isShowing) ? 2 : 1.5),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
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