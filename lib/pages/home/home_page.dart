import 'package:eatneat/pages/home/settings/main_settings_page.dart';
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
              // TODO: Need to figure out how to stack these pages using the navigator properly
              await showDialog(
                context: context,
                builder: (context) => Padding(
                  // some breathing room around the interface
                  padding: SafePadding.getSafePadding(context: context, marginType: MarginType.all, paddingType: PaddingType.large),
                  child: Container(
                    decoration: Themes.decorateContainer(),
                    child: MainSettingsPage(),
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