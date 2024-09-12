import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/pages/home/home_page.dart';
import 'package:eatneat/pages/preferences/preferences_page.dart';
import 'package:eatneat/providers/label_provider.dart';
import 'package:eatneat/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'providers/pantry_provider.dart';
import 'pages/pantry/pantry_page.dart'; // Ensure the path is correct

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PantryProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LabelProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: This theme here can definitely be improved!
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: Themes.lightMode,
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
        page = HomePage();
      case 1:
        page = PantryPage();
      case 2:
        // Recipe book to add recipes
        page = Placeholder();
      case 3:
        // Settings page
        page = PreferencesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
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