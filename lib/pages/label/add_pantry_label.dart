import 'package:flutter/material.dart';
import 'package:namer_app/models/label_item.dart';
import 'package:namer_app/providers/label_provider.dart';
import 'package:provider/provider.dart';

class AddLabelPage extends StatefulWidget {
  @override
  AddLabelPageState createState() => AddLabelPageState();
}

class AddLabelPageState extends State<AddLabelPage> {
  final TextEditingController _nameController = TextEditingController();

  final Map<String, Color> namedColors = {
    "Blue": Colors.blue,
    "Green": Colors.green,
    "Red": Colors.red,
    "Orange": Colors.orange,
    "Yellow": Color.fromARGB(255, 237, 219, 49),
    "Pink": Colors.pink,
    "Purple": Colors.purple,
  };
  // The first color that the app highlights in the dropdown widget.
  String _selectedColor = "Blue";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new label"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label name input
            SizedBox(
              child: TextField(
                autocorrect: true,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Label Name",
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(height: 16.0), // Add some space between the input field and the dropdown

            // DropdownButton to select color
            DropdownButton<String>(
              value: _selectedColor,
              items: namedColors.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 10,
                        decoration: BoxDecoration(
                          color: entry.value,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(entry.key, style: TextStyle(fontSize: 15)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newColor) {
                setState(() {
                  _selectedColor = newColor!;
                });
              },
            ),
            SizedBox(height: 16.0), // Add some space between the dropdown and the button

            // Add Label button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Instantiate the label in memory and add it to the app's list
                  var name = _nameController.text;
                  var label = LabelItem(name: (name == "") ? "Label" : name, color: namedColors[_selectedColor]!);
                  Provider.of<LabelProvider>(context, listen: false).createNewLabel(label);

                  Navigator.pop(context);
                  
                  },
                child: Text('Add Label'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
