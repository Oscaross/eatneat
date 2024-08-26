import 'package:flutter/material.dart';
import 'package:namer_app/pages/pantry/pantry_add/add_pantry_item.dart';

// The page that is displayed when the user's scan fails
class BarcodeScanFailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Failed"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100), // Adjust the height to control how high up the content is
          Icon(Icons.warning_sharp, color: Colors.redAccent, size: 100),
          SizedBox(height: 20),
          Card(
            color: Colors.redAccent,
            child: SizedBox(
              width: 150,
              height: 40,
              child: Center(
                child: Text(
                  "Scan Failed",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 40), // Space between the main content and the text
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Barcode scan was unsuccessful. Check the following:"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi),
                  SizedBox(width: 8), // Space between the icon and text
                  Text("You have a valid internet connection."),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.barcode_reader),
                  SizedBox(width: 8), // Space between the icon and text
                  Text("The barcode is clearly visible."),
                ],
              ),
            ],
          ),
          SizedBox(height: 200),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                label: Text("Retry Scan"),
                icon: Icon(Icons.refresh),
                onPressed: () {
                  // TODO: Refactor scanning logic so we can just call the asynchronous scan function from inside here

                },
              ),

              TextButton.icon(
                label: Text("Add Manually"),
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context) => AddItemPage())
                  );
                },
              )

            ]

          ),
        ],
      ),
    );
  }
}
