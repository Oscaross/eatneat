import 'package:flutter/material.dart';
import 'package:namer_app/models/pantry_item.dart';

class AddItemPage extends StatefulWidget {
  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {

  PantryItem? item;

  AddItemPageState({this.item}) {
    if(item != null) _nameController.text = item!.name;
  }

  String name = "";

  // Controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Focus nodes (helps us decide when we are editing fields and when we aren't)
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item"),
      ),
      body:
        Column(
          children: [
            // Widget to display product name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        decoration: InputDecoration(
                          hintText: "Item name...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade700, // Slightly grey color for hint text
                          ),
                          filled: true, // Ensures the background is filled
                          fillColor: Colors.white, // Background color inside the TextField
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding inside the TextField
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            borderSide: BorderSide(
                              color: Colors.grey.shade100, // Slightly grey border color
                              width: 0.5, // Width of the border
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade600, // Darker grey when focused
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.red, // Red border when there's an error
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.red, // Red border when focused with an error
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _nameFocusNode.requestFocus();
                      }
                    )
                  ],
                ),
              ),
              // Widget to display product image
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        // The default image or an image which exists if it does - lazy or so this shouldn't result in null pointer (famous last words)
                        (item == null || item!.image == null) ? "https://miro.medium.com/v2/resize:fit:1098/format:webp/1*--DvqdXSA38rPuqMK5c0tQ.png" : item!.image!
                      ),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),

                child: Container(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: IconButton.outlined(
                      // TODO: This button could maybe be neater?
                      style: ButtonStyle(
                        iconSize: WidgetStatePropertyAll(30),
                        side: WidgetStatePropertyAll(BorderSide.none)
                      ),
                      icon: Icon(Icons.camera_alt),
                      // TODO: Add ability for user to press camera and create a new page that navigates to the add image option
                      onPressed: () {
                    
                      }
                    ),
                  )
                )
              ),

              // Widget to display quantity editor
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                    ),
                  ),

                ],
              )
          ]
      ),
    );
  }
}