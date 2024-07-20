import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pantry_provider.dart';
import 'pages/pantry_page.dart';  // Make sure the path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PantryProvider(),
      child: MaterialApp(
        home: MyHomePage(), // Use MyHomePage as the starting point
      ),
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
        page = Placeholder();
      case 1:
        page = PantryPage();
      case 2:
        // Recipe book to add recipes
        page = Placeholder();
      case 3:
        // Settings page
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory),
                      label: Text('Test'),
                    ),
                    NavigationRailDestination(
                      icon:Icon(Icons.book),
                      label: Text('Recipes'),
                    ),
                    NavigationRailDestination(
                      icon:Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,  
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}