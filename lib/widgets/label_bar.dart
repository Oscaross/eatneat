import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:namer_app/screens/pantry/add_pantry_label.dart';
import 'package:provider/provider.dart';

class LabelBar extends StatefulWidget {

  @override
  _LabelBarState createState() => _LabelBarState();

}

class _LabelBarState extends State<LabelBar> {

  @override
  Widget build(BuildContext context) {

    var labelProvider = Provider.of<LabelProvider>(context, listen:false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text("Add Label"),
            style: labelProvider.addButtonStyle,
      
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AddLabelPage(),
                ),
              );
            },
          ),
          ...labelProvider.labels.map((label) {
      
            return ElevatedButton(
              onPressed: () {
                // We need to re-draw the widget tree otherwise the labels won't change their styling
                setState(() {
                  labelProvider.toggleLabel(label);
                });
              },
              onLongPress: () {
                print(label.toString() + " is being long pressed");
              },
              style: label.generateButtonStyle(),
              child: Text(label.getName()),
            );
          }
          ).toList(), 
        ]
      ),
    );
  }
}