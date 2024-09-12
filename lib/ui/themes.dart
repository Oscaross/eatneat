import 'package:flutter/material.dart';

class Themes {
  static const Color primary = Colors.blue;
  static const Color primaryAccent = Colors.blueAccent;
  static final Color textGrey = Colors.grey.shade700;
  static const Color background = Color(0xFFFEFEFE);


  static final ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade200,
      surfaceContainer: Colors.grey.shade200,
      primary: primary,
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      )
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primary.withOpacity(0.15)),
        overlayColor: WidgetStatePropertyAll(primaryAccent.withOpacity(0.05)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
      )
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade800),
      titleTextStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: background,
      selectedItemColor: primaryAccent,
      unselectedItemColor: Colors.grey.shade600,      
    )
  );

  static final ThemeData darkMode = ThemeData(

    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade900,
      surfaceContainer: Colors.grey.shade800,
      primary: primary,
    ),

  );
}