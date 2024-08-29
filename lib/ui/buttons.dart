import 'package:flutter/material.dart';

// Global styles for the app's buttons

class Buttons {

  static ButtonStyle confirmButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 92, 201, 96)),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      side: WidgetStatePropertyAll(BorderSide(
        color: Color.fromARGB(255, 83, 185, 87),
        width: 0.3,
      )),
      elevation: WidgetStatePropertyAll(3),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0), 
      )),
      textStyle: WidgetStatePropertyAll(TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ))
    );
  }

  static ButtonStyle cancelButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.red),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      side: WidgetStatePropertyAll(BorderSide(
        color: Color.fromARGB(255, 247, 63, 50),
        width: 0.3,
      )),
      elevation: WidgetStatePropertyAll(3),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.0), 
      )),
      textStyle: WidgetStatePropertyAll(TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ))
    );
  }

  static ButtonStyle genericButtonStyle(double opacityFactor) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.blueAccent.withOpacity(opacityFactor)),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      elevation: WidgetStatePropertyAll(3),
      side: WidgetStatePropertyAll(BorderSide(
        color: const Color.fromARGB(255, 57, 127, 247),
        width: 0.3,
      )),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0), 
      )),
      textStyle: WidgetStatePropertyAll(TextStyle(
        fontWeight: (opacityFactor != 1) ? FontWeight.w600 : FontWeight.w700,
        fontSize: 15,
      ))
    );
  }
}