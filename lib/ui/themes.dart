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
  static final Color textHighlight = Colors.grey.shade800;
  static final Color hintTextGrey = Colors.grey.shade400;
  static final Color background = Colors.grey.shade50;
  static final Color backgroundSecondary = Colors.grey.shade100;
  static final Color containerHighlight = Colors.grey.shade200;
  static final Color border = Colors.grey.shade300;
  static final Color overlayColor = Colors.grey.shade900;

  static const double largeFontSize = 16;
  static const double mediumFontSize = 15;
  static const double smallFontSize = 13;

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
        color: primaryAccent,
        fontSize: largeFontSize,
        fontWeight: FontWeight.w800
      ),
      displayMedium: TextStyle(
        color: primaryAccent,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: textHighlight,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: TextStyle(
        color: textGrey,
        fontSize: largeFontSize,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: textGrey,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.normal
      ),
      bodySmall: TextStyle(
        color: textGrey,
        fontSize: smallFontSize,
        fontWeight: FontWeight.normal
      ),
      labelLarge: TextStyle(
        color: textHighlight,
        fontSize: largeFontSize,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: textHighlight,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        color: textHighlight,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textHighlight,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textGrey,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
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
          fontWeight: FontWeight.w700,
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

    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.symmetric(horizontal: 16.0), 
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundSecondary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textGrey,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    iconTheme: IconThemeData(
      color: textHighlight,      
      size: 24.0,                 
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

    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(Colors.white),
      fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Themes.primaryAccent : Themes.background),
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
  static Size getFullWidthButtonSize(BuildContext context) => Size(MediaQuery.of(context).size.width * 0.95, MediaQuery.of(context).size.height * 0.01);

  /// Returns the current app primary color scheme with an opacity film to make for a nice background for labels or text widgets that need to stand out
  static Color getPrimaryBackground() => primary.withOpacity(0.1);

  static BoxDecoration decorateContainer() {
    return BoxDecoration(
      color: background,
      gradient: LinearGradient(
        begin: Alignment.topLeft, 
        end: Alignment.bottomRight, 
        colors: [
          backgroundSecondary, 
          containerHighlight,
        ],
      ),
      borderRadius: BorderRadius.circular(32.0), 
      border: Border.all(color: border, width: 1.5),
    );
  }

  /// Generates a custom button style for text buttons which do not want a fill color, such as when picking between two different pages.
  static ButtonStyle decorateTextButton(ButtonType type) {
    Color foregroundColor = switch(type) {
      ButtonType.standout => primaryAccent,
      ButtonType.subtle => textHighlight,
    };

    FontWeight fontWeight = switch(type) {
      ButtonType.standout => FontWeight.w700,
      ButtonType.subtle => FontWeight.w600,
    };

    double width = switch(type) {
      ButtonType.standout => 2,
      ButtonType.subtle => 1.5,
    };

    return TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: foregroundColor,
        width: width,
      ),
      foregroundColor: foregroundColor,
      textStyle: TextStyle(
        fontSize: mediumFontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  /// Generates a custom style for IconButtons which we want to be clickable icons for consistency across the app. We have not used the default iconButtonTheme as this also includes stuff like the app bar and context menus which we don't want stylised.
  static ButtonStyle decorateIconButton(ButtonType type) {

    Color mainColor = switch(type) {
      ButtonType.standout => primaryAccent,
      ButtonType.subtle => Colors.grey.shade50,
    };

    Color backgroundColor = switch(type) {
      ButtonType.standout => primary,
      ButtonType.subtle => Colors.grey.shade100,
    };

    double borderWidth = switch(type) {
      ButtonType.standout => 2,
      ButtonType.subtle => 1.75,
    };

    double borderRadius = switch(type) {
      ButtonType.standout => 10.0,
      ButtonType.subtle => 15,
    };

    return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(mainColor),
        overlayColor: WidgetStatePropertyAll(mainColor.withOpacity(0.1)),
        backgroundColor: WidgetStatePropertyAll(backgroundColor.withOpacity(0.1)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), 
        )),
        side: WidgetStatePropertyAll(BorderSide(
          color: mainColor,
          width: borderWidth,
        )),
        alignment: Alignment.center,
        padding: WidgetStatePropertyAll(EdgeInsets.only(top: 1)),
      );
  }

  static ButtonStyle filledButtonCancelStyle(BuildContext context) {
    return ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Themes.getFullWidthButtonSize(context)),
      backgroundColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.25)),
      overlayColor: WidgetStatePropertyAll(Colors.redAccent.withOpacity(0.07)),
      foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 249, 85, 74)),
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

/// Describes how the generateIconButton method should behave, gives a greyed out more subtle icon if subtle (for things like an x) and a more highlighted color to fit the primary accent for standout
enum ButtonType {
  subtle,
  standout
}