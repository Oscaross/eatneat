import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';

// An interactive 'more info' page which allows you to see and modify the items labels and data

class PantryMoreInfoPage extends StatelessWidget {

  final PantryItem item;

  PantryMoreInfoPage({required this.item});

  // TODO: Design more info page to be responsive and allow dynamic edits to items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // TODO: Align this to match the center of the phone screen rather than the axis itself as the back button is misplacing the title.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.name),
          ]
        ),
      ),
      body: Row(
        children: [
          

        ]
      )
    );
  }
}