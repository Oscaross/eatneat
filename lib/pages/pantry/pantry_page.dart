import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/pages/pantry/pantry_barcode_add.dart';
import 'package:namer_app/pages/pantry/pantry_item_card.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/screens/pantry/add_pantry_item.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:namer_app/util/debug.dart';
import 'package:namer_app/util/exceptions/exception_barcode_not_found.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class PantryPage extends StatefulWidget {
  @override
  _PantryPageState createState() => _PantryPageState();
  
}

class _PantryPageState extends State<PantryPage> {
  // The label that we want to display
  LabelItem? _selectedLabel;
  // The result of scanning a barcode
  String? _scanResult;
  // Is this our first time scanning?
  bool _isFirstScan = true;
  
  UserAgent? userAgent;

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
              // Avoid synchronisation issues by getting the context before we send the barcode & API request and then check context later to prevent issues
              BuildContext contextBeforeAsync = context;

              // Scan our barcode and don't move on until we have a result
              await _scanBarcode();

              if(_scanResult != null) {
                PantryItem? itemToAdd;

                try
                {
                  itemToAdd = await _fetchItemData(_scanResult!);
                }
                catch(e) {
                  print(e.toString());
                }
                // If and only if the CURRENT build widget tree contains this context should we send the request to add the pantry item
                if(context.mounted)
                {
                    // Redirect user to the final step to adding the item
                    if(itemToAdd != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantryBarcodeAddPage(item: itemToAdd!))
                      );
                    }
                    // The item is null so scanning was unsuccessful. We can retry the scan or just give the option to add manually.
                    else 
                    {
                      // TODO: Show alert dialog to get the user to retry the scan or add manually
                    }
                  
                }
                 
              }
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

      // if the barcode scan fails we assign 'null' to _scanResult so it can be accordingly handled in the following page

      setState(() {
        _scanResult = (barcode != '-1') ? barcode : null;
      });
    } catch (e) {
      setState(() {
        _scanResult = null;
      });
    }
  }

  Future<PantryItem> _fetchItemData(String barcode) async {
    // Configure the scanner for the first time
    if(_isFirstScan) {
      _isFirstScan = false;

      OpenFoodAPIConfiguration.userAgent = UserAgent(name: "EatNeat App", comment: "Request for product data in order to store an object in the EatNeat pantry.");
      OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;
      OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
        OpenFoodFactsLanguage.ENGLISH
      ];
    }

    // The request to receive data about the barcode
    ProductQueryConfiguration itemConfig = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
    );

    // The response from the API
    ProductResultV3 res = await OpenFoodAPIClient.getProductV3(itemConfig);

    if(res.product == null) {
      // Throw an exception if the product is null! We need to retry the barcode scan or get the user to add it manually.
      throw BarcodeNotFoundException(barcode);
    }
    else {
      var product = res.product!;

      var name = (product.productName == null) ? " " : product.productName!;
      var qty = _parseQuantity(product.quantity);
      var expiry = (product.expirationDate == null) ? DateTime.now() : DateTime.parse(product.expirationDate!);

      return PantryItem(
        name: name,
        // quantity: double.parse(product.quantity!),
        quantity: qty,
        expiry: expiry,
        isQuantity: false,
        label: _selectedLabel,
        added: DateTime.now(),
      );
    }
  }

  // Takes an API response for the quantity of a good and parses it into a double in metric units (grams)
  double _parseQuantity(String? qty) {
    if(qty == null) return 0;

    String asStr = "";
    bool isKilos = false;

    for(int i = 0; i < qty.length; i++) {
      var c = qty[i];

      switch(c)
      {
        case " ":
          continue;
        case "k":
          isKilos = true;
        case "g":
          continue;
        // Either a number or a decimal point so add it to the asStr variable to parse it later
        default:
          asStr += qty[i];
      }
    }

    double number = double.parse(asStr);

    return (isKilos) ? number * 1000 : number;
  }
}