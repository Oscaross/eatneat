import 'package:eatneat/ui/buttons.dart';
import 'package:flutter/material.dart';
import 'package:eatneat/models/pantry_item.dart';
import 'package:flutter/services.dart';

class AddItemPage extends StatefulWidget {
  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {

  PantryItem? item;

  AddItemPageState({this.item}) {
    if(item != null) _nameController.text = item!.name;
    
    _sliderColor = getSliderColor(_currentPercentageLeft);
  }

  String name = "";

  // Controllers - contain final values to push to the pantry item after the user hits the submit action.
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  double _currentPercentageLeft = 100;

  // Focus nodes (helps us decide when we are editing fields and when we aren't)
  final FocusNode _nameFocusNode = FocusNode();

  late Color _sliderColor;

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
              Row(
                children: [
                  Text(
                    "Name:"
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                    )
                  ),
                ],
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
                  
                ],
              ),

              // Widget to display % left slider

              // Label displaying how much we have left
              Card.filled(
                color: Color.fromARGB(255, 39, 29, 122).withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${_currentPercentageLeft.toInt()}% left",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    )
                  ),
                )
              ),

              // The slider itself that we control the quantity with
              Slider(
                value: _currentPercentageLeft,
                max: 100,
                min: 0,
                divisions: 20,
                activeColor: _sliderColor,
                onChanged: (val) {
                  setState(() {
                    _currentPercentageLeft = val;
                    _sliderColor = getSliderColor(val);
                  });

                  HapticFeedback.selectionClick();
                }
              ),
              // Quick action buttons to go to empty, half full and full
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: Buttons.genericButtonStyle(1, Color.fromARGB(255, 39, 29, 122)),
                    onPressed: () {
                      setState(() {
                        _currentPercentageLeft = 0;
                        _sliderColor = getSliderColor(0);
                      });

                      HapticFeedback.lightImpact();
                    },
                    child: Text("Empty")
                  ),
                  TextButton(
                    style: Buttons.genericButtonStyle(1, Color.fromARGB(255, 39, 29, 122)),
                    onPressed: () {
                      setState(() {
                        _currentPercentageLeft = 50;
                        _sliderColor = getSliderColor(50);
                      });

                      HapticFeedback.lightImpact();
                    },
                    child: Text("Half")
                  ),
                  TextButton(
                    style: Buttons.genericButtonStyle(1, Color.fromARGB(255, 39, 29, 122)),
                    onPressed: () {
                      setState(() {
                        _currentPercentageLeft = 100;
                        _sliderColor = getSliderColor(100);
                      });

                      HapticFeedback.lightImpact();
                    },
                    child: Text("Full")
                  ),
                ],
              )
          ]
      ),
    );
  }

  Color getSliderColor(double percentage) {
    if(percentage > 50) {
      return Colors.greenAccent;
    }
    else if(percentage >= 25) {
      return Color.fromARGB(255, 247, 225, 23);
    }
    else {
      return Colors.red;
    }
  }
}

