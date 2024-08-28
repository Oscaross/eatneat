import 'package:flutter/material.dart';

class Buttons {

  static ButtonStyle confirmButtonStyle() {
    return ButtonStyle();
  }

  static ButtonStyle cancelButtonStyle() {
    return ButtonStyle();
  }

  static ButtonStyle genericButtonStyle(double opacityFactor) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.blueAccent.withOpacity(opacityFactor)),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      elevation: WidgetStatePropertyAll(3),
      side: WidgetStatePropertyAll(BorderSide(
        color: const Color.fromARGB(255, 58, 128, 249),
        width: 0.3,
      )),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0), // Adjust this value to make the edges less circular
      )),
      textStyle: WidgetStatePropertyAll(TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ))
    );
  }
}