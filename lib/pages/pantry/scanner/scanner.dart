// A static class that is designed to encapsulate all logic for communicating with the OFF API, fetching product data & images
// Handles errors with the scanne, errors in response and instructs the pantry page on where the user should be redirected after a scan occurs

import 'package:eatneat/pages/pantry/item_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:eatneat/pages/pantry/scanner/scan_failure_page.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Scanner {

  static Future<void> scan(BuildContext context, OriginPage page) async {

    PantryItem? item = await tryFetch(await tryScan(context));

    // If our BuildContext is no longer mounted, something bad happened and we should give up the whole process and hand control back to PantryPage
    if(!context.mounted) return;

    // A null item can only mean one thing, the scan failed somewhere
    if(item == null) {
      onScanFailure(context, (page == OriginPage.scanFailurePage));
    }
    else {
      // Otherwise, give this function the successfully constructed PantryItem
      onScanSuccess(context, item);
    }

  }

  static bool _isFirstFetch = true;

  // Attempts to use flutter barcode scanner to scan the barcode and returns its result, or null if there was a problem with the scan
  static Future<String?> tryScan(BuildContext context) async {

    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan line
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash icon
        ScanMode.BARCODE, // Scan mode (QR code or Barcode)
      );

      return (context.mounted) ? barcode : null;
    } 
    catch (e) {
      return null;
    }
  }

  // Takes the barcode from the barcode scanner and attempts to retrieve its data from the Open Food Facts API
  static Future<PantryItem?> tryFetch(String? barcode) async {

    if(barcode == null) return null;

    if(_isFirstFetch) {
      _isFirstFetch = false;
      OpenFoodAPIConfiguration.userAgent = UserAgent(name: "EatNeat App", comment: "Request for product data in order to store an object in the EatNeat pantry.");
      OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;
      OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
        OpenFoodFactsLanguage.ENGLISH
      ];
    }

    // The request to receive data about the barcode
    ProductQueryConfiguration request = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
    );

    ProductResultV3 response = await OpenFoodAPIClient.getProductV3(request);

    if(response.result == null || response.product == null) return null;

    Product product = response.product!;

    return PantryItem(
      name: (product.productName == null) ? " " : product.productName!,
      weight: Parser.parseQuantity(product.quantity),
      expiry: Parser.parseExpiry(product.expirationDate),
      added: DateTime.now(),
      quantity: 1,
      labelSet: {},
      image: product.imageFrontUrl
    );
  }

  static void onScanFailure(BuildContext context, bool pageAlreadyBuilt) {
    
    if(!pageAlreadyBuilt) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarcodeScanFailurePage())
      );
    }

    print("Scan unsuccessful");
  }

  static void onScanSuccess(BuildContext context, PantryItem item) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemViewPage(item: item, actionType: ActionType.add))
    );

    print("Scan successful");
  }
}

class Parser {

  static double parseQuantity(String? qty) {
    if(qty == null || qty == "") return 0;

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

  static DateTime parseExpiry(String? expiry) {
    print(expiry);
    return DateTime.now();
  }

}

// Tells our app which page we came from, if we came from the failure page we need to not display the notification again or we get an endless stack of failed pages
enum OriginPage {
  scanFailurePage,
  pantryPage
}