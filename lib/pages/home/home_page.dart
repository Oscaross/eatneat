import 'package:eatneat/ui/safe_padding.dart';
import 'package:eatneat/ui/themes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Display quick actions like settings management and account management
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => Padding(
                  // some breathing room around the interface
                  padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.large),
                  child: Container(
                    color: Colors.grey.shade50
                  ),
                ),
              );
            },
          )
        ],
        title: Text("EatNeat")
      ),

      body:
        Center(child: Text("Welcome to EatNeat!")),
    );
  }
}

class Settings {

  static const List<String> listTiles = ["Hi", "Hello", "Yolo"];

  static Future<void> renderSettingsPage(BuildContext context) async {
    RenderBox appBarBox = context.findRenderObject() as RenderBox;
    Offset offset = appBarBox.localToGlobal(Offset.zero);
    Size deviceSize = MediaQuery.of(context).size;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        deviceSize.width,
        offset.dy + appBarBox.size.height, // don't render the box over the app bar
        0,
        0 // bottom of screen
      ),
      items: [
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ),
        PopupMenuItem(
          value: 'help',
          child: ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
    ).then((value) {
      
    },
    
  );}
}