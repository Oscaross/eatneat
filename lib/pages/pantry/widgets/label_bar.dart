import 'package:flutter/material.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/pages/label/add_pantry_label.dart';
import 'package:namer_app/util/shake.dart';
import 'package:provider/provider.dart';

class LabelBar extends StatefulWidget {

  @override
  LabelBarState createState() => LabelBarState();

}

class LabelBarState extends State<LabelBar> {
 
  @override 
  Widget build(BuildContext context) {

    var labelProvider = Provider.of<LabelProvider>(context, listen:false);

    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        children: [
          // Render the +, info and expand widgets
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filledTonal(
                style: ButtonStyle(
                  side: WidgetStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.blueAccent, width: 2), // Set the border color and width
                  ),
                  iconColor: WidgetStateProperty.all(Colors.blueAccent),
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.withOpacity(0.1)),
                ),
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => AddLabelPage(),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: IconButton.filledTonal(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.blueAccent, width: 2), // Set the border color and width
                    ),
                    iconColor: WidgetStateProperty.all(Colors.blueAccent),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.withOpacity(0.1)),
                  ),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print("EDIT");
                  },
                ),
              ),

              IconButton.filledTonal(
                style: ButtonStyle(
                  side: WidgetStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.blueAccent, width: 2), // Set the border color and width
                  ),
                  iconColor: WidgetStateProperty.all(Colors.blueAccent),
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.withOpacity(0.1)),
                ),
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  print("EXPAND");
                },
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Render the user's labels 
          
              ...labelProvider.labels.map((label) {
          
                return Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
                  child: ElevatedButton(
                    onPressed: () {
                      // We need to re-draw the widget tree otherwise the labels won't change their styling
                      setState(() {
                        labelProvider.toggleLabel(label);
                        Shaker.vibrate(300);
                      });
                    },
                    onLongPress: () {
                      
                    },
                    style: label.generateButtonStyle(),
                    child: Text(label.getName()),
                  ),
                );
              }
              ).toList(), 
            ]
          ),
        ],
      ),
    );
  }
}