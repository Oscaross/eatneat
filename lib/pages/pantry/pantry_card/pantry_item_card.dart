import 'package:eatneat/pages/pantry/pantry_add/item_view_page.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:eatneat/pages/pantry/pantry_card/card_popup_dialog.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:eatneat/util/shake.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;
  PantryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Vertical padding
      child: GestureDetector(
        // If we tap the item go to its page
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemViewPage(item: item),)
            );
        },
        // Spawn the item card dialog
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: PantryItemCardDialog(item: item, card: this),
              );
            },
          );
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
                              // If the item has a weight of 0 we just care about its arbitrary quantity (ie. 2 "large" chicken breasts)
                              Text(" ${item.quantity} x ${item.weight == 0 ? "" : item.weightFormatted()}"),
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

  void deleteItem(PantryItem item, PantryProvider provider) {
    provider.removeItem(item);
  }
}