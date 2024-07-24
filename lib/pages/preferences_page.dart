import 'package:flutter/material.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Preferences'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.brightness_1_outlined),
            label: Text("Appearance"),
            onPressed: (() => null),
          )
        ]
      )
    );
  }

}