import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/pages/pantry/widgets/label_bar.dart';
import 'package:namer_app/ui/buttons.dart';
import 'package:provider/provider.dart';

class PantryBarcodeSuccessPage extends StatefulWidget {
  final PantryItem item;

  PantryBarcodeSuccessPage({required this.item});

  @override
  PantryBarcodeSuccessPageState createState() => PantryBarcodeSuccessPageState();
}

class PantryBarcodeSuccessPageState extends State<PantryBarcodeSuccessPage> {
  late PantryItem item;

  // If the user wants to edit any attributes after we fetch from the API then these variables capture those changes upon state update
  late double _weight;
  late String _name;
  late DateTime _expiry;

  static const double widgetSpacing = 20;

  @override
  void initState() {
    item = widget.item;
    // Initialize member variables to their values pulled from the API
    _expiry = item.expiry;
    _name = item.name;
    _weight = item.weight;

    super.initState();
  }

  void editExpiryDate() async {
    DateTime? newDate = await showDatePicker(
      firstDate: DateTime.now(),
      initialDate: _expiry,
      lastDate: DateTime(2100),
      context: context,
    );

    if (newDate != null) {
      setState(() {
        _expiry = newDate;
      });
    }
  }

  void editName() {
    // Implement name editing logic here
  }

  void editWeight(double weight) {
    setState(() {
      _weight = weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Success!")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // The name of the product
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),        
            ),

            // Divider
            SizedBox(height: widgetSpacing),

            // The image of the product we are adding
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
                // TODO: Update the image to not be the stock placeholder but an actual product image, or a better placeholder if no image exists
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      (item.image == null) ? "https://miro.medium.com/v2/resize:fit:1098/format:webp/1*--DvqdXSA38rPuqMK5c0tQ.png" : item.image!),
                ),
              ),
            ),

            SizedBox(height: widgetSpacing),

            // A row of crucial information pertaining to the item including its weight and expiry date.
            // The user should be able to edit these
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Chip to display object weight
                Expanded(
                  child: SpinBox(
                    value: _weight,
                    onChanged: editWeight,
                    min: 0,
                    max: 100000,
                    step: 50,
                    decimals: 1,
                    decoration: InputDecoration(
                      labelText: 'Weight (g)',
                    ),
                  ),
                ),

                SizedBox(width: widgetSpacing),

                // Display object expiry date
                GestureDetector(
                  onTap: editExpiryDate,
                  child: Chip(
                    avatar: Icon(Icons.timer),
                    label: Text(
                      item.displayExpiry(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: widgetSpacing),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button to add pantry item to pantry
                Expanded(
                  child: ElevatedButton.icon(
                    style: Buttons.confirmButtonStyle(),
                    icon: Icon(Icons.check),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Add Item",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                    ),
                    onPressed: () {
                      // Add the PantryItem to the pantry and get out of this window
                      item.expiry = _expiry;
                      item.name = _name;
                      item.weight = _weight;
                  
                      Provider.of<PantryProvider>(context, listen: false)
                          .addItem(item);
                  
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(width: 8),

                // Cancel adding the item and go back to the main pantry page.
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.close),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: Buttons.genericButtonStyle(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
