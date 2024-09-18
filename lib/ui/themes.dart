import 'package:flutter/material.dart';

class Themes {
  // A list of preset color schemes the user can toggle in the preferences tab
  final List<ColorTheme> colorSchemes = <ColorTheme>[
    ColorTheme(name: "Sky Blue", primary: Colors.blue, accent: Colors.blueAccent),
    ColorTheme(name: "Blossom Pink", primary: Colors.pink.shade300, accent: Colors.pink.shade400),
    ColorTheme(name: "Sunset Orange", primary: Colors.deepOrange.shade400, accent: Colors.deepOrange),
    ColorTheme(name: "Mint Green", primary: Colors.greenAccent, accent: Colors.greenAccent.shade400),
    ColorTheme(name: "Lavender Purple", primary: Colors.deepPurple.shade400, accent: Colors.deepPurple),
  ];

  // TODO: not sure how this state should be managed/maintained until I allow the user to change the theme, so keep as a static variable for now
  static bool isDark = false;

  // Pass the highlight colors through shiftColor in order to match dark mode (more vibrant highlight) or light mode (less vibrant).
  static final Color primary = _shiftColor(Colors.blue, (isDark) ? 1 : 0.95);
  static final Color primaryAccent = _shiftColor(Colors.blueAccent, (isDark) ? 1 : 0.95);
  static final Color textGrey = Colors.grey.shade700;
  static final Color hintTextGrey = Colors.grey.shade400;
  static final Color background = Colors.grey.shade50;
  static final Color backgroundSecondary = Colors.grey.shade100;
  static final Color border = Colors.grey.shade300;

  static final ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade200,
      surfaceContainer: background,
      onSurface: const Color.fromARGB(255, 97, 97, 97),
      primary: primary,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: textGrey,
      selectionColor: primaryAccent,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border, width: 2.0),
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

    scaffoldBackgroundColor: background,

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

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryAccent,
      foregroundColor: Colors.white,
      iconSize: 26,
      splashColor: primary,
      focusColor: primary,
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryAccent.withOpacity(0.1); 
            }
            return null; 
          },
        ),
        splashFactory: InkRipple.splashFactory,
      )
    ),

    // TODO: Add this
    actionIconTheme: ActionIconThemeData(

    ),

    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.symmetric(horizontal: 16.0), 
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundSecondary,
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
      backgroundColor: backgroundSecondary,
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
      color: background,
      gradient: LinearGradient(
      begin: Alignment.topLeft, 
      end: Alignment.bottomRight, 
      colors: [
        backgroundSecondary.withOpacity(0.2), 
        background,
      ],
    ),
      borderRadius: BorderRadius.circular(12.0), 
      border: Border.all(color: border, width: 1.5),
    );
  }

  /// Generates a custom style for IconButtons which we want to be clickable icons for consistency across the app. We have not used the default iconButtonTheme as this also includes stuff like the app bar and context menus which we don't want stylised.
  static ButtonStyle decorateIconButton() {
    return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(primaryAccent),
        overlayColor: WidgetStatePropertyAll(primaryAccent.withOpacity(0.15)),
        backgroundColor: WidgetStatePropertyAll(primary.withOpacity(0.05)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), 
        )),
        side: WidgetStatePropertyAll(BorderSide(
          color: primaryAccent,
          width: 2,
        )),
        alignment: Alignment.center,
        padding: WidgetStatePropertyAll(EdgeInsets.only(top: 1)),
      );
  }

  /// Shifts a color's RGB values equally to create a brighter or a darker color to match the theme. 
  static Color _shiftColor(Color col, double shiftFactor) {
    assert ((shiftFactor > 0 && shiftFactor <= 1), "RGB values cannot be negative or greater than their bound, yet the shift factor assigned was outside the range 0 <= x <= 1! ($shiftFactor)");

    int r = (col.red * shiftFactor).toInt();
    int g = (col.green * shiftFactor).toInt();
    int b = (col.blue * shiftFactor).toInt();

    return Color.fromARGB(col.alpha, r, g, b);
  }
  
}

class ColorTheme {
  final String name;
  final Color primary;
  final Color accent;

  ColorTheme({required this.name, required this.primary, required this.accent});
}