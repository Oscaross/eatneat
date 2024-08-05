import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/pages/pantry/pantry_item_card.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/screens/pantry/add_pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:namer_app/util/debug.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PantryPage extends StatefulWidget {
  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  // The label that we want to display
  LabelItem? _selectedLabel;
  // The result of scanning a barcode
  String? _scanResult;
   // Set up debug

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('My Pantry'),
          ],
        ),
      ),
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Debug().configure(Provider.of<PantryProvider>(context, listen: false), Provider.of<LabelProvider>(context, listen:false));
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => AddLabelPage(),
                          ),
                        );
                      },
                      style: labelProvider.addButtonStyle,
                      child: Text("+"),
                    ),
                    ...labelProvider.labels.map((label) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if(_selectedLabel != null) {
                              _selectedLabel!.hide();
                            }
                            _selectedLabel = label;
                            _selectedLabel!.show();

                            labelProvider.selectedLabel = _selectedLabel;
                          });
                        },
                        // If we are in long press mode we should be editing the label
                        onLongPress: () {
                          final String? option;
                        },
                        style: label.generateButtonStyle(),
                        child: Text(label.getName()),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Expanded(
                child: pantryProvider.filterBy(_selectedLabel).isEmpty
                    ? Center(
                        child: Text(
                          "No items to display! Click the + to add your first item...",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, 
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: pantryProvider.filterBy(_selectedLabel).length,
                        itemBuilder: (context, index) {
                          final item = pantryProvider.filterBy(_selectedLabel)[index];
                          return PantryItemCard(item: item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: Icon(Icons.barcode_reader),
            label: "Scan Barcode",
            onTap: () async {
              print("Attempting to open the scanner!");
              // Scan our barcode and don't move on until we have a result
              await _scanBarcode();
              print(_scanResult);
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.plus_one),
            label: "Manually Add",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => AddItemPage(),
                )
              );
            }
          )
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Testing ID: 5000168203393 to try and fetch product data from OFF

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan line
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash icon
        ScanMode.BARCODE, // Scan mode (QR code or Barcode)
      );

      if (!mounted) return;

      setState(() {
        _scanResult = barcode != '-1' ? barcode : 'Scan cancelled';
      });
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to get scan result';
      });
    }
  }
}