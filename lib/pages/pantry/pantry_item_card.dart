import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;

  PantryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                item.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card.outlined(
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
              Card.outlined(
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
              )
            ]
          )
        ],
      ),
    );
  }
}