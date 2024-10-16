import 'package:eatneat/pages/pantry/item_view_page.dart';
import 'package:eatneat/ui/options_dialog.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry/pantry_item.dart';
import 'package:eatneat/providers/pantry_provider.dart';
import 'package:flutter/services.dart';

class PantryItemCard extends StatelessWidget {

  // when we hold click on a card, these are the abilities the user is given as shortcuts in the OverlayPortal dropdown menu
  static final List<OptionDialogAction> actionItems = [
    OptionDialogAction(title: "Add Shopping", leadingIcon: Icons.shopping_cart, onPressed: () {}),
    OptionDialogAction(title: "More Info", leadingIcon: Icons.info, onPressed: () {}),
    OptionDialogAction(title: "Mark Expired", leadingIcon: Icons.calendar_month, onPressed: () {}),
    OptionDialogAction(title: "Delete Item", leadingIcon: Icons.delete, important: true, onPressed: () {}),
  ];

  final PantryItem item;
  final OverlayPortalController _optionsDialogController = OverlayPortalController();
  @override
  final GlobalKey key = GlobalKey(debugLabel: "PANTRY_ITEM_CARD");

  PantryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Render the item without a banner if it isn't expired, otherwise, add a banner saying 'EXPIRED'
    if (!item.isExpired()) {
      return renderCardWithoutBanner(context);
    } 
    else {
      return ClipRRect(
        child: Banner(
          color: Colors.red[600]!,
          message: "EXPIRED",
          location: BannerLocation.topStart,
          // Fog out the rest of the card to make it more obvious that this item is expired and make the banner stand out
          child: Opacity(
            opacity: 0.6,
            child: renderCardWithoutBanner(context),
          ),
        ),
      );
    }
  }

  Widget renderCardWithoutBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), 
      child: GestureDetector(
        // If we tap the item go to its page
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemViewPage(item: item, actionType: ActionType.edit),)
            );
        },
        // Spawn the item card dialog
        onLongPress: () {
          _optionsDialogController.toggle();
          Overlay.of(context).insert(
            OverlayEntry(
              builder: (context) => OptionsDialog(actionItems: actionItems, pos: getCardRect()),
            )
          );
          
          HapticFeedback.mediumImpact();
        },
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
                          image: DecorationImage(
                            image: NetworkImage(item.image ?? "https://assets.sainsburys-groceries.co.uk/gol/7931400/1/640x640.jpg"), 
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
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.scale, size: 17, color: Colors.grey[800]),
                                // If the item has a weight of 0 we just care about its arbitrary quantity (ie. 2 "large" chicken breasts)
                                Text(" ${item.quantity} x ${item.weight == 0 ? "" : item.weightFormatted()}", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
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
                                Icon(Icons.timer, size: 17, color: Colors.grey[800]),
                                Text(" ${item.formatExpiryTime()}", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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

  Rect getCardRect() {
    // Fetch the RenderBox using the key's current context
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    // if we don't find a valid render box then return a zero rectangle and avoid a crash, otherwise type promote to a RenderBox and proceed
    if(renderBox == null) return Rect.zero;

    // Get the top-left corner of the widget in global coordinates
    final Offset topLeft = renderBox.localToGlobal(Offset.zero);

    // Get the size of the widget
    final Size size = renderBox.size;

    // Create a Rect from the top-left offset and the size
    return Rect.fromLTWH(topLeft.dx, topLeft.dy, size.width, size.height);
  }
}