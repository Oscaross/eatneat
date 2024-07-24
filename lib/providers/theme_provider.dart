import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  static const defaultPrimaryColor = Color.fromARGB(255, 100, 200, 246);
  static const Map<int, Color> _primarySwatch = {
    50: Color(0xFFFCE4EC),
    100: Color(0xFFF8BBD0),
    200: Color(0xFFF48FB1),
    300: Color(0xFFF06292),
    400: Color(0xFFEC407A),
    500: Color(0xFF880E4F),
    600: Color(0xFFD81B60),
    700: Color(0xFFC2185B),
    800: Color(0xFFAD1457),
    900: Color(0xFF880E4F),
  };
  static const defaultPrimarySwatch = MaterialColor(
    0xFF880E4F,
    _primarySwatch,
  );
  static const defaultSecondaryColor = Color.fromARGB(255, 90, 150, 255);
  static const defaultBackgroundColor = Colors.white;
  static const defaultSurfaceColor = Color.fromARGB(26, 245, 246, 255);
  static const defaultTextColor = Colors.black;
  static const defaultButtonColor = Colors.blueGrey;
  static const defaultAppBarColor = AppBarTheme(color: Color.fromARGB(255, 159, 191, 216));

  Color primaryColor;
  MaterialColor primarySwatch;
  Color secondaryColor;
  Color backgroundColor;
  Color surfaceColor;
  Color textColor;
  Color buttonColor;
  AppBarTheme appBarColor;

  ThemeProvider({
    this.primaryColor = defaultPrimaryColor,
    this.primarySwatch = defaultPrimarySwatch,
    this.secondaryColor = defaultSecondaryColor,
    this.backgroundColor = defaultBackgroundColor,
    this.surfaceColor = defaultSurfaceColor,
    this.textColor = defaultTextColor,
    this.buttonColor = defaultButtonColor,
    this.appBarColor = defaultAppBarColor,
  });

  void updatePrimaryColor(Color color) {
    primaryColor = color;
    notifyListeners();
  }

  void updatePrimarySwatch(MaterialColor color) {
    primarySwatch = color;
    notifyListeners();
  }

  void updateSecondaryColor(Color color) {
    secondaryColor = color;
    notifyListeners();
  }

  void updateBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }

  void updateSurfaceColor(Color color) {
    surfaceColor = color;
    notifyListeners();
  }

  void updateTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  void updateButtonColor(Color color) {
    buttonColor = color;
    notifyListeners();
  }

  void updateAppBarColor(AppBarTheme color) {
    appBarColor = color;
    notifyListeners();
  }

  // Getters (optional if you prefer to access properties directly)
  Color get primary => primaryColor;
  MaterialColor get swatch => primarySwatch;
  Color get secondary => secondaryColor;
  Color get background => backgroundColor;
  Color get surface => surfaceColor;
  Color get text => textColor;
  Color get button => buttonColor;
  AppBarTheme get appBar => appBarColor;
}
