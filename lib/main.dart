import 'package:flutter/material.dart';
import 'package:namer_app/pages/preferences_page.dart';
import 'package:namer_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'providers/pantry_provider.dart';
import 'pages/pantry_page.dart'; // Ensure the path is correct

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PantryProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: themeProvider.primary,
            primarySwatch: themeProvider.primarySwatch,
            secondaryHeaderColor: themeProvider.secondary,
            scaffoldBackgroundColor: themeProvider.background,
            appBarTheme: themeProvider.appBar,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: themeProvider.background,
              selectedItemColor: themeProvider.primary,
              unselectedItemColor: Colors.grey,
            ),
          ),
          home: MyHomePage(),
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Placeholder(); // Update this to your actual home page widget
        break;
      case 1:
        page = PantryPage();
        break;
      case 2:
        // Recipe book to add recipes
        page = Placeholder(); // Update this to your actual recipe book widget
        break;
      case 3:
        // Settings page
        page = PreferencesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Pantry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}