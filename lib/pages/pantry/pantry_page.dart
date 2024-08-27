import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:namer_app/models/pantry_item.dart';
import 'package:namer_app/pages/pantry/scanner/pantry_barcode_add.dart';
import 'package:namer_app/pages/pantry/pantry_card/pantry_item_card.dart';
import 'package:namer_app/pages/pantry/scanner/scan_failure_page.dart';
import 'package:namer_app/pages/pantry/widgets/navigation_bar.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/providers/pantry_provider.dart';
import 'package:namer_app/pages/pantry/pantry_add/add_pantry_item.dart';
import 'package:namer_app/util/debug.dart';
import 'package:namer_app/util/exceptions/exception_barcode_not_found.dart';
import 'package:namer_app/pages/pantry/widgets/label_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class PantryPage extends StatefulWidget {
  @override
  PantryPageState createState() => PantryPageState();
}

class PantryPageState extends State<PantryPage> {
  // The result of scanning a barcode
  String? _scanResult;
  // Is this our first time scanning?
  bool _isFirstScan = true;

  SortByMode _selectedSortByMode = SortByMode.alphabetical;
  
  UserAgent? userAgent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantry")
      ),
      body: Consumer2<PantryProvider, LabelProvider>(
        builder: (context, pantryProvider, labelProvider, child) {
          
          return Column(
            children: [
              SizedBox(height: 8),
              // Display the search and sorting bx
              Navbar(),
              // Display pantry items
              Expanded(
                child: pantryProvider.filterBy(labelProvider.selectedLabels).isEmpty
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
                        itemCount: pantryProvider.filterBy(labelProvider.selectedLabels).length,
                        itemBuilder: (context, index) {
                          final item = pantryProvider.filterBy(labelProvider.selectedLabels)[index];
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
                  // If the context is not mounted in the widget tree then do not display the failure page as we are in a different part of the app now
                  if(context.mounted) onScanFailure(context);
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
                      onScanFailure(context);
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
          ),

          // Debug
          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Item Add Page",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantryBarcodeAddPage(item: PantryItem(added: DateTime.now(), expiry: DateTime.now().add( const Duration(days:20)), name: "Chicken Breast", weight: 200, quantity: 1, labelSet: {})))
              );
            }
          ),

          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Create test items",
            onTap: () {
              Debug().configure(Provider.of<PantryProvider>(context, listen:false), Provider.of<LabelProvider>(context, listen:false));
            }
          ),

          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "[DEBUG] Barcode scan failure",
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BarcodeScanFailurePage())
              );
            }
          ),
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
      // TODO: Allow the user to modify this in the addition GUI
      var quantity = 1;

      return PantryItem(
        name: name,
        // quantity: double.parse(product.quantity!),
        weight: qty,
        expiry: expiry,
        // TODO: Scanned barcodes should be able to assign label sets but not sure on how that is possible yet so for now it is an empty.
        labelSet: {},
        quantity: quantity,
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

  // Code to handle a barcode scan failure
  void onScanFailure(BuildContext context) {
    print("Barcode scan failed! Result: $_scanResult");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScanFailurePage())
    );
  }
}