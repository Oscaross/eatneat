import 'package:eatneat/pages/pantry/item_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:eatneat/models/pantry/pantry_item.dart';
import 'package:eatneat/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:provider/provider.dart';

class PantryItemCardDialog extends StatelessWidget {

  final PantryItem item;
  final PantryItemCard card;

  PantryItemCardDialog({required this.item, required this.card});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      children: [
        SpeedDialChild(
          child: Icon(Icons.delete, color: Colors.white),
          label: "Delete Item",
          labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          backgroundColor: Colors.red,
          labelBackgroundColor: Colors.red,
          onTap: () {
            card.deleteItem(item, Provider.of<PantryProvider>(context, listen:false));
          }
         ),

         SpeedDialChild(
          child: Icon(Icons.info),
          label: "More Info",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemViewPage(item: item, actionType: ActionType.edit),)
            );
          
          }
         ),
      ]
    );
  }
}