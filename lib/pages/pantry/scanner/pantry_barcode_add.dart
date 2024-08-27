import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/pages/pantry/widgets/label_bar.dart';
import 'package:provider/provider.dart';

class PantryBarcodeAddPage extends StatefulWidget {
  final PantryItem item;

  PantryBarcodeAddPage({required this.item});

  @override
  PantryBarcodeAddPageState createState() => PantryBarcodeAddPageState();
}

class PantryBarcodeAddPageState extends State<PantryBarcodeAddPage> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scan Success!'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // The name of the product
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      "https://miro.medium.com/v2/resize:fit:1098/format:webp/1*--DvqdXSA38rPuqMK5c0tQ.png"),
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

            LabelBar(),

            SizedBox(height: widgetSpacing),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button to add pantry item to pantry
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.blue,
                        width: 1.75,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), 
                      ),
                      elevation: 0,
                      backgroundColor: Colors.green.withOpacity(0.2),
                      foregroundColor: Colors.green, // Background color
                      minimumSize: Size(double.infinity, MediaQuery.of(context).size.height / 14),
                    ),
                    icon: Icon(Icons.check),
                    label: Text(
                        "Yes, add to my pantry",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)
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
                    label: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.red,
                        width: 1.75,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), 
                      ),
                      elevation: 0,
                      backgroundColor: Colors.red.withOpacity(0.2),
                      foregroundColor: Colors.red, // Background color
                      minimumSize: Size(double.infinity, MediaQuery.of(context).size.height / 14),
                    ),
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
