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
      onSurface: Colors.grey.shade700,
      primary: primary,
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: textGrey,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        color: textGrey,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        color: textGrey,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textGrey,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: textGrey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: textGrey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      )
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primary.withOpacity(0.15)),
        overlayColor: WidgetStatePropertyAll(primaryAccent.withOpacity(0.05)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
        textStyle: WidgetStatePropertyAll(TextStyle(
          fontSize: 16,
          color: primaryAccent,
          fontWeight: FontWeight.w800,
        ))
      )
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(
          color: primary,
          width: 2,
        )),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
        textStyle: WidgetStatePropertyAll(TextStyle(
          color: primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          )
        )
      )
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primary),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
        textStyle: WidgetStatePropertyAll(TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          )
        )
      )
    ),

    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.symmetric(horizontal: 16.0), 
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: IconThemeData(color: textGrey),
      titleTextStyle: TextStyle(
        color: textGrey,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: background,
      selectedItemColor: primaryAccent,
      unselectedItemColor: Colors.grey.shade600,      
    ),

    cardTheme: CardTheme(
      clipBehavior: Clip.hardEdge,
      color: background,
      elevation: 2,
      shadowColor: Colors.grey.shade500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textGrey,
      ),

      contentTextStyle: TextStyle(
        fontSize: 16,
        color: textGrey,
      ),
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
    ),
  );

  static final ThemeData darkMode = ThemeData(

    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade900,
      surfaceContainer: Colors.grey.shade800,
      primary: primary,
    ),

  );

  // Utility functions

  /// Takes the current BuildContext and constructs a button that spans a visually appealing portion of the screen, this is a common style in this app.
  static Size getFullWidthButtonSize(BuildContext context) => Size(MediaQuery.of(context).size.width * 0.95, MediaQuery.of(context).size.height * 0.1);
  
}