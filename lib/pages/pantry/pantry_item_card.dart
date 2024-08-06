import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/screens/pantry/edit_pantry_item.dart';
import 'package:namer_app/util/shake.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;
  LongPressStartDetails? pointOfContact;

  bool _showPopupMenu = false;

  PantryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Vertical padding
      child: GestureDetector(
        onLongPressStart: (details) {
          // Tells our app details such as when, where and how the button was pressed
          pointOfContact = details;
        },
        onLongPress: () {
          // Handle long press
          _showCardDialog(context, pointOfContact);

          // Shake the device
          Shaker.vibrate(15);
        },
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
                        image: DecorationImage(
                          image: NetworkImage("https://miro.medium.com/v2/resize:fit:1098/format:webp/1*--DvqdXSA38rPuqMK5c0tQ.png"), // Assuming you have an image URL in your PantryItem model
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        item.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.scale, size: 17),
                              Text(" ${item.quantity.toString()} ${(item.isQuantity) ? "units" : "g"}"),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0.5,
                        color: item.colorCodeExpiry(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.timer, size: 18),
                              Text(" ${item.formatExpiryTime()}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Called on long press of a card, responsible for spawning the correct popup menu in the correct spot
  void _showCardDialog(BuildContext context, LongPressStartDetails? lp) {

  // The card we are invoking dialog on
  final RenderBox card = context.findRenderObject() as RenderBox;
  // The global position of such card
  final Offset cardPos = card.localToGlobal(Offset.zero);
  final Size cardSize = card.size;

  // The details of the box we must spawn to display the options. 
  // It should be spawned directly below the card's RenderBox 
  final RelativeRect boxPos = RelativeRect.fromLTRB(
    cardPos.dx,
    cardPos.dy + cardSize.height,
    cardPos.dx + cardSize.width,
    cardPos.dy + cardSize.height,
  );

  SpeedDial(


  );

  // showMenu<String>(
  //   color: Colors.transparent,
  //   elevation: 0,
  //   context: context,
  //   position: boxPos,
  //   items: [
  //     PopupMenuItem<String>( 
  //       padding: const EdgeInsets.all(0),
  //       value: "Delete",
  //       child: ElevatedButton.icon(
  //         icon: Icon(Icons.delete, color: Colors.black87, size: 20),
  //         label: Text("Delete Item", style: TextStyle(fontWeight: FontWeight.bold)),
  //         style: StaticButtonStyles.deleteButtonStyle,
  //         onPressed: () {
  //           _deleteItem(item, Provider.of<PantryProvider>(context, listen: false));
  //         },
  //       ),
  //     ),
  //     PopupMenuItem<String>(
  //       padding: const EdgeInsets.all(0),
  //       value: "Edit",
  //       child: ElevatedButton.icon(
  //         icon: Icon(Icons.edit),
  //         label: Text("Edit Item"),
  //         onPressed: () {
  //           _editItem(context, item);
  //         },
  //       ),
  //     ),
  //   ],
  // );


}

  void _editItem(BuildContext context, PantryItem item) {

    Navigator.push(context, MaterialPageRoute(builder: (context) => EditItemPage(item: item)));
  }

  void _deleteItem(PantryItem item, PantryProvider provider) {

    provider.removeItem(item);
  }
}