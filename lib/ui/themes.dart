import 'package:flutter/material.dart';

class Themes {

  static const Color primary = Colors.blue;
  static const Color primaryAccent = Colors.blueAccent;
  static final Color textGrey = Colors.grey.shade700;
  static final Color hintTextGrey = Colors.grey.shade600;
  static const Color background = Color(0xFFFEFEFE);

  static final ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade100,
      surfaceContainer: Colors.grey.shade100,
      onSurface: const Color.fromARGB(255, 97, 97, 97),
      primary: primary,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: textGrey,
      selectionColor: primaryAccent,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      hintStyle: TextStyle(color: hintTextGrey),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
        backgroundColor: WidgetStatePropertyAll(primary.withOpacity(0.2)),
        foregroundColor: WidgetStatePropertyAll(primary),
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

    chipTheme: ChipThemeData(
      elevation: 1,
      labelStyle: TextStyle(
        color: textGrey,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey.shade600,
          width: 2, // Set the border width here
        ),
      ),
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

  static BoxDecoration decorateContainer() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12.0), 
    );
  }
  
}